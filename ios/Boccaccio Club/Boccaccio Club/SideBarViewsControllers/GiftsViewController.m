//
//  GiftsViewController.m
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 17/04/15.
//  Copyright (c) 2014 Rambod Rahmani. All rights reserved.
//

#import "GiftsViewController.h"

@interface GiftsViewController () <MZFormSheetBackgroundWindowDelegate>

@end

@implementation GiftsViewController

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
	
    _btnCodicePromozionale.layer.borderWidth = 1;
    _btnCodicePromozionale.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    _btnCodicePromozionale.layer.cornerRadius = 10;
    
	udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
	
	Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
	NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
	if (networkStatus == NotReachable) {
		[[[UIAlertView alloc] initWithTitle:@"Connessione Internet Assente"
									message:@"Connettiti ad internet per poter utilizzare l'App del Boccaccio Club."
								   delegate:self
						  cancelButtonTitle:@"OK!"
						  otherButtonTitles:nil] show];
	} else {
		[self loadGifts];
	}
	
	_transitions = [[METransitions alloc] init];
	
	self.slidingViewController.anchorRightPeekAmount = 80;
	
	// Add the pan gesture to allow sliding
	[self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (IBAction)menuButtonTapped:(id)sender
{
	self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyAccountNavigationController"];
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

- (void)loadGifts
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
	NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
	if (networkStatus == NotReachable) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		
		[[[UIAlertView alloc] initWithTitle:@"No Internet Connection"
									message:@"The internet connection appears to be offline."
								   delegate:self
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil] show];
	}
	else
	{
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
			AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
			manager.responseSerializer = [AFHTTPResponseSerializer serializer];
			
			NSDictionary *params = @{@"device": udid};
			
			[manager POST:[NSString stringWithFormat:@"%@HttpApp.php?token_access=B5522CLUB5522CLUB&request_info=GET_PROMO_CLIENT", BASE_URL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
				
				NSError * error;
				NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&error];
				NSArray *results = [jsonArray objectForKey:@"result"];
				
				dispatch_async(dispatch_get_main_queue(), ^{
					[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
					
					if ([results count] > 0) {
						elencoGifts = [[NSMutableArray alloc] initWithArray:results];
						
						[_tableViewGifts reloadData];
					}
				});
			} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
				[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			}];
		});
	}
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"formSheet"]) {
		NSLog(@"eccociii");
        MZFormSheetSegue *formSheetSegue = (MZFormSheetSegue *)segue;
        MZFormSheetController *formSheet = formSheetSegue.formSheetController;
        formSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
        formSheet.cornerRadius = 8.0;
        formSheet.presentedFormSheetSize = CGSizeMake(270, 220);
        
        formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {
			[self loadGifts];
        };
        
        formSheet.shouldDismissOnBackgroundViewTap = YES;
        
        formSheet.didPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
            
        };
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [elencoGifts count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray * cellData = [elencoGifts objectAtIndex:indexPath.row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GiftCellIdentifier"];
	
	[cell.textLabel  setText:[cellData valueForKey:@"tipo"]];
	[cell.detailTextLabel setText:[NSString stringWithFormat:@"Valido %@ %@ %@ %@", [cellData valueForKey:@"validita_name"], [cellData valueForKey:@"validita_number"], [cellData valueForKey:@"validita_month"], [cellData valueForKey:@"validita_year"]]];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray * cellData = [elencoGifts objectAtIndex:indexPath.row];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:cellData forKey:@"datiGiftSelezionato"];
	
	self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GiftNavigationController"];
	[self.slidingViewController resetTopViewAnimated:NO];
}

@end
