//
//  ViewController.m
//  XYSimpleMoviePlayerExample
//
//  Created by xiaoyu on 2016/10/10.
//  Copyright © 2016年 xiaoyu. All rights reserved.
//

#import "ViewController.h"
#import "XYSimpleMoviePlayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    XYSimpleMoviePlayer *player = [[XYSimpleMoviePlayer alloc] initWithFrame:(CGRect){0,50,self.view.frame.size.width,300}];
    player.backgroundColor = [UIColor redColor];
    [self.view addSubview:player];
    
//    player.playURL = @"http://krtv.qiniudn.com/150522nextapp";
    player.playURL = @"http://lelink-e.ecare365.com/v1/devices/mobile/media?device_id=146373088263381839&media_name=201610140835250046.mp4&token=s18n98jlvkgpri7djphbf7jeb1&uuid=4637E71E-55C8-4E76-BCAF-5AB673ED130B";
    [player play];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
