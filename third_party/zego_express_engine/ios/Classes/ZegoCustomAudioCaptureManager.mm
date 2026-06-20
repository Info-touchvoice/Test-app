//
//  ZegoCustomAudioCaptureManager.m
//  Pods
//
//  Created by 27 on 2023/2/2.
//

#import "ZegoCustomAudioCaptureManager.h"
#import <ZegoExpressEngine/ZegoExpressEngine.h>

@interface ZegoCustomAudioCaptureManager()

@end

@implementation ZegoCustomAudioCaptureManager

+ (instancetype)sharedInstance {
    static ZegoCustomAudioCaptureManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZegoCustomAudioCaptureManager alloc] init];
    });
    return instance;
}

- (void)sendCustomAudioCaptureAACData:(unsigned char *)data
                           dataLength:(unsigned int)dataLength
                         configLength:(unsigned int)configLength
                            timestamp:(CMTime)timestamp
                              samples:(unsigned int)samples
                                param:(ZGFlutterAudioFrameParam *)param
                              channel:(ZGFlutterPublishChannel)channel {
    
    ZegoAudioFrameParam *audioFrameParam = [[ZegoAudioFrameParam alloc] init];
    audioFrameParam.sampleRate = (ZegoAudioSampleRate)param.sampleRate;
    audioFrameParam.channel = (ZegoAudioChannel)param.channel;

    [[ZegoExpressEngine sharedEngine] sendCustomAudioCaptureAACData:data dataLength:dataLength configLength:configLength timestamp:timestamp samples:samples param:audioFrameParam channel:(ZegoPublishChannel)channel];
}

- (void)sendCustomAudioCapturePCMData:(unsigned char *)data
                           dataLength:(unsigned int)dataLength
                                param:(ZGFlutterAudioFrameParam *)param
                              channel:(ZGFlutterPublishChannel)channel {
    
    ZegoAudioFrameParam *audioFrameParam = [[ZegoAudioFrameParam alloc] init];
    audioFrameParam.sampleRate = (ZegoAudioSampleRate)param.sampleRate;
    audioFrameParam.channel = (ZegoAudioChannel)param.channel;

    [[ZegoExpressEngine sharedEngine] sendCustomAudioCapturePCMData:data dataLength:dataLength param:audioFrameParam channel:(ZegoPublishChannel)channel];
}

- (void)fetchCustomAudioRenderPCMData:(unsigned char *)data
                           dataLength:(unsigned int)dataLength
                                param:(ZGFlutterAudioFrameParam *)param {
    
    ZegoAudioFrameParam *audioFrameParam = [[ZegoAudioFrameParam alloc] init];
    audioFrameParam.sampleRate = (ZegoAudioSampleRate)param.sampleRate;
    audioFrameParam.channel = (ZegoAudioChannel)param.channel;

    [[ZegoExpressEngine sharedEngine] fetchCustomAudioRenderPCMData:data dataLength:dataLength param:audioFrameParam];
}

- (void)sendReferenceAudioPCMData:(unsigned char *)data
                       dataLength:(unsigned int)dataLength
                            param:(ZGFlutterAudioFrameParam *)param {
    
    ZegoAudioFrameParam *audioFrameParam = [[ZegoAudioFrameParam alloc] init];
    audioFrameParam.sampleRate = (ZegoAudioSampleRate)param.sampleRate;
    audioFrameParam.channel = (ZegoAudioChannel)param.channel;

    [[ZegoExpressEngine sharedEngine] sendReferenceAudioPCMData:data dataLength:dataLength param:audioFrameParam];
}

@end
