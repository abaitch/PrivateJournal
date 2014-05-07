//
//  AJBAudioEntryViewController.m
//  Journal
//
//  Created by Adam Baitch on 5/6/14.
//  Copyright (c) 2014 Adam Baitch. All rights reserved.
//

#import "AJBAudioEntryViewController.h"
#import "AJBEntry.h"
#import <CoreLocation/CoreLocation.h>
#import "AJBAppDelegate.h"

@interface AJBAudioEntryViewController () <UIActionSheetDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSDate *date;
@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet CLLocation *location;
@property (nonatomic, weak) NSURL *audioFilePath;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *commentsField;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;


// location manager
@property (nonatomic, strong) CLLocationManager *locationManager;

//application delegate
@property (nonatomic, strong) AJBAppDelegate *appDelegate;


//keyboard toolbar
@property (nonatomic, strong) UIToolbar *keyboardToolbar;
@property (nonatomic, strong) UIBarButtonItem *previousButton;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
- (void) nextField;
- (void) previousField;
- (void) resignKeyboard;

@end

@implementation AJBAudioEntryViewController

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
    self.date = [NSDate date];
    CLLocation *location = [self.locationManager location];
    self.latitude = [[NSNumber numberWithDouble:location.coordinate.latitude] floatValue];
    self.longitude = [[NSNumber numberWithDouble:location.coordinate.longitude] floatValue];
    NSLog(@"ViewDidLoad");
    [self.playButton setEnabled:NO];
    [self.resetButton setEnabled:NO];
    [self.stopButton setEnabled:YES];
    self.playButton.hidden = YES;
    self.resetButton.hidden = YES;
    self.stopButton.hidden = NO;
    self.titleField.inputAccessoryView = self.keyboardToolbar;
    self.commentsField.inputAccessoryView = self.keyboardToolbar;
    [self.titleField setDelegate:self];
    [self.commentsField setDelegate:self];
    [self prepareForRecording];
}

- (void) prepareForRecording {
    // Disable Stop/Play button when application launches
    
    // Set the audio file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dataPath = [paths objectAtIndex:0]; // Get documents folder
    
    
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    int randomNumber = (arc4random() % 1000000) + 1;
    NSString *audioFileName = @"audio";
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@-%d.mp3", dataPath, audioFileName, randomNumber]; //add our image to the path
    NSLog(@"%@", fullPath);
    NSURL *outputFile = [NSURL URLWithString:fullPath];
    self.audioFilePath = outputFile;
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    _recorder = [[AVAudioRecorder alloc] initWithURL:outputFile settings:recordSetting error:NULL];
    _recorder.delegate = self;
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordPauseTapped:(id)sender {
    // Stop the audio player before recording
    if (self.player.playing) {
        [self.player stop];
    }
    
    if (!self.recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [self.recorder record];
        [self.recordPauseButton setImage:[UIImage imageNamed:@"pauseButton.png"] forState:UIControlStateNormal];
        self.recordLabel.hidden = YES;
        [self.playButton setEnabled:NO];
        [self.resetButton setEnabled:NO];
        [self.stopButton setEnabled:YES];
        self.playButton.hidden = YES;
        self.resetButton.hidden = YES;
        self.stopButton.hidden = NO;
    } else {
        
        // Pause recording
        [self.recorder pause];
        [self.recordPauseButton setImage:[UIImage imageNamed:@"recordButton.png"] forState:UIControlStateNormal];
        self.recordLabel.hidden = NO;
        [self.playButton setEnabled:NO];
        [self.resetButton setEnabled:NO];
        [self.stopButton setEnabled:YES];
        self.playButton.hidden = YES;
        self.resetButton.hidden = YES;
        self.stopButton.hidden = NO;
    }
}

- (IBAction)stopTapped:(id)sender {
    [self.recorder stop];
    self.playButton.hidden = NO;
    self.resetButton.hidden = NO;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    [self.stopButton setEnabled:NO];
    [self.playButton setEnabled:YES];
    [self.resetButton setEnabled:YES];
    self.stopButton.hidden =YES;
    self.playButton.hidden = NO;
    self.resetButton.hidden = NO;
    [self.recordPauseButton setImage:[UIImage imageNamed:@"recordButton.png"] forState:UIControlStateNormal];
}

- (IBAction)resetTapped:(id)sender {
    [self.recorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    [self.stopButton setEnabled:YES];
    [self.recordPauseButton setImage:[UIImage imageNamed:@"recordButton.png"] forState:UIControlStateNormal];
    [self.playButton setEnabled:NO];
    [self.resetButton setEnabled:NO];
    [self.stopButton setEnabled:YES];
    self.playButton.hidden = YES;
    self.resetButton.hidden = YES;
    self.stopButton.hidden = NO;
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [self.recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    
    [self.stopButton setEnabled:NO];
    [self.playButton setEnabled:YES];
}

- (IBAction)playTapped:(id)sender {
    if (!self.recorder.recording){
        UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
        
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:nil];
        [self.player setDelegate:self];
        [self.player play];
        [self.resetButton setEnabled:YES];
        self.resetButton.hidden = NO;
    }
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
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
    
    // actually save image to File System here----------
    //Where the 0 denotes the compression (0 to 1).
    
    AJBEntry *entryToAdd = [[AJBEntry alloc] init];

    if ([self.titleField.text isEqualToString:@""]) {
        UIAlertView *noTitle = [[UIAlertView alloc] initWithTitle:@"Hold Up!" message:@"Please enter a title." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [noTitle show];
        return;
    }
    
    //logic to actually save
    
    entryToAdd.entryTitle = self.titleField.text;
    entryToAdd.comments = self.commentsField.text;
    // save location to entry
    entryToAdd.latitude = self.latitude;
    entryToAdd.longitude = self.longitude;
    
    // add image file path to note
    entryToAdd.filePath = [self.audioFilePath absoluteString];
    entryToAdd.fileType = @"audio";
    
    // add date to entry
    entryToAdd.date = self.date;
    
    if ([self.appDelegate addEntryFromWrapper:entryToAdd]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView *somethingWrong = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something was wrong" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [somethingWrong show];
    }
    
}

- (void) nextField
{
    if ([self.titleField isFirstResponder]) {
        [self.commentsField becomeFirstResponder];
    }
}

- (void) previousField
{
    if ([self.commentsField isFirstResponder]) {
        [self.titleField becomeFirstResponder];
    }
}

// keyboard toolbar
- (UIToolbar *)keyboardToolbar
{
    if (!_keyboardToolbar) {
        _keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        self.previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous"
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(previousField)];
        
        self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                           style:UIBarButtonItemStyleBordered
                                                          target:self
                                                          action:@selector(nextField)];
        
        UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                    target:self
                                                                                    action:nil];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(resignKeyboard)];
        
        [_keyboardToolbar setItems:@[self.previousButton, self.nextButton, extraSpace, doneButton]];
    }
    
    return _keyboardToolbar;
}


- (void) resignKeyboard
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    
    if (textField == self.titleField) {
        self.previousButton.enabled = NO;
    } else {
        self.previousButton.enabled = YES;
    }
    
    if (textField == self.commentsField) {
        self.nextButton.enabled = NO;
    } else {
        self.nextButton.enabled = YES;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    self.view.frame = viewFrame;
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = 0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    [textField resignFirstResponder];
    self.view.frame = viewFrame;
    
    [UIView commitAnimations];
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
