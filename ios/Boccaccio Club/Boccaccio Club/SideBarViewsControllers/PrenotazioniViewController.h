//
//  PrenotazioniViewController.h
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 19/04/15.
//  Copyright (c) 2014 Rambod Rahmani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "METransitions.h"
#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MZFormSheetController.h"
#import "MZCustomTransition.h"
#import "MZFormSheetSegue.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "BoccaccioEvent.h"
#import "UIImageView+WebCache.h"
#import "MyCell.h"

@interface PrenotazioniViewController : UIViewController <ECSlidingViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
	NSMutableArray * eventiCaricati;
	
	NSString * udid;
	
	BOOL hasOpenedMenuOnce;
}

@property (nonatomic, strong) METransitions *transitions;

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndic;

- (IBAction)menuButtonTapped:(id)sender;

@end
