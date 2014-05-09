//
//  AJBOLDLogAudioViewController.h
//  Journal
//
//  Created by Hunter Horsley on 5/9/14.
//  Copyright (c) 2014 Adam Baitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJBOLDLogAudioViewController : UIViewController

@property (nonatomic, retain) NSString * entryTitle;
@property (nonatomic, retain) NSString * comments;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic, retain) NSString * filePath;
@property (nonatomic, retain) NSString * fileType;
@property (nonatomic, retain) NSDate * date;

@end
