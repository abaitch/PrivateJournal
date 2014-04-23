//
//  AJBPhotoEntryViewController.h
//  Journal
//
//  Created by Adam Baitch on 4/16/14.
//  Copyright (c) 2014 Adam Baitch. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@interface AJBPhotoEntryViewController : NSManagedObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) UIImageView *imageView;

@end
