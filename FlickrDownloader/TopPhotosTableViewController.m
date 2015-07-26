//
//  TopPhotosTableViewController.m
//  FlickrDownloader
//
//  Created by Koen Hendriks on 23/06/15.
//  Copyright (c) 2015 Koen Hendriks. All rights reserved.
//

#import "TopPhotosTableViewController.h"
#import "FlickrFetcher.h"
#import "FlickrDownloader.h"
#import "PhotoViewController.h"

@interface TopPhotosTableViewController ()

@end

@implementation TopPhotosTableViewController

@synthesize selectedPlace = _selectedPlace;

-(void)setSelectedPlace:(NSDictionary *)selectedPlace{
    _selectedPlace = selectedPlace;
    
    // Downloading of Photo's for the selected place
    if (self) {
        // Download the photo's from Flickr and reload the tableView
        [FlickrDownloader fetchFlickrDataFromURL:[FlickrFetcher URLforPhotosInPlace:[self.selectedPlace valueForKeyPath:FLICKR_PLACE_ID] maxResults:50] withCompletionHandler:^(NSDictionary *resultsDict, NSError *error) {
            if (error != nil) {
                NSLog(@"Error downloading data from Flickr: %@", [error localizedDescription]);
            }
            else{
                [self setPhotosForSelectedPlace:[resultsDict valueForKeyPath:FLICKR_RESULTS_PHOTOS]];
                //NSLog(@"Selected Place: %@", self.selectedPlace);
                //NSLog(@"ResultsDict: %@", resultsDict);
                //NSLog(@"Place ID: %@",[self.selectedPlace valueForKeyPath:FLICKR_PLACE_ID]);
                //NSLog(@"PHOTO'S: %@", self.photosForSelectedPlace);
                
                //NSLog(@"Number of Photo's: %@", self.photosForSelectedPlace.count);
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.photosForSelectedPlace.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *photoTitle = [self.photosForSelectedPlace[indexPath.row] valueForKeyPath:FLICKR_PHOTO_TITLE];
    NSLog(@"Photo Title: %@", photoTitle);
    //NSLog(@"%@",[self.photosForSelectedPlace objectAtIndex:indexPath.row]);
    
    NSString *photoDescription = [self.photosForSelectedPlace[indexPath.row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    if ([photoTitle isEqualToString:@""]) {
        cell.textLabel.text = photoDescription;
    }
    else{
        cell.textLabel.text = photoTitle;
    }
    
    
    if ([photoDescription isEqualToString:@""]) {
        cell.detailTextLabel.text = @"No Description";
    }
    else{
        cell.detailTextLabel.text = photoDescription;
    }
    
    NSLog(@"Selected Photo: %@", self.photosForSelectedPlace[indexPath.row]);
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table View Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"TopPhotosToViewerSegue" sender:indexPath];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = (NSIndexPath *)sender;

    if ([segue.identifier isEqualToString:@"TopPhotosToViewerSegue"]) {
        [self preparePhotoVC:segue.destinationViewController forPhoto:self.photosForSelectedPlace[indexPath.row]];
    }
    
}

// Helper Method to pass the photo to the photoVC

- (void)preparePhotoVC:(PhotoViewController *)photoVC
              forPhoto:(NSDictionary *)photo
{
    photoVC.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
    photoVC.title = [NSString stringWithFormat:@"%@", [photo valueForKeyPath:FLICKR_PHOTO_TITLE]];
}


@end
