//
//  SBTTrack.h
//  SuperBowl
//
//  Created by Yohta Watanave on 2017/03/18.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

#import "SBTAudioFile.h"
#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>

@class SBTAudioFile;

@interface SBTTrack : NSObject

- (instancetype)initWithAudioURL:(NSURL *)url;
- (AURenderCallbackStruct)auRenderCallbackStruct;

@property (strong, nonatomic, readonly) SBTAudioFile *audioFile;

@end
