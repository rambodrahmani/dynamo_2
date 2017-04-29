//
//  MyAccountViewController.h
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 17/10/14.
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

@interface MyAccountViewController : UIViewController <ECSlidingViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
	NSMutableArray * menuItems;
	
	NSString * udid;
	
	BOOL hasOpenedMenuOnce;
}

@property (nonatomic, strong) METransitions *transitions;

@property (weak, nonatomic) IBOutlet UITableView *tableViewGifts;

- (IBAction)menuButtonTapped:(id)sender;

@end
