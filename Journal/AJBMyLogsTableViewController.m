//
//  AJBMyLogsTableViewController.m
//  Journal
//
//  Created by Hunter Horsley on 5/8/14.
//  Copyright (c) 2014 Adam Baitch. All rights reserved.
//

#import "AJBMyLogsTableViewController.h"
#import "AJBAppDelegate.h"
#import "AJBOLDLogPhotoViewController.h"
#import "AJBOLDLogVideoViewController.h"
#import "AJBOLDLogAudioViewController.h"

@interface AJBMyLogsTableViewController ()

@property(strong,nonatomic)NSMutableDictionary *entryValues;
@property(strong,nonatomic)NSDictionary *entryValuesDict;
@property (nonatomic) int numRowsToShow;

//to pass through
@property (nonatomic, retain) NSString *entryTitleToPass;
@property (nonatomic, retain) NSString *commentsToPass;
@property (nonatomic) float latitudeToPass;
@property (nonatomic) float longitudeToPass;
@property (nonatomic, retain) NSString * filePathToPass;
@property (nonatomic, retain) NSString * fileTypeToPass;
@property (nonatomic, retain) NSDate * dateToPass;


//make appDelegate a property
@property (nonatomic, strong) AJBAppDelegate *appDelegate;


@end

@implementation AJBMyLogsTableViewController


- (AJBAppDelegate *)appDelegate
{
    if (! _appDelegate) {
        _appDelegate = (AJBAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return _appDelegate;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _numRowsToShow = 0;
    
    NSArray *entriesArray = [self.appDelegate allEntries];
    self.entryValues = [[NSMutableDictionary alloc] init];
    for (AJBEntry *e in entriesArray ) {
        [self.entryValues setObject:e forKey:[NSString stringWithFormat: @"%d", _numRowsToShow]];
        _numRowsToShow = _numRowsToShow +1;
    }
    
    NSLog(@"%@", _entryValues);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_numRowsToShow < 1) {
        return 1;
    }else{
    return _numRowsToShow;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
    NSDictionary *subdict = [_entryValuesDict objectForKey:[NSString stringWithFormat:@"%d", (int)indexPath.row + 1]];
        cell.textLabel.text = [@"Log - " stringByAppendingString: [NSString stringWithFormat:@"%@ - %@", [self.entryValues objectForKey:@"fileType"], [subdict objectForKey:@"entryTitle"]]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _entryValuesDict = [_entryValues objectForKey: [NSString stringWithFormat: @"%d", (int)indexPath.row+1]];
    _entryTitleToPass = [NSString stringWithFormat:@"%@", [self.entryValues objectForKey:@"entryTitle"]];
    _commentsToPass = [NSString stringWithFormat:@"%@", [self.entryValues objectForKey:@"comments"]];
    _latitudeToPass = [[self.entryValues objectForKey:@"latitide"] floatValue];
    _longitudeToPass = [[self.entryValues objectForKey:@"longitude"] floatValue];
    _filePathToPass = [NSString stringWithFormat:@"%@", [self.entryValues objectForKey:@"filePath"]];
    _fileTypeToPass = [NSString stringWithFormat:@"%@", [self.entryValues objectForKey:@"fileType"]];
    _dateToPass = [self.entryValues objectForKey:@"date"];
    
    if ([_entryValues.fileType  isEqualToString: @"photo"]) {
        [self performSegueWithIdentifier:@"viewPhoto" sender:self];
    } else if ([_entryValues.fileType  isEqualToString: @"video"]) {
        [self performSegueWithIdentifier:@"viewVideo" sender:self];
    } else if ([_entryValues.fileType  isEqualToString: @"audio"]) {
        [self performSegueWithIdentifier:@"viewAudio" sender:self];
    }
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
 -(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
     if([segue.identifier isEqualToString:@"viewPhoto"]){
         AJBOLDLogPhotoViewController *destination = (AJBOLDLogPhotoViewController *) segue.destinationViewController;
         destination.entryTitle = _entryTitleToPass;
         destination.comments = _commentsToPass;
         destination.latitude = _latitudeToPass;
         destination.longitude = _longitudeToPass;
         destination.filePath = _filePathToPass;
         destination.fileType = _fileTypeToPass;
         destination.date = _dateToPass;
     } else if ([segue.identifier isEqualToString:@"viewVideo"]){
         AJBOLDLogVideoViewController *destination = (AJBOLDLogVideoViewController *) segue.destinationViewController;
         destination.entryTitle = _entryTitleToPass;
         destination.comments = _commentsToPass;
         destination.latitude = _latitudeToPass;
         destination.longitude = _longitudeToPass;
         destination.filePath = _filePathToPass;
         destination.fileType = _fileTypeToPass;
         destination.date = _dateToPass;
     } else if ([segue.identifier isEqualToString:@"viewAudio"]){
         AJBOLDLogAudioViewController *destination = (AJBOLDLogAudioViewController *) segue.destinationViewController;
         destination.entryTitle = _entryTitleToPass;
         destination.comments = _commentsToPass;
         destination.latitude = _latitudeToPass;
         destination.longitude = _longitudeToPass;
         destination.filePath = _filePathToPass;
         destination.fileType = _fileTypeToPass;
         destination.date = _dateToPass;
     }
 }

@end