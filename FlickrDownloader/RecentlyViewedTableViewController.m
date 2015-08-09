//
//  RecentlyViewedTableViewController.m
//  FlickrDownloader
//
//  Created by Koen Hendriks on 23/06/15.
//  Copyright (c) 2015 Koen Hendriks. All rights reserved.
//

#import "RecentlyViewedTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotoViewController.h"

@interface RecentlyViewedTableViewController ()

@end

@implementation RecentlyViewedTableViewController

@synthesize recentlyViewedPhotos = _recentlyViewedPhotos;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _recentlyViewedPhotos = [FlickrFetcher allPhotos];
    //NSLog(@"Recently Viewed Photo's %@", _recentlyViewedPhotos);
    //NSLog(@"Number of saved photo's: %lu", (unsigned long)_recentlyViewedPhotos.count);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"recentlyViewedToViewerSegue" sender:indexPath];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.recentlyViewedPhotos.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recentlyViewedCell" forIndexPath:indexPath];
    
    // Configure the cell...
//    NSString *photoTitle = [self.recentlyViewedPhotos[indexPath.row] valueForKeyPath: FLICKR_PHOTO_TITLE];
//
//    NSString *photoDescription = [self.recentlyViewedPhotos[indexPath.row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    cell.textLabel.text = [self.recentlyViewedPhotos[indexPath.row] valueForKeyPath: FLICKR_PHOTO_TITLE];
    
    cell.detailTextLabel.text = [self.recentlyViewedPhotos[indexPath.row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];

    
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    
    if ([segue.identifier isEqualToString:@"recentlyViewedToViewerSegue"]) {
        [self preparePhotoVC:segue.destinationViewController forPhoto:self.recentlyViewedPhotos[indexPath.row]];
    }
}

#pragma mark - Helper Methods

// Helper Method to pass the photo to the photoVC

- (void)preparePhotoVC:(PhotoViewController *)photoVC
              forPhoto:(NSDictionary *)photo
{
    photoVC.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
    photoVC.title = [NSString stringWithFormat:@"%@", [photo valueForKeyPath:FLICKR_PHOTO_TITLE]];
}




@end
