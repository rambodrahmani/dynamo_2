//
//  EventoViewController.h
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 19/09/14.
//  Copyright (c) 2014 Rambod Rahmani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "METransitions.h"
#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import "BoccaccioEvent.h"
#import "PrenotaListaViewController.h"

@interface EventoViewController : UIViewController <ECSlidingViewControllerDelegate>
{
	BOOL hasOpenedMenuOnce;
}

@property (weak, nonatomic) IBOutlet UILabel *lblTitolo;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitolo;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewEvento;
@property (weak, nonatomic) IBOutlet UITextView *txtViewInfo;
@property (weak, nonatomic) IBOutlet UIButton *buttonPrenota;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndic;

@property (nonatomic, strong) METransitions *transitions;
@property (nonatomic, strong) BoccaccioEvent * selected_event;

- (IBAction)prenotaListaInternet:(id)sender;
- (IBAction)menuButtonTapped:(id)sender;

@end
