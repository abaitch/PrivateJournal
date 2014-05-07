//
//  AJBVideoEntryViewController.h
//  Journal
//
//  Created by Adam Baitch on 5/6/14.
//  Copyright (c) 2014 Adam Baitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>


@interface AJBVideoEntryViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) MPMoviePlayerController *videoController;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) CLLocation *location;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet NSString *commentsToStore;

@end
