//
//  AlbumViewController.h
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 22/09/14.
//  Copyright (c) 2014 Rambod Rahmani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "METransitions.h"
#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MyCell.h"
#import "Reachability.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "BoccaccioEvent.h"

@interface AlbumViewController : UIViewController <ECSlidingViewControllerDelegate>
{
	NSInteger numeroFoto;
	
	NSArray * photosArray;
	
	NSString * dataEvento;
	
	NSURL * event_video_url;
	
	NSInteger selectedPhotoIndexPathRow;
	
	BOOL hasOpenedMenuOnce;
}

@property (nonatomic, strong) METransitions *transitions;

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitolo;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndic;
@property (weak, nonatomic) IBOutlet UILabel *lblNotAvailable;
@property (weak, nonatomic) IBOutlet UILabel *lblLoading;
@property (weak, nonatomic) IBOutlet UIView *selectedFotoView;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewFoto;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scMedia;
@property (weak, nonatomic) IBOutlet UIWebView* mediaWebView;

@property (strong, atomic) ALAssetsLibrary* library;

@property (nonatomic, strong) BoccaccioEvent * selected_event;

- (IBAction)scSwitched:(id)sender;
- (IBAction)closeFotoView:(id)sender;
- (IBAction)downloadSelectedFoto:(id)sender;
- (IBAction)menuButtonTapped:(id)sender;

@end
