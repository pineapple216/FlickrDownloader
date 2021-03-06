//
//  PlacesTableViewController.h
//  FlickrDownloader
//
//  Created by Koen Hendriks on 23/06/15.
//  Copyright (c) 2015 Koen Hendriks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlacesTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *placesDict;
@property (strong, nonatomic) NSArray *sectionHeadersArray;


-(NSDictionary *)createPlacesDictFromFlickrResults:(NSDictionary *)flickrResults;

@end
