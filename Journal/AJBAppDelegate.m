//
//  AJBAppDelegate.m
//  Journal
//
//  Created by Adam Baitch on 4/16/14.
//  Copyright (c) 2014 Adam Baitch. All rights reserved.
//

#import "AJBAppDelegate.h"
#import "AJBEntry.h"
#import "Entry.h"
#import <Parse/Parse.h>

@implementation AJBAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //self.window.backgroundColor = [UIColor whiteColor];
    //[self.window makeKeyAndVisible];
    [Parse setApplicationId:@"QDSh6Qisfv7tKT3xR1DQH7Ds0b7Sx5WeCxZpGLz7"
                  clientKey:@"mfunB1Vd16sHsUZ1z3BthGdz26EVQfkaxDilJB4k"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
    
    
}

#pragma mark - Adding Entries

// add an entry using the wrapper
- (BOOL)addEntryFromWrapper:(AJBEntry *)entry
{
    if (![self checkIfAlreadyRegistered:entry]) {
        PFObject *entryToStore = [PFObject objectWithClassName:@"AJBEntry"];
        [entryToStore setObject:entry.entryTitle forKey:@"entryTitle"];
        [entryToStore setObject:[NSString stringWithFormat:@"%f", entry.latitude] forKey:@"latitude"];
        [entryToStore setObject:[NSString stringWithFormat:@"%f", entry.longitude] forKey:@"longitude"];
        [entryToStore setObject:[NSString stringWithFormat:@"%f", entry.latitude] forKey:@"latitude"];
        [entryToStore setObject:entry.filePath forKey:@"filePath"];
        [entryToStore setObject:entry.date forKey:@"date"];
        [entryToStore setObject:[PFUser currentUser] forKey:@"owner"];
        [entryToStore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Show success message
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the entry" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            
        }];
        return YES;
    }
    
    return NO;
}

// Check if an entry is already stored
- (BOOL)checkIfAlreadyRegistered:(AJBEntry *)entry
{
    return NO;
}

// array of all the entries stored in Core Data
- (NSArray *)allEntries
{
    NSMutableArray *fetched = [NSMutableArray array];
    PFQuery *query = [PFQuery queryWithClassName:@"AJBEntry"];
    [query whereKey:@"owner" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. Add the returned objects to allObjects
            [fetched addObjectsFromArray:objects];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    NSLog(@"array: %@", fetched);
    return fetched;
}

/*
 // add an entry using the wrapper
 - (BOOL)addEntryFromWrapper:(AJBEntry *)entry
 {
 if (![self checkIfAlreadyRegistered:entry]) {
 PFObject *entryToStore = [PFObject objectWithClassName:@"AJBEntry"];
 [entryToStore setObject:entry.entryTitle forKey:@"entryTitle"];
 [entryToStore setObject:[NSString stringWithFormat:@"%f",entry.latitude] forKey:@"latitude"];
 [entryToStore setObject:[NSString stringWithFormat:@"%f",entry.longitude] forKey:@"longitude"];
 [entryToStore setObject:entry.filePath forKey:@"filePath"];
 [entryToStore setObject:entry.fileType forKey:@"fileType"];
 [entryToStore setObject:entry.date forKey:@"date"];
 [entryToStore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
 
 if (!error) {
 // Show success message
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the recipe" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
 [alert show];
 
 // Notify table view to reload the recipes from Parse cloud
 //[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
 
 } else {
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
 [alert show];
 
 }
 
 }];
 return YES;
 }
 
 return NO;
 }
 
 // Check if an entry is already stored
 - (BOOL)checkIfAlreadyRegistered:(AJBEntry *)entry
 {
 int ocount = 0;
 PFQuery *query = [PFQuery queryWithClassName:@"AJBEntry"];
 [query whereKey:@"filePath" equalTo:entry.filePath];
 [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
 if (!error) {
 // The find succeeded.
 NSLog(@"Successfully retrieved %lu users.", (unsigned long)objects.count);
 ocount = (int)objects.count;
 } else {
 // Log details of the failure
 NSLog(@"Error: %@ %@", error, [error userInfo]);
 }
 }];
 return ocount > 0;
 }
 */
#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
 
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Journal" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Journal.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
