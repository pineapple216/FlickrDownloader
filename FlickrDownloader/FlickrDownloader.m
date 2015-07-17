//
//  FlickrDownloader.m
//  FlickrDownloader
//
//  Created by Koen Hendriks on 05/07/15.
//  Copyright (c) 2015 Koen Hendriks. All rights reserved.
//

#import "FlickrDownloader.h"

@implementation FlickrDownloader

+(void)fetchFlickrDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSDictionary *resultsDict, NSError *error))completionHandler{
    
    NSURLSessionConfiguration *sessionConf = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConf];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            NSLog(@"Error downloading JSON: %@", [error localizedDescription]);
        }
        else{
            NSDictionary *resultsDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            // Call the completion handler on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(resultsDict, error);
            });
        }
    }];
    [task resume];
}

@end
