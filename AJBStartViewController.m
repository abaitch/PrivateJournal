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
#import "AJBVideoEntryViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface AJBStartViewController () <UIActionSheetDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

//application delegate
@property (nonatomic, strong) AJBAppDelegate *appDelegate;

// location manager
@property (nonatomic, strong) CLLocationManager *locationManager;

// image to store
@property (nonatomic, strong) UIImage * imageToStore;

// boolean for photo vs video
@property(nonatomic) Boolean isPhoto;

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
        self.isPhoto = YES;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

// allow user to select photo from camera roll
- (IBAction)selectPhoto:(UIButton *)sender {
    self.isPhoto = YES;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

// allow user to take a video
- (IBAction)captureVideo:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.isPhoto = NO;
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
    
    if (self.isPhoto == YES) {
        
        // working with a photo
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        self.imageToStore = chosenImage;
        
        [picker dismissViewControllerAnimated:YES completion:^{
             [self performSegueWithIdentifier:@"readyToStorePhoto" sender:self];
        }];
    } else {
        
        // working with a video
        self.videoURL = info[UIImagePickerControllerMediaURL];
        [picker dismissViewControllerAnimated:YES completion:^{
            [self performSegueWithIdentifier:@"readyToStoreVideo" sender:self];
        }];
        
      //  self.videoController = [[MPMoviePlayerController alloc] init];
        
       // [self.videoController setContentURL:self.videoURL];
       // [self.videoController.view setFrame:CGRectMake (0, 0, 320, 460)];
       // [self.view addSubview:self.videoController.view];
        
       // [self.videoController play];
    }

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
        destination.imageToStore = self.imageToStore;
        destination.location = location;
        
        NSLog(@"Before Segue: file path = %@", _imageToStore);
    } else if ([segue.identifier isEqualToString:@"readyToStoreVideo"]){
        AJBVideoEntryViewController *destination = (AJBVideoEntryViewController *) segue.destinationViewController;
        // get location and date
        CLLocation *location = [self.locationManager location];
        NSDate *today = [NSDate date];
        
        // set destination view controller values
        destination.videoURL = self.videoURL;
        destination.date = today;
        destination.location = location;
        destination.videoController = [[MPMoviePlayerController alloc] init];
        [destination.videoController setContentURL:self.videoURL];
        [destination.videoController.view setFrame:CGRectMake (0, 144, 320, 424)];
        [destination.view addSubview:destination.videoController.view];
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

/*- (void) startRecordingAudio:(id)sender
    AVAudioRecorder *recorder =[AVAudioRecorder
    [audioS setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [audioS setActive:YES error:&error];

    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];

    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat: 44100.0],AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 2],AVNumberOfChannelsKey,[NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                              nil];
*/
@end
