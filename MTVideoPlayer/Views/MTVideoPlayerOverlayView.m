//
//  MTVideoPlayerOverlayView.m
//  MTVideoPlayer
//
//  Created by ping sheng cheng on 2017/12/13.
//  Copyright © 2017年 ping sheng cheng. All rights reserved.
//

#import "MTVideoPlayerOverlayView.h"

@implementation MTVideoPlayerOverlayView {
    UIButton *_playPauseButton;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.playbackViewType = MTVideoPlayerPlaybackTypeOverlay;
        [self addContentView];
    }
    
    return self;
}

- (void)addContentView {
    CGSize size = self.bounds.size;
    // Setup play or pause button
    CGFloat playPauseButtonWidth = 70;
    CGFloat playPauseButtonHeight = 70;
    _playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playPauseButton setFrame:CGRectMake(size.width/2 - playPauseButtonWidth/2,
                                          size.height/2 - playPauseButtonHeight/2,
                                          playPauseButtonWidth,
                                          playPauseButtonHeight)];
    [_playPauseButton setImage:[UIImage imageNamed:@"btn_center_play.png"] forState:UIControlStateNormal];
    [_playPauseButton setContentMode:UIViewContentModeScaleAspectFit];
    [_playPauseButton addTarget:self action:@selector(playOrPauseAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playPauseButton];
    
    // user can tap screen
    UITapGestureRecognizer *tapGesture;
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleScreenTap)];
    [self addGestureRecognizer:tapGesture];
}

#pragma mark - Setup layout size

- (void)layoutSubviews {
    CGSize size = self.bounds.size;
    // Resize play or pause button
    CGFloat playPauseButtonWidth = 70;
    CGFloat playPauseButtonHeight = 70;
    [_playPauseButton setFrame:CGRectMake(size.width/2 - playPauseButtonWidth/2,
                                          size.height/2 - playPauseButtonHeight/2,
                                          playPauseButtonWidth,
                                          playPauseButtonHeight)];
}

#pragma mark -

- (void)displayMediaIsPlaying {
    [super displayMediaIsPlaying];
    [_playPauseButton setImage:[UIImage imageNamed:@"btn_center_pause.png"] forState:UIControlStateNormal];
}

- (void)displayMediaIsPaused {
    [super displayMediaIsPaused];
    [_playPauseButton setImage:[UIImage imageNamed:@"btn_center_play.png"] forState:UIControlStateNormal];
}

- (void)displayMediaPlayToEnd {
    [super displayMediaPlayToEnd];
    [_playPauseButton setImage:[UIImage imageNamed:@"btn_center_replay.png"] forState:UIControlStateNormal];
}

- (void)playOrPauseAction {
    NSLog(@"press center play or pause button");
    [self.delegate playOrPauseMedia];
}

#pragma mark -

- (void)handleScreenTap {
    NSLog(@"tap screen");
    [self.delegate showOrHideMediaControl];
}

#pragma mark -

- (void)setContentHidden:(BOOL)isHidden {
    _playPauseButton.alpha = isHidden ? 0 : 1;
}

@end
