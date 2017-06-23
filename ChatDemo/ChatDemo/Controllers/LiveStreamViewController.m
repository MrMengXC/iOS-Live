//
//  LiveStreamViewController.m
//  ChatDemo
//
//  Created by ios on 17/6/17.
//  Copyright © 2017年 YC_Z. All rights reserved.
//

#import "LiveStreamViewController.h"
#import <LFLiveKit.h>

@interface LiveStreamViewController()<LFLiveSessionDelegate>
@property (nonatomic ,strong)LFLiveSession*session;
@property (nonatomic ,strong)UIView*livingPreView;

@end
@implementation LiveStreamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self startLive];
    
}
- (LFLiveSession*)session {
    if (!_session) {
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
        _session.preView = [self livingPreView];
        _session.delegate = self;
        _session.running = YES;
        _session.beautyFace = YES;

    }
    return _session;
}
-(UIView *)livingPreView{
    
    if (!_livingPreView) {
        
        UIView *livingPreView = [[UIView alloc]initWithFrame:self.view.bounds];
        
        livingPreView.backgroundColor = [UIColor clearColor];
        
        livingPreView.autoresizingMask = UIViewAutoresizingFlexibleWidth|                              UIViewAutoresizingFlexibleHeight;
        
        [self.view insertSubview:livingPreView atIndex:0];
        
        _livingPreView = livingPreView;
        
    }
    
    return _livingPreView;
    
}
- (void)startLive {
//    NSString *rtmpUrl = @"rtmp://p7a8edcff.live.126.net/live/10707fad32f246fbb93f45a154f72c63?wsSecret=c54579204519135de37ec77338790f92&wsTime=1497621352";
    NSString *rtmpUrl = @"rtmp://192.168.0.104:1935/myapp/test";

    NSString *newUrl = [rtmpUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    LFLiveStreamInfo *streamInfo = [[LFLiveStreamInfo alloc]init];
    streamInfo.url = newUrl;
    

    [[self session] startLive:streamInfo];
//    [self.view setup];
    

}

- (void)stopLive {
    [self.session stopLive];
}
/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state
{
    NSLog(@"liveStateDidChange:%d",state);
}
/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug *)debugInfo
{
    NSLog(@"debugInfo:");

}
/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode
{
    NSLog(@"errorCode:");

}
@end
