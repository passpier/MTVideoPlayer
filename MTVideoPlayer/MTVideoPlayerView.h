//
//  MTVideoPlayerView.h
//  MTVideoPlayer
//
//  Created by ping sheng cheng on 2017/12/3.
//  Copyright © 2017年 ping sheng cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MTVideoPlayerState) {
    MTVideoPlayerStateUnknown = 0,
    MTVideoPlayerStateLoading,
    MTVideoPlayerStateItemReadyToPlay,
    MTVideoPlayerStateItemPlaying,
    MTVideoPlayerStateItemPaused,
    MTVideoPlayerStateItemPlayToEnd,
    MTVideoPlayerStateSeekingProgress,
    MTVideoPlayerStateCompleteSeekingProgress
};

@protocol MTVideoPlayerViewDelegate
- (float)playbackRate;
- (void)setPlaybackRate:(float)rate;
- (void)setCurrentTime:(float)currentTime;
- (void)updatePlayerState:(MTVideoPlayerState)state;
@end

@class AVPlayerLayer;

@interface MTVideoPlayerView : UIView

@property (nonatomic, readonly) MTVideoPlayerState playerState;

@property (weak, nonatomic) id <MTVideoPlayerViewDelegate> delegate;

- (instancetype)initPlayerViewWithLayer:(AVPlayerLayer *)playerLayer;

- (void)updateProgressWithCurrentTimeInSec:(float)currentTime durationInSec:(float)duration;
- (void)displayLoadingVideoSource;
- (void)displayVideoIsReadyToPlay:(BOOL)isAutoPlay;
- (void)clearHideControlsTimer;

@end
