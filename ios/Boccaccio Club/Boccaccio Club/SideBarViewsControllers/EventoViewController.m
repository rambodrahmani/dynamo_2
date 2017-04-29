//
//  EventoViewController.m
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 19/09/14.
//  Copyright (c) 2014 Rambod Rahmani. All rights reserved.
//

#import "EventoViewController.h"

@interface EventoViewController ()

@end

@implementation EventoViewController

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
	
	[_activityIndic setColor:[UIColor colorWithRed:(32.0/255.0) green:(77.0/255.0) blue:(126.0/255.0) alpha:1.0]];
	
	NSString* titolo = [NSString stringWithFormat:@"%@ %@ %@", _selected_event.event_day_name, _selected_event.event_day_number, _selected_event.event_month];
	titolo = [titolo stringByReplacingOccurrencesOfString:@"u00ed" withString:@"ì"];
	[_lblTitolo setText:titolo];
	
	NSString * subTitolo = [NSString stringWithFormat:@"%@", _selected_event.event_sala];
	[_lblSubTitolo setText:subTitolo];
	
	[_imgViewEvento sd_setImageWithURL:[NSURL URLWithString:_selected_event.event_link_image] placeholderImage:[UIImage imageNamed:@"loading.png"]];
	
	[_imgViewEvento.layer setBorderColor:[[UIColor colorWithRed:(32.0/255.0) green:(77.0/255.0) blue:(126.0/255.0) alpha:1.0] CGColor]];
	[_imgViewEvento.layer setBorderWidth:1.2];
	
	[_txtViewInfo setText:[NSString stringWithFormat:@"%@\n%@\n%@\n\n%@\n%@\n%@\n", _selected_event.event_promo_1_txt_1, _selected_event.event_promo_1_txt_2, _selected_event.event_promo_1_txt_3, _selected_event.event_promo_2_txt_1, _selected_event.event_promo_2_txt_2, _selected_event.event_promo_2_txt_3]];
	[_txtViewInfo setText:[_txtViewInfo.text stringByReplacingOccurrencesOfString:@"&euro;" withString:@"€"]];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	hasOpenedMenuOnce = FALSE;
	
	[_lblTitolo setText:@""];
	[_lblSubTitolo setText:@""];
	
	_buttonPrenota.layer.borderWidth = 1;
	_buttonPrenota.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
	_buttonPrenota.layer.cornerRadius = 10;
	
	if ([_selected_event.event_lista_internet containsString:@"1"]) {
		[_buttonPrenota setHidden:NO];
	} else {
		[_buttonPrenota setHidden:YES];
	}
	[_txtViewInfo setText:@""];
	
	_transitions = [[METransitions alloc] init];
	
	self.slidingViewController.anchorRightPeekAmount = 80;
	
	// Add the pan gesture to allow sliding
	[self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (IBAction)menuButtonTapped:(id)sender
{
	[self backToHome];
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

- (IBAction)prenotaListaInternet:(id)sender
{
	UINavigationController * destinationNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"PrenotaListaNavigationController"];
	PrenotaListaViewController * destinationViewcontroller =  destinationNavController.viewControllers[0];
	destinationViewcontroller.selected_event = _selected_event;
	self.slidingViewController.topViewController = destinationNavController;
	[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)backToHome {
	if ([_selected_event.page_source containsString:@"page_home"]) {
		ECSlidingViewController *slidingController = self.slidingViewController;
		slidingController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventiNavigationController"];
		[slidingController resetTopViewAnimated:NO];
	}
	else if ([_selected_event.page_source containsString:@"page_eventi"])
	{
		ECSlidingViewController *slidingController = self.slidingViewController;
		slidingController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventiNavigationController"];
		[slidingController resetTopViewAnimated:NO];
	}
	else {
		ECSlidingViewController *slidingController = self.slidingViewController;
		slidingController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListaInternetNavigationController"];
		[slidingController resetTopViewAnimated:NO];
	}
}

@end
