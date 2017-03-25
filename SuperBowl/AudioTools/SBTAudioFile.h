//
//  SBTAudioFile.h
//  SuperBowl
//
//  Created by Yohta Watanave on 2017/03/18.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SBTAudioFile : NSObject

- (instancetype)initWithContentsOfURL:(NSURL*)url;

@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, assign, readonly) ExtAudioFileRef extAudioFile;
@property (nonatomic, assign, readonly) SInt64 totalFrames;
@property (nonatomic, assign, readonly) AudioStreamBasicDescription outputFormat;

@end
