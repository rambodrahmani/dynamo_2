//
//  GiftViewController.m
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 26/10/14.
//  Copyright (c) 2014 Rambod Rahmani. All rights reserved.
//

#import "GiftViewController.h"

@interface GiftViewController ()

@end

@implementation GiftViewController

#define BASE_URL @"http://www.boccaccio.it/app/1.5/"

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// Add a shadow to the top view so it looks like it is on top of the others
	self.view.layer.shadowOpacity = 0.75f;
	self.view.layer.shadowRadius = 10.0f;
	self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
	
    // Personalizzazione Top Bar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(27.0/255.0) green:(27.0/255.0) blue:(27.0/255.0) alpha:1];
    self.navigationController.navigationBar.translucent = NO;
	if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
	{
		[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"boccaccioclub_ipad.png"] forBarMetrics:UIBarMetricsDefault];
		//[_refreshButton setHidden:YES];
		//[_refreshLabel setHidden:YES];
	} else {
		self.navigationItem.rightBarButtonItem = nil;
		[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"boccaccioclub.png"] forBarMetrics:UIBarMetricsDefault];
	}
	
	//[_activityIndic setColor:[UIColor colorWithRed:(32.0/255.0) green:(77.0/255.0) blue:(126.0/255.0) alpha:1.0]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray * giftSelezionato = [defaults objectForKey:@"datiGiftSelezionato"];
    
    [_lblCodPromo setText:[giftSelezionato valueForKey:@"codice"]];
    [_lblTitolo setText:[giftSelezionato valueForKey:@"tipo"]];
    [_lblValidita setText:[NSString stringWithFormat:@"Valido %@ %@ %@ %@", [giftSelezionato valueForKey:@"validita_name"], [giftSelezionato valueForKey:@"validita_number"], [giftSelezionato valueForKey:@"validita_month"], [giftSelezionato valueForKey:@"validita_year"]]];
    [_lblScadenza setText:[NSString stringWithFormat:@"Scade il %@", [giftSelezionato valueForKey:@"scadenza"]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

	hasOpenedMenuOnce = FALSE;
	
	[_lblCodPromo setText:@""];
	[_lblTitolo setText:@""];
	[_lblValidita setText:@""];
    [_lblScadenza setText:@""];
	
	_transitions = [[METransitions alloc] init];
	
	self.slidingViewController.anchorRightPeekAmount = 80;
	
	// Add the pan gesture to allow sliding
	[self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (IBAction)menuButtonTapped:(id)sender
{
	self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GiftsNavigationController"];
	[self.slidingViewController resetTopViewAnimated:NO];
	/*if (self.slidingViewController.currentTopViewPosition == 1) {
		[self.slidingViewController resetTopViewAnimated:YES];
	}
	else {
		[self.slidingViewController anchorTopViewToRightAnimated:YES];
	}*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
