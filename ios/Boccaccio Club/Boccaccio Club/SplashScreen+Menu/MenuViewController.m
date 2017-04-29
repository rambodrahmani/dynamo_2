//
//  MenuViewController.m
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 06/09/14.
//  Copyright (c) 2014 Rambod Rahmani. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

#define BASE_URL @"http://www.boccaccio.it/app/1.5/"

- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue { }

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIView * status_bar_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
	status_bar_view.backgroundColor = [UIColor blackColor];
	[self.view addSubview:status_bar_view];
	
	if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
	{
		_boccaccioLogoHeight.constant = 80;
		[_boccaccio_logo needsUpdateConstraints];
	}
	
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	menuItems = [[NSArray alloc] initWithObjects:@"My Account", @"", @"Home", @"", @"Media", @"", @"Eventi", @"", @"Lista Internet", @"", @"Codice Promozionale", @"", @"Contatti", @"", @"About", nil];
	
	self.view.backgroundColor = [UIColor colorWithRed:(27.0/255.0) green:(27.0/255.0) blue:(27.0/255.0) alpha:1];
	
	[_sideTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	
	[_sideTableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	
	_sideTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,0.0f,1.0f,1.0f)];
	
	UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
	backView.backgroundColor = [UIColor clearColor];
	_sideTableView.backgroundView = backView;
	_sideTableView.backgroundColor = [UIColor clearColor];
	
	[MZFormSheetController registerTransitionClass:[MZCustomTransition class] forTransitionStyle:MZFormSheetTransitionStyleCustom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell * newCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuTableViewCell"];
	newCell.textLabel.text = [menuItems objectAtIndex:indexPath.row];
	
	if (indexPath.row%2 == 0) {
		newCell.layer.borderWidth = 1.0;
		newCell.layer.borderColor = [[UIColor colorWithRed:(32.0/255.0) green:(77.0/255.0) blue:(126.0/255.0) alpha:1.0] CGColor];
	}
	else
	{
		newCell.userInteractionEnabled = false;
	}
	
	newCell.textLabel.textColor = [UIColor whiteColor];
	
	UIView *selectionColor = [[UIView alloc] init];
	selectionColor.backgroundColor = [UIColor colorWithRed:(32.0/255.0) green:(77.0/255.0) blue:(126.0/255.0) alpha:1.0];
	newCell.selectedBackgroundView = selectionColor;
	
	UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
	backView.backgroundColor = [UIColor clearColor];
	newCell.backgroundView = backView;
	newCell.backgroundColor = [UIColor clearColor];
	
	return newCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row%2 != 0) {
		return 10.0;
	}
	
	return 40.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	ECSlidingViewController *slidingController = self.slidingViewController;
	
	NSString * viewIdentifier = @"";
	switch (indexPath.row) {
		case 0:
			viewIdentifier = @"MyAccountNavigationController";
			break;
		case 2:
			viewIdentifier = @"HomeNavigationController";
			break;
		case 4:
			viewIdentifier = @"FotoNavigationController";
			break;
		case 6:
			viewIdentifier = @"EventiNavigationController";
			break;
		case 8:
			viewIdentifier = @"ListaInternetNavigationController";
			break;
		case 10:
			[self performSegueWithIdentifier:@"ShowCodicePromozionaleView" sender:nil];
			break;
		case 12:
			viewIdentifier = @"ContattiNavigationController";
			break;
		case 14:
			viewIdentifier = @"AboutNavigationController";
			break;
		default:
			break;
	}
	
	
	if (viewIdentifier.length > 2) {
		UIViewController * destinationView = [self.storyboard instantiateViewControllerWithIdentifier:viewIdentifier];
		
		if (![slidingController.topViewController.title containsString:destinationView.title]) {
			slidingController.topViewController = destinationView;
			[slidingController resetTopViewAnimated:NO];
		}
		else
		{
			if (self.slidingViewController.currentTopViewPosition == 1) {
				[self.slidingViewController resetTopViewAnimated:YES];
			}
			else {
				[self.slidingViewController anchorTopViewToRightAnimated:YES];
			}
		}
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"formSheet"]) {
		MZFormSheetSegue *formSheetSegue = (MZFormSheetSegue *)segue;
		MZFormSheetController *formSheet = formSheetSegue.formSheetController;
		formSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
		formSheet.cornerRadius = 8.0;
		formSheet.presentedFormSheetSize = CGSizeMake(270, 220);
		
		formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
			
		};
		
		formSheet.shouldDismissOnBackgroundViewTap = YES;
		
		formSheet.didPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
			
		};
	}
}

-(UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent; // your own style
}

- (BOOL)prefersStatusBarHidden {
	return NO; // your own visibility code
}

- (void)formSheetBackgroundWindow:(MZFormSheetBackgroundWindow *)formSheetBackgroundWindow didChangeStatusBarToOrientation:(UIInterfaceOrientation)orientation
{
	//NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)formSheetBackgroundWindow:(MZFormSheetBackgroundWindow *)formSheetBackgroundWindow didChangeStatusBarFrame:(CGRect)newStatusBarFrame
{
	//NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)formSheetBackgroundWindow:(MZFormSheetBackgroundWindow *)formSheetBackgroundWindow didRotateToOrientation:(UIDeviceOrientation)orientation animated:(BOOL)animated
{
	//NSLog(@"%@",NSStringFromSelector(_cmd));
}

@end
