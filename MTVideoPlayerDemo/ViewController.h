//
//  ViewController.h
//  MTVideoPlayer
//
//  Created by ping sheng cheng on 2017/12/2.
//  Copyright © 2017年 ping sheng cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTVideoPlayer.h"

@interface ViewController : UIViewController<MTVideoPlayerDelegate>

@property (nonatomic,strong) MTVideoPlayer *mtVideoPlayer;

@end

