//
//  CodicePromozionaleViewController.h
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 07/10/15.
//  Copyright © 2015 Rambod Rahmani. All rights reserved.
//

#import "Reachability.h"
#import <UIKit/UIKit.h>
#import "METransitions.h"
#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MZFormSheetController.h"
#import "MZCustomTransition.h"
#import "MZFormSheetSegue.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"

@interface CodicePromozionaleViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainView_top;

@property (weak, nonatomic) IBOutlet UITextField *txtFieldCodice;
@property (weak, nonatomic) IBOutlet UIButton *btnPrenota;

- (IBAction)utilizzaCodice:(id)sender;

@end
