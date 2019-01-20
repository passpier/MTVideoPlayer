//
//  MTVideoPlayer.m
//  MTVideoPlayer
//
//  Created by ping sheng cheng on 2017/12/3.
//  Copyright © 2017年 ping sheng cheng. All rights reserved.
//

#import "MTVideoPlayer.h"
#import "MTVideoPlayerAssetControl.h"

@interface MTVideoPlayer () <MTVideoPlayerAssetControlDelegate, MTVideoPlayerViewDelegate>

@property (strong, nonatomic) MTVideoPlayerView *playerView;

@end

@implementation MTVideoPlayer {
    MTVideoPlayerAssetControl *_assetControl;
    AVPlayerLayer *_playerLayer;
    BOOL _isAutoPlay;
    
    id _timeObserverToken;
    BOOL _isNewAsset;
    BOOL _isReset;
}

- (void)dealloc {
    [self reset];
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupVideoPlayer];
    }
    
    return self;
}

- (void)setupVideoPlayer {
    // Set AssetControl delegate for ready to play video
    _assetControl = [[MTVideoPlayerAssetControl alloc] init];
    _assetControl.delegate = self;
    
    // Add notification of finished playing
    [self addVideoDidPlayToEndNotification];
    
    // Add notification of application will resign active
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(playerWillResignActive)
                                                 name: UIApplicationWillResignActiveNotification
                                               object: nil];
    
    // Init video player view
    _playerLayer = [[AVPlayerLayer alloc] init];
    self.playerView = [[MTVideoPlayerView alloc] initPlayerViewWithLayer:_playerLayer];
    self.playerView.delegate = self;
}

#pragma mark - Player Notification

- (void)addVideoDidPlayToEndNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self.playerView
                                             selector:@selector(videoItemDidPlayToEnd)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    
}

- (void)removeVideoDidPlayToEndNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self.playerView
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:nil];
}

#pragma mark - Public function

- (void)setVideoUrlString:(NSString *)videoUrlString autoPlay:(BOOL)isAutoPlay {
    [self.playerView displayLoadingVideoSource];
    _isNewAsset = YES;
    _isAutoPlay = isAutoPlay;
    NSURL *urlAsset = [NSURL URLWithString:videoUrlString];
    AVAsset *asset = [AVAsset assetWithURL:urlAsset];
    [_assetControl setVideoAsset:asset];
}

- (void)scalePlayerToFillScreenSize:(CGSize)screenSize {
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    CGFloat width = screenSize.width;
    CGFloat height = screenSize.width * 0.5625;
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft || deviceOrientation == UIDeviceOrientationLandscapeRight) {
        CGFloat playerOffsetY = screenSize.height/2 - height/2;
        [self.playerView setFrame:CGRectMake(0, playerOffsetY, width, height)];
    } else {
        CGFloat playerOffsetY = screenSize.height/2 - height/2;
        [self.playerView setFrame:CGRectMake(0, playerOffsetY, width, height)];
    }
}

- (void)reset {
    _isReset = YES;
    
    // Remove notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Remove timer
    [self.playerView clearHideControlsTimer];
    
    // Remove periodic time observer token
    [self removePlayerTimeObserver];
    
    // Pause media
    [_playerLayer.player pause];
}

#pragma mark - Private function

- (void)removePlayerTimeObserver {
    if (_timeObserverToken != nil) {
        [_playerLayer.player removeTimeObserver:_timeObserverToken];
        _timeObserverToken = nil;
    }
}

#pragma mark - MTVideoPlayerAssetControl Delegate

- (void)videoReadyToPlay:(AVPlayer *)player {
    if (self.playerView.playerState != MTVideoPlayerStateLoading && self.playerView.playerState != MTVideoPlayerStateCompleteSeekingProgress) return;
    [self updatePlayerProgressPerSecByDuration:[_assetControl getDuration]];
    [self.playerView displayVideoIsReadyToPlay:_isAutoPlay];
}

- (void)updatePlayerProgressPerSecByDuration:(float)newDuration {
    if (!_isNewAsset) return;
    _isNewAsset = NO;
    // Remove periodic time observer token
    [self removePlayerTimeObserver];
    // Invoke callback every second
    CMTime interval = CMTimeMakeWithSeconds(1, NSEC_PER_SEC);
    // Queue on which to invoke the callback
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    // Add time observer
    __weak MTVideoPlayer *weakSelf = self;
    __block BOOL blockIsReset = _isReset;
    _timeObserverToken = [_playerLayer.player addPeriodicTimeObserverForInterval:interval queue:mainQueue usingBlock:^(CMTime time) {
        float timeElapsed = (float)CMTimeGetSeconds(time);
        if (blockIsReset) {
            [weakSelf reset];
        }
        [weakSelf.playerView updateProgressWithCurrentTimeInSec:timeElapsed durationInSec:newDuration];
        if (weakSelf.delegate != nil) {
            [weakSelf.delegate updatePlayerProgressPerSec:timeElapsed];
        }

    }];
}

- (void)checkPlayer {
    if (_timeObserverToken != nil) {
        return;
    }
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    // Add time observer
    CMTime interval = CMTimeMakeWithSeconds(1, NSEC_PER_SEC);
    __weak MTVideoPlayer *weakSelf = self;
    float newDuration = [_assetControl getDuration];
    _timeObserverToken = [_playerLayer.player addPeriodicTimeObserverForInterval:interval queue:mainQueue usingBlock:^(CMTime time) {
        float timeElapsed = (float)CMTimeGetSeconds(time);
        [weakSelf.playerView updateProgressWithCurrentTimeInSec:timeElapsed durationInSec:newDuration];
        if (weakSelf.delegate != nil) {
            [weakSelf.delegate updatePlayerProgressPerSec:timeElapsed];
        }
        
    }];
}

- (void)currentVideoDidChange:(AVPlayer *)player {
    if (player.currentItem == nil) return;
    [_playerLayer setPlayer:player];
}

#pragma mark - MTVideoPlayerAssetControl Delegate

- (float)playbackRate {
    return [_assetControl getRate];
}

- (void)setPlaybackRate:(float)rate {
    [_assetControl setRate:rate];
}

- (void)setCurrentTime:(float)currentTime {
    [_assetControl setCurrentTime:currentTime];
}

- (void)updatePlayerState:(MTVideoPlayerState)state {
    NSLog(@"MTVideoPlayerState: %lu", (unsigned long)state);
    switch (state) {
        case MTVideoPlayerStateItemPlaying:
            [_playerLayer.player play];
            break;
        case MTVideoPlayerStateItemPaused:
            [_playerLayer.player pause];
            break;
        case MTVideoPlayerStateSeekingProgress:
            _isAutoPlay = NO;
            [self removeVideoDidPlayToEndNotification];
            break;
        case MTVideoPlayerStateCompleteSeekingProgress:
            [self addVideoDidPlayToEndNotification];
            [self checkPlayer];
            break;
        default:
            break;
    }
}

@end
