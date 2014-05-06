//
//  Entry.h
//  Journal
//
//  Created by Adam Baitch on 4/16/14.
//  Copyright (c) 2014 Adam Baitch. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface Entry : NSManagedObject

@property (nonatomic, retain) NSString * entryTitle;
@property (nonatomic, retain) NSString * comments;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * filePath;
@property (nonatomic, retain) NSString * fileType;
@property (nonatomic, retain) NSString * date;

@end
