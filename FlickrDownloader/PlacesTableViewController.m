//
//  PlacesTableViewController.m
//  FlickrDownloader
//
//  Created by Koen Hendriks on 23/06/15.
//  Copyright (c) 2015 Koen Hendriks. All rights reserved.
//

#import "PlacesTableViewController.h"
#import "FlickrDownloader.h"
#import "FlickrFetcher.h"
#import "TopPhotosTableViewController.h"

@interface PlacesTableViewController ()

@end

@implementation PlacesTableViewController

@synthesize placesDict;
@synthesize sectionHeadersArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.dataSource = self;
    
    // Download the top places data from Flickr and put it into the placesDict
    [FlickrDownloader fetchFlickrDataFromURL:[FlickrFetcher URLforTopPlaces] withCompletionHandler:^(NSDictionary *resultsDict, NSError *error) {
        if (error != nil) {
            NSLog(@"Error downloading data from Flickr: %@", [error localizedDescription]);
        }
        else{
            //NSLog(@"%@",[self createPlacesDictFromFlickrResults:resultsDict]);
            [self setPlacesDict:[self createPlacesDictFromFlickrResults:resultsDict]];
            
            [self setSectionHeadersArray:[self.placesDict.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
            
            [self.tableView reloadData];
            
            //NSLog(@"Section Headers Array: %@", self.sectionHeadersArray);
        }
    }];
    
    //NSLog(@"Places Dict: %@", [self placesDict]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.placesDict.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *sectionHeaderTitleString = [sectionHeadersArray objectAtIndex:section];
    return sectionHeaderTitleString;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // TO DO
    // Count the items in self.places for the index in sectionHeadersArray
    NSArray *sectionItemsArray = [self.placesDict objectForKey:[self.sectionHeadersArray objectAtIndex:section]];
    //NSLog(@"Section Items Array: %@", sectionItemsArray);
    return sectionItemsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeCell" forIndexPath:indexPath];
    
    // Get the items for the current section
    // as well as the location name and the state/province name
    NSArray *placesInSectionArray = [self.placesDict objectForKey:[self.sectionHeadersArray objectAtIndex:indexPath.section]];
    //NSLog(@"COUNTRY: %@", [self.sectionHeadersArray objectAtIndex:indexPath.section]);
    
    
    NSString *placeName = [[[placesInSectionArray[indexPath.row] valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@","] firstObject];
    
    NSArray *placeRegionNameArray = [[placesInSectionArray[indexPath.row] valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@","];
                                 
    NSRange range;
    range.location = 1;
    range.length = [placeRegionNameArray count] - 2;
    NSString *placeRegionName = [[placeRegionNameArray subarrayWithRange:range] componentsJoinedByString:@", "];
    
    cell.textLabel.text = placeName;
    cell.detailTextLabel.text = placeRegionName;    
    
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

#pragma mark - Table view Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"placesToPhotoListSegue" sender:indexPath];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"placesToPhotoListSegue"]) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        //NSLog(@"IndexPath: %@", sender);
        
        NSArray *placesInSectionArray = [self.placesDict objectForKey:[self.sectionHeadersArray objectAtIndex:indexPath.section]];
        NSDictionary *placeForIndexPath = [placesInSectionArray objectAtIndex:indexPath.row];
        //NSLog(@"Place for selected Cell: %@", placeForIndexPath);
        
        TopPhotosTableViewController *photosVC = [segue destinationViewController];
        photosVC.selectedPlace = placeForIndexPath;
    }
}


#pragma mark - Helper Methods

-(NSDictionary *)createPlacesDictFromFlickrResults:(NSDictionary *)flickrResults{
    NSMutableDictionary *placesTVDict = [[NSMutableDictionary alloc] init];
    //NSLog(@"FLICKR RESULTS: %@", flickrResults);
    
    NSArray *places = [flickrResults valueForKeyPath:FLICKR_RESULTS_PLACES];
    //NSLog(@"Place Names: %@",places);
    
    // Sort the places array based on the place name
    NSSortDescriptor *placeNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"woe_name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:placeNameDescriptor];
    NSArray *placesSortedArray = [places sortedArrayUsingDescriptors:sortDescriptors];
    
    //NSLog(@"Places: %@", placesSortedArray);
    
    // Iterate over all places and get the country for each place
    for (NSDictionary *place in placesSortedArray) {
        //NSLog(@"Place: %@", place);
        
        NSArray *placeNameArray = [[place valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@","];
        
        NSString *placeCountry = [[placeNameArray lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        //NSLog(@"Place Country: %@", placeCountry);
        
        // Check the if the placesTVDict doesn't contain a key with the country already]
        // and add it with the place as value
        if (!placesTVDict[placeCountry]) {
            NSMutableArray *placesArray = [NSMutableArray arrayWithObject:place];
            [placesTVDict setObject:placesArray forKey:placeCountry];
        }
        else if(placesTVDict[placeCountry]){
            [placesTVDict[placeCountry] addObject:place];
        }
    }
    //NSLog(@"Places TV Dict: %@", placesTVDict);
    
    return placesTVDict;
}



@end
