//
//  PhotoViewController.m
//  FlickrDownloader
//
//  Created by Koen Hendriks on 23/06/15.
//  Copyright (c) 2015 Koen Hendriks. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

@synthesize selectedPhoto = _selectedPhoto;
@synthesize imageURL = _imageURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.scrollView addSubview:self.imageView];
    
    // Saved the viewed photo to CoreData
    
    
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

#pragma mark - Split View Controller Delegate

-(void)awakeFromNib{
    self.splitViewController.delegate = self;
}

// Hide the master view controller when the app is in portrait mode
-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation{
    return UIInterfaceOrientationIsPortrait(orientation);
}

-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc{
    UIViewController *master = aViewController;
    if ([master isKindOfClass:[UITabBarController class]]) {
        master = ((UITabBarController *)master).selectedViewController;
    }
    if ([master isKindOfClass:[UINavigationController class]]) {
        master = ((UINavigationController *)master).topViewController;
    }
    barButtonItem.title = master.title;
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    self.navigationItem.leftBarButtonItem = nil;
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
    double hScale = (self.scrollView.bounds.size.height
                     - self.navigationController.navigationBar.frame.size.height
                     - self.tabBarController.tabBar.frame.size.height
                     - MIN([UIApplication sharedApplication].statusBarFrame.size.height,
                           [UIApplication sharedApplication].statusBarFrame.size.width)
                     ) / self.imageView.image.size.height;
    
    if (wScale > hScale) self.scrollView.zoomScale = wScale;
    else self.scrollView.zoomScale = hScale;
}





@end
