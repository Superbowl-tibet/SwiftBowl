//
//  SBTAudioFile.m
//  SuperBowl
//
//  Created by Yohta Watanave on 2017/03/18.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

#import "SBTAudioFile.h"
#import "SBTAudioEngine.h"

@implementation SBTAudioFile

- (instancetype)initWithContentsOfURL:(NSURL*)url {
    self = [super init];
    if(self) {
        [self prepareAudioFile:url];
    }
    return self;
}

- (void)dealloc {
    ExtAudioFileDispose(self.extAudioFile);
}

- (void)prepareAudioFile:(NSURL*)url {
    _url = url;
    
    // ExAudioFileの作成
    ExtAudioFileRef extAudioFile;
    ExtAudioFileOpenURL((__bridge CFURLRef)url, &extAudioFile);
    
    _extAudioFile = extAudioFile;
    
    // ファイルフォーマットを取得
    AudioStreamBasicDescription inputFormat;
    UInt32 size = sizeof(AudioStreamBasicDescription);
    ExtAudioFileGetProperty(self.extAudioFile,
                            kExtAudioFileProperty_FileDataFormat,
                            &size,
                            &inputFormat);
    
    // Audio Unit正準形のASBDにサンプリングレート、チャンネル数を設定
    _outputFormat = [SBTAudioEngine audioOutputFormat];
    
    // 読み込むフォーマットをAudio Unit正準形に設定
    ExtAudioFileSetProperty(_extAudioFile,
                            kExtAudioFileProperty_ClientDataFormat,
                            sizeof(AudioStreamBasicDescription),
                            &_outputFormat);
    
    // トータルフレーム数を取得しておく
    SInt64 fileLengthFrames = 0;
    size = sizeof(SInt64);
    ExtAudioFileGetProperty(_extAudioFile,
                            kExtAudioFileProperty_FileLengthFrames,
                            &size,
                            &fileLengthFrames);
    _totalFrames = fileLengthFrames;
    
    // 位置を0に移動
    ExtAudioFileSeek(_extAudioFile, 0);
}

@end
