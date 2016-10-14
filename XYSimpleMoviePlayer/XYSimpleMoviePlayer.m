//
//  XYSimpleMoviePlayer.m
//  XYSimpleMoviePlayerExample
//
//  Created by xiaoyu on 16/10/10.
//  Copyright © 2016年 xiaoyu. All rights reserved.
//

#import "XYSimpleMoviePlayer.h"
#import <MediaPlayer/MediaPlayer.h>

@interface XYSimpleMoviePlayer ()

@property (nonatomic,strong) MPMoviePlayerController *moviePlayerController;

@end

@implementation XYSimpleMoviePlayer

#pragma mark - init
-(instancetype)init{
    return [self initWithFrame:CGRectZero];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupPlayer];
        [self setFrame:frame];
    }
    return self;
}

#pragma mark - setup
-(void)setupPlayer{
    if (self.moviePlayerController) {
        return;
    }
    self.moviePlayerController = [[MPMoviePlayerController alloc] init];
    self.moviePlayerController.shouldAutoplay = NO;
    self.moviePlayerController.repeatMode = MPMovieRepeatModeNone;
    self.moviePlayerController.controlStyle = MPMovieControlStyleNone;
    self.moviePlayerController.fullscreen = NO;
    self.moviePlayerController.allowsAirPlay = NO;
    
    [self addSubview:self.mediaPlayerView];
}

#pragma mark - control
// Plays items from the current queue, resuming paused playback if possible.
- (void)play {
    [self.moviePlayerController play];
}

// Pauses playback if playing.
- (void)pause {
    [self.moviePlayerController pause];
}

// Ends playback. Calling -play again will start from the beginnning of the queue.
- (void)stop {
    [self.moviePlayerController stop];
}

#pragma mark - layoutRefresh
-(void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"mediaPlayerView %@",self.mediaPlayerView);
    self.mediaPlayerView.frame = self.bounds;
}

#pragma mark - setter & getter
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.mediaPlayerView.frame = self.bounds;
}

-(void)setPlayURL:(NSString *)playURL{
    _playURL = playURL;
    if (playURL) {
        self.moviePlayerController.contentURL = [NSURL URLWithString:[playURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
}

-(UIView *)mediaPlayerView{
    return self.moviePlayerController.view;
}


@end
