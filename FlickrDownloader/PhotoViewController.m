//
//  PhotoViewController.m
//  FlickrDownloader
//
//  Created by Koen Hendriks on 23/06/15.
//  Copyright (c) 2015 Koen Hendriks. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

@synthesize selectedPhoto = _selectedPhoto;
@synthesize imageURL = _imageURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.scrollView addSubview:self.imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    _scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}

-(void)setImage:(UIImage *)image{
    self.scrollView.zoomScale = 1.0;
    self.imageView.image = image;
    [self.imageView sizeToFit];
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    [self.activityIndicatorView stopAnimating];
    [self setZoomScaleToFillScreen];
}

#pragma mark - UIScrollViewDelegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

#pragma mark - Helper Methods

- (void)fetchImage
{
    self.image = nil;
    if (!self.imageURL) return;

    [self.activityIndicatorView startAnimating];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:self.imageURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (!error) {
            if ([response.URL isEqual:self.imageURL]) {
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = image;
                });
            }
        }
    }];
    [task resume];
}

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self fetchImage];
}

- (void)setZoomScaleToFillScreen
{
    double wScale = self.scrollView.bounds.size.width / self.imageView.image.size.width;
    double hScale = (self.scrollView.bounds.size.height - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height) / self.imageView.image.size.height;
    if (wScale > hScale) self.scrollView.zoomScale = wScale;
    else self.scrollView.zoomScale = hScale;
}

@end
