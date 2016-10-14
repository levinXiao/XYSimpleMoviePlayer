//
//  XYSimpleMoviePlayer.m
//  XYSimpleMoviePlayerExample
//
//  Created by xiaoyu on 16/10/10.
//  Copyright © 2016年 xiaoyu. All rights reserved.
//

#import "XYSimpleMoviePlayer.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface XYSimpleMoviePlayer ()

@property (nonatomic,strong) MPMoviePlayerController *moviePlayerController;

@property (nonatomic,assign) float unMuteVolumn;

@property (nonatomic,assign) float currentVolumn;

@end

@implementation XYSimpleMoviePlayer {
    NSTimer *durationTimer;
}

#pragma mark - init
-(instancetype)init{
    return [self initWithFrame:CGRectZero];
}

-(instancetype)initWithImage:(UIImage *)image{
    return [self init];
}

-(instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage{
    return [self init];
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
    self.moviePlayerController.view.userInteractionEnabled = NO;
    
    [self addSubview:self.mediaPlayerView];
    
    self.shortCutImageView = [[UIImageView alloc] init];
    self.shortCutImageView.backgroundColor = [UIColor clearColor];
    [self.mediaPlayerView addSubview:self.shortCutImageView];
    
    self.unMuteVolumn = [AVAudioSession sharedInstance].outputVolume;
    self.currentVolumn = self.unMuteVolumn;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemVolumnChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerPlaybackStateDidChangeNotification:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerReadyForDisplayDidChangeNotification:) name:MPMoviePlayerReadyForDisplayDidChangeNotification object:nil];
}

- (void)startDurationTimer {
    [durationTimer invalidate];
    durationTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(monitorVideoPlayback) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:durationTimer forMode:UITrackingRunLoopMode];
}

- (void)stopDurationTimer {
    [durationTimer invalidate];
}

-(void)onMPMoviePlayerPlaybackStateDidChangeNotification:(NSNotification *)noti{
    MPMoviePlayerController *playerController = [noti object];
    if (playerController == self.moviePlayerController) {
        if (self.moviePlayerController.playbackState == MPMoviePlaybackStatePlaying) {
            //正在播放
            [self startDurationTimer];
        } else {
            //不在播放
            [self stopDurationTimer];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(player:didPlayerStateChanged:)]) {
            [self.delegate player:self didPlayerStateChanged:self.moviePlayerController.playbackState == MPMoviePlaybackStatePlaying];
        }
    }
}

-(void)onMPMoviePlayerReadyForDisplayDidChangeNotification:(NSNotification *)noti{
    MPMoviePlayerController *playerController = [noti object];
    if (playerController == self.moviePlayerController) {
        BOOL ready = self.moviePlayerController.readyForDisplay;
        if (ready) {
            [self.mediaPlayerView sendSubviewToBack:self.shortCutImageView];
        }
    }
}

-(void)monitorVideoPlayback{
    double currentTime = self.moviePlayerController.currentPlaybackTime;
    double totalTime = self.moviePlayerController.duration;
    if (self.moviePlayerController.playbackState == MPMoviePlaybackStatePlaying ||
        self.moviePlayerController.playbackState == MPMoviePlaybackStateSeekingForward ||
        self.moviePlayerController.playbackState == MPMoviePlaybackStateSeekingBackward ) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(player:didPlayerTimePass:timeTotal:)]) {
            [self.delegate player:self didPlayerTimePass:currentTime timeTotal:totalTime];
        }
    }
}

-(void)systemVolumnChanged:(NSNotification *)noti{
    float volume = [[[noti userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    
    self.unMuteVolumn = volume;
}

#pragma mark - control
// Plays items from the current queue, resuming paused playback if possible.
- (void)play {
    [self.mediaPlayerView bringSubviewToFront:self.shortCutImageView];
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

-(void)jumpToTime:(float)progress {
    self.moviePlayerController.currentPlaybackTime = progress*self.moviePlayerController.duration;
    [self play];
    [self.mediaPlayerView sendSubviewToBack:self.shortCutImageView];
}

#pragma mark - setter & getter
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.mediaPlayerView.frame = self.bounds;
    self.shortCutImageView.frame = self.mediaPlayerView.bounds;
}

- (void)setMute:(BOOL)mute {
    _mute = mute;
    if (mute) {
        self.currentVolumn = 0;
    }else{
        self.currentVolumn = self.unMuteVolumn;
    }
}

-(void)setPlayURL:(NSString *)playURL{
    _playURL = playURL;
    if (playURL) {
        self.moviePlayerController.contentURL = [NSURL URLWithString:[playURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
}

-(void)setCurrentVolumn:(float)currentVolumn{
    if (currentVolumn == 0) {
        _mute = YES;
    }
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:currentVolumn];
}

-(float)currentVolumn{
    if (self.mute) {
        return 0;
    }
    return self.unMuteVolumn;
}

-(UIView *)mediaPlayerView{
    return self.moviePlayerController.view;
}

-(void)dealloc{
    NSLog(@"XYSimpleMoviePlayer dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
