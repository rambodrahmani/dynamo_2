//
//  MyAccountViewController.m
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 17/10/14.
//  Copyright (c) 2014 Rambod Rahmani. All rights reserved.
//

#import "MyAccountViewController.h"

@interface MyAccountViewController () <MZFormSheetBackgroundWindowDelegate>

@end

@implementation MyAccountViewController

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
	
	_tableViewGifts.separatorInset = UIEdgeInsetsZero;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	hasOpenedMenuOnce = FALSE;
	
	menuItems = [[NSMutableArray alloc] initWithObjects:@"Lista dei tuoi regali", @"Prenotazioni Lista Internet", nil];
	
	udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
	
	_transitions = [[METransitions alloc] init];
	
	_tableViewGifts.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	
	self.slidingViewController.anchorRightPeekAmount = 80;
	
	// Add the pan gesture to allow sliding
	[self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (IBAction)menuButtonTapped:(id)sender
{
	if (self.slidingViewController.currentTopViewPosition == 1) {
		[self.slidingViewController resetTopViewAnimated:YES];
	}
	else {
		[self.slidingViewController anchorTopViewToRightAnimated:YES];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [menuItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAccountCellIdentifier"];
	
	[cell.textLabel  setText:[menuItems objectAtIndex:indexPath.row]];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.row == 0) {
		UINavigationController * destinationNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"GiftsNavigationController"];
		self.slidingViewController.topViewController = destinationNavController;
		[self.slidingViewController resetTopViewAnimated:YES];
	}
	else if (indexPath.row == 1) {
		UINavigationController * destinationNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"PrenotazioniNavigationController"];
		self.slidingViewController.topViewController = destinationNavController;
		[self.slidingViewController resetTopViewAnimated:YES];
	}
}

@end
