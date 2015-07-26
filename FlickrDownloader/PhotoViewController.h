//
//  PhotoViewController.h
//  FlickrDownloader
//
//  Created by Koen Hendriks on 23/06/15.
//  Copyright (c) 2015 Koen Hendriks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property NSArray *selectedPhoto;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) UIImage *image;


@end
