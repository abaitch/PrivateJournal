//
//  AJBPasscodeViewController.m
//  Journal
//
//  Created by Hunter Horsley on 5/9/14.
//  Copyright (c) 2014 Adam Baitch. All rights reserved.
//

#import "AJBPasscodeViewController.h"
#import <Parse/Parse.h>


@interface AJBPasscodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passcodeField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@end

@implementation AJBPasscodeViewController
- (IBAction)unlockPassword:(id)sender {
    [PFUser logInWithUsernameInBackground:[[PFUser currentUser] username] password:self.passcodeField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            //Open the wall
            [self performSegueWithIdentifier:@"LoginSuccessful" sender:self];
        } else {
            //Something bad has ocurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
