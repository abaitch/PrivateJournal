//
//  AJBStartViewController.m
//  Journal
//
//  Created by Adam Baitch on 4/16/14.
//  Copyright (c) 2014 Adam Baitch. All rights reserved.
//

#import "AJBStartViewController.h"
#import "AJBAppDelegate.h"
#import "AJBEntry.h"
#import <CoreLocation/CoreLocation.h>
#import "AJBPhotoEntryViewController.h"


@interface AJBStartViewController () <UIActionSheetDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

//application delegate
@property (nonatomic, strong) AJBAppDelegate *appDelegate;

// location manager
@property (nonatomic, strong) CLLocationManager *locationManager;

// image to store
@property (nonatomic, strong) UIImage * imageToStore;

@end

@implementation AJBStartViewController


// initialize the app delegate
- (AJBAppDelegate *)appDelegate
{
    if (!_appDelegate) {
        _appDelegate = (AJBAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    return _appDelegate;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
    }
    
    return _locationManager;
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
    [self setNeedsStatusBarAppearanceUpdate];
    NSLog(@"Start View Loaded");
    // Do any additional setup after loading the view.
    
    // alert if the device doesn't have a camera
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
    // make sure location services enabled
    if ([CLLocationManager locationServicesEnabled] == YES) {
        NSLog(@"Location Services Enabled.");
        [self.locationManager startUpdatingLocation];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                        message:@"To re-enable, please go to Settings and turn on Location Services for this app."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
        return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - buttons

- (IBAction)cameraTapped:(id)sender
{
    NSLog(@"Camera Button Pushed");
}

- (IBAction)videoTapped:(id)sender
{
    NSLog(@"Video Button Pushed");
}

- (IBAction)audioTapped:(id)sender
{
    NSLog(@"Audio Button Pushed");
}

- (IBAction)gatewayTapped:(id)sender
{
    NSLog(@"Gateway Button Pushed");
}

#pragma mark - camera stuff

// allow user to take new picture
- (IBAction)takePhoto:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

// allow user to select photo from camera roll
- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

// allow user to take a video
- (IBAction)captureVideo:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

// set imageToStore to the chosen image and get date and time
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // if something...
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageToStore = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self performSegueWithIdentifier:@"readyToStorePhoto" sender:self];
    
    // else, it's a video
    /*
     self.videoURL = info[UIImagePickerControllerMediaURL];
     [picker dismissViewControllerAnimated:YES completion:NULL];
     
     // I think the next lines should be in videoentryviewcontroller
     self.videoController = [[MPMoviePlayerController alloc] init];
     
     [self.videoController setContentURL:self.videoURL];
     [self.videoController.view setFrame:CGRectMake (0, 0, 320, 460)];
     [self.view addSubview:self.videoController.view];
     
     [self.videoController play];
     */
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - perparing for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"readyToStorePhoto"]){
        AJBPhotoEntryViewController *destination = (AJBPhotoEntryViewController *) segue.destinationViewController;
        
        // get location and date
        CLLocation *location = [self.locationManager location];
        NSDate *today = [NSDate date];
        
        // set destination view controller values
        destination.date = today;
        destination.imageView.image = self.imageToStore;
        destination.location = location;
        
        NSLog(@"Before Segue: file path = %@", _imageToStore);
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
