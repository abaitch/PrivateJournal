//
//  AJBEntry.m
//  Journal
//
//  Created by Adam Baitch on 4/16/14.
//  Copyright (c) 2014 Adam Baitch. All rights reserved.
//

#import "AJBEntry.h"

@implementation AJBEntry

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [self init]) {
        _entryTitle = [decoder decodeObjectForKey:@"entryTitle"];
        _latitude = [[decoder decodeObjectForKey:@"latitude"] floatValue];
        _longitude = [[decoder decodeObjectForKey:@"longitude"] floatValue];
        _filePath = [decoder decodeObjectForKey:@"filePath"];
        _fileType = [decoder decodeObjectForKey:@"fileType"];
        _date = [decoder decodeObjectForKey:@"date"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_entryTitle forKey:@"entryTitle"];
    [coder encodeObject:@(_latitude) forKey:@"latitude"];
    [coder encodeObject:@(_longitude) forKey:@"longitude"];
    [coder encodeObject:_filePath forKey:@"filePath"];
    [coder encodeObject:_fileType forKey:@"fileType"];
    [coder encodeObject:_date forKey:@"date"];
}

@end
