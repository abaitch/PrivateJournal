//
//  AJBStartViewController.h
//  Journal
//
//  Created by Adam Baitch on 4/16/14.
//  Copyright (c) 2014 Adam Baitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface AJBStartViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *cameraLauncher;
@property (weak, nonatomic) IBOutlet UIButton *videoLauncher;
@property (weak, nonatomic) IBOutlet UIButton *audioLauncher;
@property (weak, nonatomic) IBOutlet UIButton *gateway;

// for videos
@property (copy,   nonatomic) NSURL *movieURL;
@property (strong, nonatomic) MPMoviePlayerController *movieController;

@end
