//
//  AJBPhotoEntryViewController.m
//  Journal
//
//  Created by Adam Baitch on 4/23/14.
//  Copyright (c) 2014 Adam Baitch. All rights reserved.
//

#import "AJBPhotoEntryViewController.h"
#import "AJBEntry.h"
#import "AJBAppDelegate.h"

@interface AJBPhotoEntryViewController ()

//application delegate
@property (nonatomic, strong) AJBAppDelegate *appDelegate;

@end

#pragma mark - notes

// might have to store date as a string instead. use an NSDateFormatter to convert between
// string and NSDate

@implementation AJBPhotoEntryViewController

- (AJBAppDelegate *)appDelegate
{
    if (!_appDelegate) {
        _appDelegate = (AJBAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    return _appDelegate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.latitude = self.location.coordinate.latitude;
    self.longitude = self.location.coordinate.longitude;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *stringFromDate = [formatter stringFromDate:self.date];
    NSLog(@"Date: %@", stringFromDate);
    NSLog(@"Location: %f, %f", self.latitude, self.longitude);
    self.commentsToStore = @"";
    self.imageView.image = self.imageToStore;
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

#pragma mark - storing entry

- (IBAction)storeEntry:(id)sender
{
    
    // actually save image to File System here----------
    //Where the 0 denotes the compression (0 to 1).
    
    AJBEntry *entryToAdd = [[AJBEntry alloc] init];
    NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(self.imageView.image, 80)];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath = [paths objectAtIndex:0]; // Get documents folder
    
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    int randomNumber = (arc4random() % 1000000) + 1;
    NSString *imageName = [NSString stringWithFormat:@"%@", self.titleField.text];
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@-%d.jpg", dataPath, imageName, randomNumber]; //add our image to the path
    NSLog(@"%@", fullPath);
    NSError *writeError = nil;
    [imageData writeToFile:fullPath options:NSDataWritingAtomic error:&writeError];
    
    if (writeError != nil) {
        NSLog(@"%@: Error while saving image: %@", [self class], [writeError localizedDescription]);
    }
    //logic to actually save
    entryToAdd.entryTitle = self.titleField.text;
    entryToAdd.comments = self.commentsToStore;
    // save location to entry
    entryToAdd.latitude = self.latitude;
    entryToAdd.longitude = self.longitude;
    
    // add image file path to note
    entryToAdd.filePath = fullPath;
    entryToAdd.fileType = @"photo";
    
    // add date to entry
    entryToAdd.date = self.date;
    
    if ([self.appDelegate addEntryFromWrapper:entryToAdd]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView *somethingWrong = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something was wrong" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
