//
//  AboutViewController.h
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 30/08/14.
//  Copyright (c) 2014 Rambod Rahmani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "METransitions.h"
#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"

@interface AboutViewController : UIViewController <ECSlidingViewControllerDelegate>
{
	BOOL hasOpenedMenuOnce;
}

@property (nonatomic, strong) METransitions *transitions;

- (IBAction)menuButtonTapped:(id)sender;

@end
