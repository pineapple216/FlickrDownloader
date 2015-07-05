//
//  FlickrDownloader.h
//  FlickrDownloader
//
//  Created by Koen Hendriks on 05/07/15.
//  Copyright (c) 2015 Koen Hendriks. All rights reserved.
//

#import "FlickrFetcher.h"

@interface FlickrDownloader : FlickrFetcher

+(void)fetchFlickrDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *data, NSError *error))completionHandler;

@end
