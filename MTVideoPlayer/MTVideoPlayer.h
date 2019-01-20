//
//  MTVideoPlayer.h
//  MTVideoPlayer
//
//  Created by ping sheng cheng on 2017/12/3.
//  Copyright © 2017年 ping sheng cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTVideoPlayerView.h"

@protocol MTVideoPlayerDelegate
@optional
- (void)updatePlayerProgressPerSec:(float)ts;
@end

@interface MTVideoPlayer : NSObject

@property (strong, nonatomic, readonly) MTVideoPlayerView *playerView;
@property (weak, nonatomic) id <MTVideoPlayerDelegate> delegate;

/**
 Set a URL string that references a media resource and initializes to play.
 
 @param videoUrlString URL string that references a media resource by using HLS.
 @param isAutoPlay Let MTVideoPlayer play media automatically
 */
- (void)setVideoUrlString:(NSString *)videoUrlString autoPlay:(BOOL)isAutoPlay;

- (void)scalePlayerToFillScreenSize:(CGSize)screenSize;

@end
