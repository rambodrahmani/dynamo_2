//
//  ListaInternetViewController.h
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
#import "EventoViewController.h"

@interface ListaInternetViewController : UIViewController <ECSlidingViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
	NSMutableArray* eventiCaricati;
	
	BOOL hasOpenedMenuOnce;
}

@property (nonatomic, strong) METransitions *transitions;

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndic;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshBarButton;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIButton *refreshLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblCaricamento;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblTitleHgConst;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

- (IBAction)refreshButton:(id)sender;

- (void)loadEvents;
- (IBAction)menuButtonTapped:(id)sender;

@end
