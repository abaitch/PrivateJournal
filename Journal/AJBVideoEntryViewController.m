//
//  AJBVideoEntryViewController.m
//  Journal
//
//  Created by Adam Baitch on 5/6/14.
//  Copyright (c) 2014 Adam Baitch. All rights reserved.
//

#import "AJBVideoEntryViewController.h"
#import "AJBAppDelegate.h"
#import "AJBEntry.h"

@interface AJBVideoEntryViewController ()

@property (nonatomic, strong) AJBAppDelegate *appDelegate;

@end

@implementation AJBVideoEntryViewController

- (AJBAppDelegate *)appDelegate
{
    if (!_appDelegate) {
        _appDelegate = (AJBAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    return _appDelegate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.latitude = self.location.coordinate.latitude;
    self.longitude = self.location.coordinate.longitude;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *stringFromDate = [formatter stringFromDate:self.date];
    NSLog(@"Date: %@", stringFromDate);
    NSLog(@"Location: %f, %f", self.latitude, self.longitude);
    self.commentsToStore = @"";
    [self.titleField setDelegate:self];
    [self.videoController play];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userHitCancel:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Never Mind"
                                               destructiveButtonTitle:@"Cancel"
                                                    otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (IBAction)storeEntry:(id)sender
{
    
    if ([self.titleField.text isEqualToString:@""]) {
        UIAlertView *noTitle = [[UIAlertView alloc] initWithTitle:@"Hold Up!" message:@"Please enter a title." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [noTitle show];
        return;
    }
    
    // actually save image to File System here----------
    //Where the 0 denotes the compression (0 to 1).
    
    AJBEntry *entryToAdd = [[AJBEntry alloc] init];
    NSData *videoData = [NSData dataWithContentsOfURL:self.videoURL];
    NSLog(@"%.2f",(float)videoData.length/1024.0f/1024.0f);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath = [paths objectAtIndex:0]; // Get documents folder
    
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    int randomNumber = (arc4random() % 1000000) + 1;
    NSString *imageName = [NSString stringWithFormat:@"%@", self.titleField.text];
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@-%d.m4a", dataPath, imageName, randomNumber]; //add our image to the path
    NSLog(@"%@", fullPath);
    NSError *writeError = nil;
    [videoData writeToFile:fullPath options:NSDataWritingAtomic error:&writeError];
    
    if (writeError != nil) {
        NSLog(@"%@: Error while saving video: %@", [self class], [writeError localizedDescription]);
    }
    //logic to actually save
    entryToAdd.entryTitle = self.titleField.text;
    entryToAdd.comments = self.commentsToStore;
    // save location to entry
    entryToAdd.latitude = self.latitude;
    entryToAdd.longitude = self.longitude;
    
    // add image file path to note
    entryToAdd.filePath = fullPath;
    entryToAdd.fileType = @"video";
    
    // add date to entry
    entryToAdd.date = self.date;
    
    if ([self.appDelegate addEntryFromWrapper:entryToAdd]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView *somethingWrong = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:@"Something was wrong"
                                                                delegate:self
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil, nil];
        [somethingWrong show];
    }
    
    
}

// Adding comments

- (IBAction)enterComments:(id)sender
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add Comment" message:@"Write a note to yourself." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Comments", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = @"Begin typing...";
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle=[alertView buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:@"Add Comments"]) {
        NSString *comm = [alertView textFieldAtIndex:0].text;
        self.commentsToStore = comm;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
