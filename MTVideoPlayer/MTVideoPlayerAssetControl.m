//
//  MTVideoPlayerAssetControl.m
//  MTVideoPlayer
//
//  Created by ping sheng cheng on 2017/12/2.
//  Copyright © 2017年 ping sheng cheng. All rights reserved.
//

#import "MTVideoPlayerAssetControl.h"

static void *PlayerStatusContext = &PlayerStatusContext;
static void *ItemStatusContext = &ItemStatusContext;

@implementation MTVideoPlayerAssetControl {
    AVPlayer *_player;
    AVPlayerItem *_playerItem;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _player = [[AVPlayer alloc] init];
        [_player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:PlayerStatusContext];
    }
    
    return self;
}

- (void)setCurrentTime:(float)currentTime {
    CMTime newTime = CMTimeMakeWithSeconds(currentTime, 1);
    [_player seekToTime:newTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)setRate:(float)rate {
    [_player setRate:rate];
}

- (float)getRate {
    return [_player rate];
}

- (float)getDuration {
    if (_player.currentItem == nil) return 0;
    return CMTimeGetSeconds([_player.currentItem duration]);
}

- (void)reset {
    if (_playerItem != nil) {
        [_playerItem removeObserver:self forKeyPath:@"status" context:ItemStatusContext];
        _playerItem = nil;
    }
    
    if (_player != nil) {
        [_player removeObserver:self forKeyPath:@"status" context:PlayerStatusContext];
        _player = nil;
    }
}

#pragma mark - Asset Control

- (void)setVideoAsset:(AVAsset *)asset {
    if (_playerItem != nil) {
        [_playerItem removeObserver:self forKeyPath:@"status" context:ItemStatusContext];
    }
    
    if (asset != nil) {
        _playerItem = [AVPlayerItem playerItemWithAsset:asset];
        [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:ItemStatusContext];
        [_player replaceCurrentItemWithPlayerItem:_playerItem];
    } else {
        _playerItem = nil;
        [_player replaceCurrentItemWithPlayerItem:nil];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    
    if (context == ItemStatusContext) {
        if (_player.status == AVPlayerStatusReadyToPlay) {
            if (_delegate != nil) {
                [_delegate videoReadyToPlay:_player];
            }
        }
    } else if(context == PlayerStatusContext) {
        if (_delegate != nil) {
            [_delegate currentVideoDidChange:_player];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
