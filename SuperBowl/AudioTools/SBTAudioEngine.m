//
//  SBTAudioEngine.m
//  SuperBowl
//
//  Created by Yohta Watanave on 2017/03/18.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

#import "SBTAudioEngine.h"
#import "SBTTrack.h"

@interface SBTAudioEngine()

@property (nonatomic, assign) UInt32 mixerBusCount;
@property (atomic, assign) AudioUnit mixerUnit;

@end

static OSStatus mixerOutputCallback(void *inRefCon,
                                    AudioUnitRenderActionFlags *ioActionFlags,
                                    const AudioTimeStamp *inTimeStamp,
                                    UInt32 inBusNumber,
                                    UInt32 inNumberFrames,
                                    AudioBufferList *ioData) {
    SBTAudioEngine *def = (__bridge SBTAudioEngine*)inRefCon;
    AudioUnit audioUnit = def.mixerUnit;
    
    OSStatus err = AudioUnitRender(audioUnit,
                                   ioActionFlags,
                                   inTimeStamp,
                                   inBusNumber,
                                   inNumberFrames,
                                   ioData);
    return err;
}

@implementation SBTAudioEngine

@synthesize mixerUnit = _mixerUnit;

- (instancetype)init {
    self = [super init];
    if(self) {
        self.mixerBusCount = 0;
        [self prepareAUGraph];
    }
    return self;
}

- (BOOL)isGraphRunning {
    Boolean isPlaying = false;
    AUGraphIsRunning(_graph, &isPlaying);
    return isPlaying;
}

- (void)startGraph {
    NSLog(@"%s", __FUNCTION__);
    
    if (_graph) {
        if(![self isGraphRunning]) {
            AUGraphStart(_graph);
        }
    }
}

- (void)stopGraph {
    NSLog(@"%s", __FUNCTION__);
    
    if([self isGraphRunning]) {
        AUGraphStop(_graph);
    }
}

- (void)addTrack:(SBTTrack*)track {
    AURenderCallbackStruct callbackStruct = [track auRenderCallbackStruct];
    AUGraphSetNodeInputCallback(_graph,
                                _mixerNode,
                                self.mixerBusCount,
                                &callbackStruct);
    
    AudioStreamBasicDescription asbd = {0};
    UInt32 size = sizeof(asbd);
    AudioStreamBasicDescription outputFormat = [[self class]audioOutputFormat];
    
    AudioUnitSetProperty(_mixerUnit,
                         kAudioUnitProperty_StreamFormat,
                         kAudioUnitScope_Input,
                         self.mixerBusCount,
                         &outputFormat, size);
    ++self.mixerBusCount;
}

- (void)setGain:(UInt32)busNumber gain:(AudioUnitParameterValue)gain {
    AudioUnitSetParameter(_mixerUnit,
                          kMultiChannelMixerParam_Volume,
                          kAudioUnitScope_Input,
                          busNumber,
                          gain,
                          0);
}

- (OSStatus)prepareAUGraph
{
    // 1. AUGraphの準備
    NewAUGraph(&_graph);
    AUGraphOpen(_graph);
    
    // 2. AUNodeの作成
    AudioComponentDescription cd;
    
//    cd.componentType = kAudioUnitType_FormatConverter;
//    cd.componentSubType = kAudioUnitSubType_AUiPodTimeOther;
//    cd.componentManufacturer = kAudioUnitManufacturer_Apple;
//    cd.componentFlags = 0;
//    cd.componentFlagsMask = 0;
//    AUNode aUiPodTimeNode;
//    AUGraphAddNode(_graph, &cd, &aUiPodTimeNode);
//    AUGraphNodeInfo(_graph, aUiPodTimeNode, NULL, &_auiPodTimeUnit);
    
    cd.componentType = kAudioUnitType_Mixer;
    cd.componentSubType = kAudioUnitSubType_MultiChannelMixer;
    cd.componentManufacturer = kAudioUnitManufacturer_Apple;
    cd.componentFlags = 0;
    cd.componentFlagsMask = 0;
    AUGraphAddNode(_graph, &cd, &_mixerNode);
    AUGraphNodeInfo(_graph, _mixerNode, NULL, &_mixerUnit);
    
    cd.componentType = kAudioUnitType_Output;
    cd.componentSubType = kAudioUnitSubType_RemoteIO;
    cd.componentManufacturer = kAudioUnitManufacturer_Apple;
    cd.componentFlags = 0;
    cd.componentFlagsMask = 0;
    AUNode remoteIONode;
    AUGraphAddNode(_graph, &cd, &remoteIONode);
    AUGraphNodeInfo(_graph, remoteIONode, NULL, &_remoteIOUnit);
    
    // 3. Callbackの作成
//    {
//        AURenderCallbackStruct callbackStruct;
//        callbackStruct.inputProc = recordTrackRenderCallback;
//        callbackStruct.inputProcRefCon = (__bridge void*)self;
//        AUGraphSetNodeInputCallback(_graph,
//                                    _mixerNode,
//                                    self.mixerBusCount,
//                                    &callbackStruct);
//        ++self.mixerBusCount;
//    }
    
    AURenderCallbackStruct callbackStruct;
    callbackStruct.inputProc = mixerOutputCallback;
    callbackStruct.inputProcRefCon = (__bridge void*)self;;
    AUGraphSetNodeInputCallback(_graph,
                                remoteIONode,
                                0,
                                &callbackStruct);
    
    
//    AUGraphAddRenderNotify(_graph,
//                           renderNotify,
//                           (__bridge void*)self);
    
    // 5. Nodeの接続
    // AUMixer -> Remote IO
    AUGraphConnectNodeInput(_graph,
                            _mixerNode, 0,
                            remoteIONode, 0);
    
    [self prepareAudioNodeProperty];
    
    return noErr;
}

- (void)prepareAudioNodeProperty {
    // 4. 各NodeをつなぐためのASBDの設定
    AudioStreamBasicDescription asbd = {0};
    UInt32 size = sizeof(asbd);
    
    AudioStreamBasicDescription outputFormat;
    outputFormat.mSampleRate = 44100;
    outputFormat.mFormatID = kAudioFormatLinearPCM;
    outputFormat.mFormatFlags = kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsNonInterleaved | (kAudioUnitSampleFractionBits << kLinearPCMFormatFlagsSampleFractionShift);
    outputFormat.mBytesPerPacket = 4;
    outputFormat.mFramesPerPacket = 1;
    outputFormat.mBytesPerFrame = 4;
    outputFormat.mChannelsPerFrame = 2;
    outputFormat.mBitsPerChannel = 32;
    outputFormat.mReserved = 0;
    // converter IO
    //    AudioUnitSetProperty(_converterUnit,
    //                         kAudioUnitProperty_StreamFormat,
    //                         kAudioUnitScope_Input,
    //                         0,
    //                         &outputFormat, size);
    //
    //    AudioUnitSetProperty(_converterUnit,
    //                         kAudioUnitProperty_StreamFormat,
    //                         kAudioUnitScope_Output,
    //                         0,
    //                         &outputFormat, size);
    
//    // aUiPodTime IO
//    AudioUnitSetProperty(_auiPodTimeUnit,
//                         kAudioUnitProperty_StreamFormat,
//                         kAudioUnitScope_Output,
//                         0,
//                         &outputFormat, size);
//    
//    AudioUnitSetProperty(_auiPodTimeUnit,
//                         kAudioUnitProperty_StreamFormat,
//                         kAudioUnitScope_Input,
//                         0,
//                         &outputFormat, size);
    
    // Mixier
    AudioUnitSetProperty(_mixerUnit,
                         kAudioUnitProperty_StreamFormat,
                         kAudioUnitScope_Output,
                         0,
                         &outputFormat, size);
    
    AudioUnitSetProperty(_mixerUnit,
                         kAudioUnitProperty_StreamFormat,
                         kAudioUnitScope_Input,
                         0,
                         &outputFormat, size);
    
    // remoteIO I
    AudioUnitSetProperty(_remoteIOUnit,
                         kAudioUnitProperty_StreamFormat,
                         kAudioUnitScope_Input,
                         0,
                         &outputFormat, size);
    
    AUGraphInitialize(_graph);
}

+ (AudioStreamBasicDescription)audioOutputFormat {
    AudioStreamBasicDescription audioFormat;
    audioFormat.mSampleRate = 44100;
    audioFormat.mFormatID = kAudioFormatLinearPCM;
    audioFormat.mFormatFlags = kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsNonInterleaved | (kAudioUnitSampleFractionBits << kLinearPCMFormatFlagsSampleFractionShift);
    audioFormat.mBytesPerPacket = 4;
    audioFormat.mFramesPerPacket = 1;
    audioFormat.mBytesPerFrame = 4;
    audioFormat.mChannelsPerFrame = 2;
    audioFormat.mBitsPerChannel = 32;
    audioFormat.mReserved = 0;
    return audioFormat;
}

@end
