//
//  ViewController.m
//  MTVideoPlayer
//
//  Created by ping sheng cheng on 2017/12/2.
//  Copyright © 2017年 ping sheng cheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

static NSString *const kSampeVideoUrl = @"https://video-dev.github.io/streams/x36xhzz/x36xhzz.m3u8";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mtVideoPlayer = [[MTVideoPlayer alloc] init];
    self.mtVideoPlayer.delegate = self;
    [self.mtVideoPlayer scalePlayerToFillScreenSize:[[UIScreen mainScreen] bounds].size];
    [self.view addSubview:self.mtVideoPlayer.playerView];
    
    [self.mtVideoPlayer setVideoUrlString:kSampeVideoUrl autoPlay:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.mtVideoPlayer scalePlayerToFillScreenSize:size];
}

#pragma mark - UdnVideoPlayerDelegate methods

- (void)updatePlayerProgressPerSec:(float)currenTime {
    NSLog(@"Current time: %lu",(unsigned long)currenTime);
}

@end
