//
//  AJBEntry.h
//  Journal
//
//  Created by Adam Baitch on 4/16/14.
//  Copyright (c) 2014 Adam Baitch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJBEntry : NSObject

@property (nonatomic, retain) NSString * entryTitle;
@property (nonatomic, retain) NSString * comments;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic, retain) NSString * filePath;
@property (nonatomic, retain) NSString * fileType;
@property (nonatomic, retain) NSString * date;

@end
