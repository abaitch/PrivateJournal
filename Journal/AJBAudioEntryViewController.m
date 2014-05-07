//
//  AJBAudioEntryViewController.m
//  Journal
//
//  Created by Adam Baitch on 5/6/14.
//  Copyright (c) 2014 Adam Baitch. All rights reserved.
//

#import "AJBAudioEntryViewController.h"

@interface AJBAudioEntryViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (nonatomic, weak) NSURL *audioFilePath;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *commentsField;

@end

@implementation AJBAudioEntryViewController



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
    NSLog(@"ViewDidLoad");
    [self.playButton setEnabled:NO];
    [self.resetButton setEnabled:NO];
    [self.stopButton setEnabled:YES];
    self.playButton.hidden = YES;
    self.resetButton.hidden = YES;
    self.stopButton.hidden = NO;
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
