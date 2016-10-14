//
//  XYSimpleMoviePlayer.h
//  XYSimpleMoviePlayerExample
//
//  Created by xiaoyu on 16/10/10.
//  Copyright © 2016年 xiaoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYSimpleMoviePlayer;
@protocol XYSimpleMoviePlayerDelegate <NSObject>

@optional
-(void)player:(XYSimpleMoviePlayer *)player didPlayerStateChanged:(BOOL)isPlaying;

-(void)player:(XYSimpleMoviePlayer *)player didPlayerTimePass:(double)pass timeTotal:(double)total;

@end

@interface XYSimpleMoviePlayer : UIView

@property (nonatomic, copy) NSString *playURL;

@property (nonatomic, strong, readonly) UIView *mediaPlayerView;

@property (nonatomic, weak) id<XYSimpleMoviePlayerDelegate> delegate;

@property (nonatomic ,strong) UIImageView *shortCutImageView;

@property (nonatomic, assign) BOOL mute;

#pragma mark - control
// Plays items from the current queue, resuming paused playback if possible.
- (void)play;

// Pauses playback if playing.
- (void)pause;

// Ends playback. Calling -play again will start from the beginnning of the queue.
- (void)stop;

-(void)jumpToTime:(float)time;

@end


