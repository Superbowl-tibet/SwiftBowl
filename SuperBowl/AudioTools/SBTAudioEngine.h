//
//  SBTAudioEngine.h
//  SuperBowl
//
//  Created by Yohta Watanave on 2017/03/18.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>
#import <AudioToolbox/AudioToolbox.h>

@class SBTTrack;
@interface SBTAudioEngine : NSObject {
    AUGraph _graph;
    AUNode _mixerNode;
    AudioUnit _remoteIOUnit;
    AudioUnit _mixerUnit;
}

- (void)startGraph;
- (void)stopGraph;
- (void)addTrack:(SBTTrack*)track;
- (void)setGain:(UInt32)busNumber gain:(AudioUnitParameterValue)gain;

+ (AudioStreamBasicDescription)audioOutputFormat;

@end
