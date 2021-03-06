//
//  AJBAppDelegate.h
//  Journal
//
//  Created by Adam Baitch on 4/16/14.
//  Copyright (c) 2014 Adam Baitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJBEntry.h"

@interface AJBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

// core data
- (BOOL)addEntryFromWrapper:(AJBEntry *) entry;
- (BOOL)checkIfAlreadyRegistered:(AJBEntry *) entry;
- (NSArray *)allEntries;


@end
