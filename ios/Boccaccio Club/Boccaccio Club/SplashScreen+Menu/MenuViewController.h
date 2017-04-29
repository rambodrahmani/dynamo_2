//
//  MenuViewController.h
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 06/09/14.
//  Copyright (c) 2014 Rambod Rahmani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+ECSlidingViewController.h"
#import "MZFormSheetController.h"
#import "MZCustomTransition.h"
#import "MZFormSheetSegue.h"

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
	NSArray * menuItems;
}

@property (weak, nonatomic) IBOutlet UIImageView *boccaccio_logo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *boccaccioLogoHeight;

- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue;

@property (weak, nonatomic) IBOutlet UITableView *sideTableView;

@end
