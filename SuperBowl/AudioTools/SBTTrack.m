//
//  SBTTrack.m
//  SuperBowl
//
//  Created by Yohta Watanave on 2017/03/18.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

#import "SBTTrack.h"

static OSStatus renderCallback(void *inRefCon,
                                 AudioUnitRenderActionFlags *ioActionFlags,
                                 const AudioTimeStamp *inTimeStamp,
                                 UInt32 inBusNumber,
                                 UInt32 inNumberFrames,
                                 AudioBufferList *ioData) {
    OSStatus err = noErr;
    SBTTrack *track = (__bridge SBTTrack*)inRefCon;
    
    UInt32 ioNumberFrames = inNumberFrames;
    ExtAudioFileRef extAudioFile = track.audioFile.extAudioFile;
    
    SInt64 outFrameOffset;
    @synchronized(track) {
        err = ExtAudioFileRead(extAudioFile, &ioNumberFrames, ioData);
        ExtAudioFileTell(extAudioFile, &outFrameOffset);
    }
    
    
    if(outFrameOffset == track.audioFile.totalFrames) {
        @synchronized(track) {
            ExtAudioFileSeek(extAudioFile, 0);
        }
        return -1;
    }
    
    return err;
}

@implementation SBTTrack

- (instancetype)initWithAudioURL:(NSURL *)url {
    self = [super init];
    if(self) {
        _audioFile = [[SBTAudioFile alloc]initWithContentsOfURL:url];
    }
    return self;
}

- (AURenderCallbackStruct)auRenderCallbackStruct {
    AURenderCallbackStruct callbackStruct;
    callbackStruct.inputProc = renderCallback;
    callbackStruct.inputProcRefCon = (__bridge void*)self;
    return callbackStruct;
}


@end
