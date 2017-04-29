//
//  PrenotaListaViewController.h
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 24/09/14.
//  Copyright (c) 2014 Rambod Rahmani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "METransitions.h"
#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MyCell.h"
#import "Reachability.h"
#import <UIKit/UIDevice.h>
#import "MLPAutoCompleteTextFieldDelegate.h"
#import "AFNetworking.h"
#import "BoccaccioEvent.h"

@class DEMODataSource;
@class MLPAutoCompleteTextField;
@interface PrenotaListaViewController : UIViewController <ECSlidingViewControllerDelegate, UITextFieldDelegate, MLPAutoCompleteTextFieldDelegate>
{
    NSArray * valoriAmmessi;
	
	NSInteger promozioniPresenti;
	
	NSString * udid;
	
	BOOL hasOpenedMenuOnce;
}

@property (nonatomic, strong) METransitions *transitions;

@property (strong, nonatomic) IBOutlet DEMODataSource *autocompleteDataSource;
@property (weak) IBOutlet MLPAutoCompleteTextField *autocompleteTextField;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndic;
@property (weak, nonatomic) IBOutlet UITextView *txtViewPromo1;
@property (weak, nonatomic) IBOutlet UITextView *txtViewInfoSerata;
@property (weak, nonatomic) IBOutlet UITextView *txtViewPromo2;
@property (weak, nonatomic) IBOutlet UITextView *txtviewPrivacy;

// Iboutlet relativi all'invio dei dati al Server
@property (weak, nonatomic) IBOutlet UISwitch *switcherPromo1;
@property (weak, nonatomic) IBOutlet UISwitch *switcherPromo2;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldNome;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldCognome;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldTelefono;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldNumAmici;
@property (weak, nonatomic) IBOutlet UISwitch *switcherPrivacy;
@property (weak, nonatomic) IBOutlet UISwitch *switcherMemorizza;
@property (weak, nonatomic) IBOutlet UIButton *btnInvia;

@property (nonatomic, strong) BoccaccioEvent * selected_event;

- (IBAction)inviaDatiPrenotazione:(id)sender;
- (IBAction)menuButtonTapped:(id)sender;

@end
