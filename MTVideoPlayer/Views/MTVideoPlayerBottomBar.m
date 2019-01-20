//
//  MTVideoPlayerBottomBar.m
//  MTVideoPlayer
//
//  Created by ping sheng cheng on 2017/12/13.
//  Copyright © 2017年 ping sheng cheng. All rights reserved.
//

#import "MTVideoPlayerBottomBar.h"

CGFloat const BottomBarHeight = 44;

@implementation MTVideoPlayerBottomBar {
    UIButton *_playPauseButton;
    UILabel *_currentTimeLabrel;
    UILabel *_durationLabel;
    UISlider *_timeSlider;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.playbackViewType = MTVideoPlayerPlaybackTypeBottomBar;
        [self addContentView];
    }
    
    return self;
}

- (void)addContentView {
    // background style
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    
    // play or pause button is the first button from left side
    _playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playPauseButton setFrame:CGRectMake(4, 3, 44, 38)];
    [_playPauseButton setImage:[UIImage imageNamed:@"btn_play.png"] forState:UIControlStateNormal];
    [_playPauseButton setContentMode:UIViewContentModeScaleAspectFit];
    [_playPauseButton addTarget:self action:@selector(playOrPauseAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playPauseButton];
    
    // The view is on the right of play or pause button
    [self addMediaProgressView];
}

- (void)addMediaProgressView {
    CGSize size = self.bounds.size;
    CGFloat labelWidth = 65;
    CGFloat labelHeight = 21;
    
    // display current time of playing progress
    _currentTimeLabrel = [[UILabel alloc] init];
    [_currentTimeLabrel setFrame:CGRectMake(56, 12, labelWidth, labelHeight)];
    [_currentTimeLabrel setText:@"00:00:00"];
    [_currentTimeLabrel setTextColor:[UIColor whiteColor]];
    [_currentTimeLabrel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:_currentTimeLabrel];
    
    // display duration of media
    _durationLabel = [[UILabel alloc] init];
    CGFloat durationLabelX = size.width - labelWidth - 16; // margin of right bar is 16
    [_durationLabel setFrame:CGRectMake(durationLabelX, 12, labelWidth, labelHeight)];
    [_durationLabel setText:@"00:00:00"];
    [_durationLabel setTextColor:[UIColor whiteColor]];
    [_durationLabel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:_durationLabel];
    
    // seek media progress
    _timeSlider = [[UISlider alloc] init];
    CGFloat sliderWidth = durationLabelX - (56 + labelWidth) - 16;
    [_timeSlider setFrame:CGRectMake(129, 8, sliderWidth, 31)];
    [_timeSlider addTarget:self action:@selector(timeSliderDidChange:) forControlEvents:UIControlEventValueChanged];
    [_timeSlider addTarget:self action:@selector(startUsingSlider) forControlEvents:UIControlEventTouchDown];
    [_timeSlider addTarget:self action:@selector(stopUsingSlider) forControlEvents:UIControlEventTouchUpInside];
    [_timeSlider addTarget:self action:@selector(stopUsingSlider) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:_timeSlider];
}

#pragma mark - Setup layout size

- (void)layoutSubviews {
    [self resizeMediaProgressView];
}

- (void)resizeMediaProgressView {
    CGSize size = self.bounds.size;
    CGFloat labelWidth = 65;
    CGFloat labelHeight = 21;
    
    // Resize duration of media label
    CGFloat durationLabelX = size.width - labelWidth - 16; // margin of right bar is 16
    [_durationLabel setFrame:CGRectMake(durationLabelX, 12, labelWidth, labelHeight)];
    
    // Resize seek media progress slider
    CGFloat sliderWidth = durationLabelX - (56 + labelWidth) - 16;
    [_timeSlider setFrame:CGRectMake(129, 8, sliderWidth, 31)];
}

#pragma mark -

- (void)displayMediaIsPlaying {
    [super displayMediaIsPlaying];
    [_playPauseButton setImage:[UIImage imageNamed:@"btn_pause.png"] forState:UIControlStateNormal];
}

- (void)displayMediaIsPaused {
    [super displayMediaIsPaused];
    [_playPauseButton setImage:[UIImage imageNamed:@"btn_play.png"] forState:UIControlStateNormal];
}

- (void)displayMediaPlayToEnd {
    [super displayMediaPlayToEnd];
    [_playPauseButton setImage:[UIImage imageNamed:@"btn_replay.png"] forState:UIControlStateNormal];
}

- (void)playOrPauseAction {
    NSLog(@"press play or pause button");
    if (self.delegate != nil) {
        [self.delegate playOrPauseMedia];
    }
}

#pragma mark - Slider

- (void)updateProgressWithCurrentTimeInSec:(float)currentTime durationInSec:(float)duration {
    [super updateProgressWithCurrentTimeInSec:currentTime durationInSec:duration];
    // Set player max progress limit
    [_timeSlider setMaximumValue:duration];
    [_durationLabel setText:[self textForPlaybackTime:duration]];
    
    // Update player progress
    [_timeSlider setValue:currentTime];
    [_currentTimeLabrel setText:[self textForPlaybackTime:currentTime]];
}

- (NSString *)textForPlaybackTime:(float)time {
    int hours = (int)floorf(time/3600);
    int minutes = (int)floorf(fmodf(time/60, 60));
    int seconds = (int)floorf(fmodf(time, 60));
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
}

- (void)timeSliderDidChange:(id)sender {
    UISlider *slider = (UISlider *)sender;
    float currentTime = slider.value;
    if (self.delegate != nil) {
        [self.delegate seekProgressToCurrentTimeInSec:currentTime];
    }
}

- (void)startUsingSlider {
    NSLog(@"start dragging slider");
    if (self.delegate != nil) {
        [self.delegate startSeekingMediaProgress];
    }
}

- (void)stopUsingSlider {
    NSLog(@"end dragging slider");
    if (self.delegate != nil) {
        [self.delegate completeSeekingMediaProgress];
    }
}

#pragma mark -

- (void)setContentHidden:(BOOL)isHidden {
    self.alpha = isHidden ? 0 : 1;
}

@end
