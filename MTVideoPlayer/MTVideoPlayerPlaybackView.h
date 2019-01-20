//
//  MTVideoPlayerPlaybackView.h
//  MTVideoPlayer
//
//  Created by ping sheng cheng on 2017/12/3.
//  Copyright © 2017年 ping sheng cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MTVideoPlayerPlaybackViewType) {
    MTVideoPlayerPlaybackTypeOverlay = 0,
    MTVideoPlayerPlaybackTypeBottomBar,
    MTVideoPlayerPlaybackTypeTopBar
};

@protocol MTVideoPlayerPlaybackDelegate
/// This is called when user press play or pause button.
- (void)playOrPauseMedia;

/// This is called when user change slider value.
- (void)seekProgressToCurrentTimeInSec:(float)currentTime;

/// This is called when user start dragging slider.
- (void)startSeekingMediaProgress;

/// This is called when user stop dragging slider.
- (void)completeSeekingMediaProgress;

/// This is called when user tap screen.
- (void)showOrHideMediaControl;

@optional
/// This is called when user change mute value.
- (void)muteAudio:(BOOL)isMuted;
@end

@interface MTVideoPlayerPlaybackView : UIView

@property (weak, nonatomic) id <MTVideoPlayerPlaybackDelegate> delegate;

@property (nonatomic) MTVideoPlayerPlaybackViewType playbackViewType;

/// Update UI when player is playing.
- (void)displayMediaIsPlaying;

/// Update UI when player is paused.
- (void)displayMediaIsPaused;

/// Update UI when player play to end.
- (void)displayMediaPlayToEnd;

/// Hide or show certain media control view.
- (void)setContentHidden:(BOOL)isHidden;

/// Call the method to update progress UI.
- (void)updateProgressWithCurrentTimeInSec:(float)currentTime durationInSec:(float)duration;
@end
