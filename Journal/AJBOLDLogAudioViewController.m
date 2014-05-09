//
//  AJBOLDLogAudioViewController.m
//  Journal
//
//  Created by Hunter Horsley on 5/9/14.
//  Copyright (c) 2014 Adam Baitch. All rights reserved.
//

#import "AJBOLDLogAudioViewController.h"

@interface AJBOLDLogAudioViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation AJBOLDLogAudioViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) userHitDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
