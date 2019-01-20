//
//  MTVideoPlayerAssetControl.h
//  MTVideoPlayer
//
//  Created by ping sheng cheng on 2017/12/2.
//  Copyright © 2017年 ping sheng cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol MTVideoPlayerAssetControlDelegate

- (void)videoReadyToPlay:(AVPlayer *)player;
@optional
- (void)currentVideoDidChange:(AVPlayer *)player;
@end

@interface MTVideoPlayerAssetControl : NSObject

@property (weak, nonatomic) id <MTVideoPlayerAssetControlDelegate> delegate;

- (void)setVideoAsset:(AVAsset *)asset;

/// Set the current playback time
- (void)setCurrentTime:(float)currentTime;

/// set current playback rate
- (void)setRate:(float)rate;

/// get current playback rate
- (float)getRate;

/// get duration of the item's media
- (float)getDuration;

/// reset playback control
- (void)reset;

@end
