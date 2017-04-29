//
//  FotoViewController.h
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 30/08/14.
//  Copyright (c) 2014 Rambod Rahmani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "METransitions.h"
#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MyCell.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "BoccaccioEvent.h"
#import "AlbumViewController.h"
#import "AlbumsFooter.h"

@interface FotoViewController : UIViewController <ECSlidingViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
	NSMutableArray * eventiCaricati;
	
	int page_number;
	
	BOOL hasOpenedMenuOnce;
}

@property (nonatomic, strong) METransitions *transitions;

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndic;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshBarButton;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIButton *refreshLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblCaricamento;

- (IBAction)refreshButton:(id)sender;
- (IBAction)menuButtonTapped:(id)sender;

- (void)loadEvents;

@end
