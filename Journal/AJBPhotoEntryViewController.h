//
//  AJBPhotoEntryViewController.h
//  Journal
//
//  Created by Adam Baitch on 4/23/14.
//  Copyright (c) 2014 Adam Baitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@interface AJBPhotoEntryViewController : UIViewController

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) CLLocation *location;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *tagButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (weak, nonatomic) IBOutlet UITextField *titleField;

@end
