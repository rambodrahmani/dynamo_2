//
//  GiftViewController.h
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 26/10/14.
//  Copyright (c) 2014 Rambod Rahmani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "METransitions.h"
#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"

@interface GiftViewController : UIViewController <ECSlidingViewControllerDelegate>
{
	BOOL hasOpenedMenuOnce;
}

@property (nonatomic, strong) METransitions *transitions;

@property (weak, nonatomic) IBOutlet UILabel *lblTitolo;
@property (weak, nonatomic) IBOutlet UILabel *lblValidita;
@property (weak, nonatomic) IBOutlet UILabel *lblCodPromo;
@property (weak, nonatomic) IBOutlet UILabel *lblScadenza;

- (IBAction)menuButtonTapped:(id)sender;

@end
