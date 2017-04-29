//
//  ListaInternetViewController.m
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 30/08/14.
//  Copyright (c) 2014 Rambod Rahmani. All rights reserved.
//

#import "ListaInternetViewController.h"

@interface ListaInternetViewController ()

@end

@implementation ListaInternetViewController

#define BASE_URL @"http://www.boccaccio.it/app/1.5/"

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// Add a shadow to the top view so it looks like it is on top of the others
	self.view.layer.shadowOpacity = 0.75f;
	self.view.layer.shadowRadius = 10.0f;
	self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
	
	// Add the pan gesture to allow sliding
	[self.view addGestureRecognizer:self.slidingViewController.panGesture];
	
    // Personalizzazione Top Bar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(27.0/255.0) green:(27.0/255.0) blue:(27.0/255.0) alpha:1];
    self.navigationController.navigationBar.translucent = NO;
	if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
	{
		[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"boccaccioclub_ipad.png"] forBarMetrics:UIBarMetricsDefault];
		[_refreshButton setHidden:YES];
		[_refreshLabel setHidden:YES];
	} else {
		self.navigationItem.rightBarButtonItem = nil;
		[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"boccaccioclub.png"] forBarMetrics:UIBarMetricsDefault];
		_lblTitleHgConst.constant = 42;
		[_lblTitle needsUpdateConstraints];
	}
	
	[_activityIndic setColor:[UIColor colorWithRed:(32.0/255.0) green:(77.0/255.0) blue:(126.0/255.0) alpha:1.0]];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	hasOpenedMenuOnce = FALSE;
	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter]
	 addObserver:self selector:@selector(orientationChanged:)
	 name:UIDeviceOrientationDidChangeNotification
	 object:[UIDevice currentDevice]];
	
	[_myCollectionView setContentInset:UIEdgeInsetsMake(0, 0, 8, 0)];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[_activityIndic startAnimating];
	[_lblCaricamento setHidden:NO];
	
	Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
	NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
	if (networkStatus == NotReachable) {
		[[[UIAlertView alloc] initWithTitle:@"Connessione Internet Assente"
									message:@"Connettiti ad internet per poter utilizzare l'App del Boccaccio Club."
								   delegate:self
						  cancelButtonTitle:@"OK!"
						  otherButtonTitles:nil] show];
        
        [_lblCaricamento setHidden:YES];
        [_activityIndic stopAnimating];
        [_activityIndic setHidden:YES];
	} else {
		[self loadEvents];
	}
	
	_transitions = [[METransitions alloc] init];
	
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

- (void)orientationChanged:(NSNotification *)note
{
	[_myCollectionView reloadData];
}

- (void)galleryImageTapDetected {
	self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FotoNavigationController"];
	[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)refreshButton:(id)sender {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[_activityIndic startAnimating];
	[_lblCaricamento setHidden:NO];
	
	[eventiCaricati removeAllObjects];
	
	[_myCollectionView reloadData];
	
	[self loadEvents];
}

- (void)loadEvents
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[_activityIndic startAnimating];
	
	Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
	NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
	if (networkStatus == NotReachable) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		
		[[[UIAlertView alloc] initWithTitle:@"No Internet Connection"
									message:@"The internet connection appears to be offline."
								   delegate:self
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil] show];
        
        [_lblCaricamento setHidden:YES];
        [_activityIndic stopAnimating];
        [_activityIndic setHidden:YES];
	}
	else
	{
		eventiCaricati = [[NSMutableArray array] init];
		
		AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
		manager.responseSerializer = [AFHTTPResponseSerializer serializer];
		
		[manager GET:[NSString stringWithFormat:@"%@HttpApp.php?token_access=B5522CLUB5522CLUB&request_info=GET_ALL_EVENTS", BASE_URL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			[_lblCaricamento setHidden:YES];
			[_activityIndic stopAnimating];
			
			NSError * error;
			NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&error];
			NSArray *results = [jsonArray objectForKey:@"result"];
			
			if (!error) {
				for (NSDictionary *tempDictionary in results) {
					BoccaccioEvent * new_event = [[BoccaccioEvent alloc] initWith_event_id:[NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"id"]]
																			  event_titolo:[NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"titolo"]]
																				event_sala:[NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"sala"]]
																	  event_lista_internet:[NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"lista_internet"]]
																	   event_promo_1_txt_1:[NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"promo_1_txt_1"]]
																	   event_promo_1_txt_2:[NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"promo_1_txt_2"]]
																	   event_promo_1_txt_3:[NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"promo_1_txt_3"]]
																	   event_promo_2_txt_1:[NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"promo_2_txt_1"]]
																	   event_promo_2_txt_2:[NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"promo_2_txt_2"]]
																	   event_promo_2_txt_3:[NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"promo_2_txt_3"]]
																		 event_descrizione:[NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"descrizione"]]
																				event_data:[NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"data"]]
																			event_day_name:[NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"day_name"]]
																		  event_day_number:[NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"day_number"]]
																			   event_month:[NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"month"]]
																				event_year:[NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"year"]]
																		  event_date_italy:[NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"date_italy"]]
																		  event_link_image:[NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"link_image"]]
																			   page_source:[NSString stringWithFormat:@"page_lista"]];
					[eventiCaricati addObject:new_event];
				}
			}
			else {
				[[[UIAlertView alloc] initWithTitle:@"Errore"
											message:@"Si è verificato un errore. Ci scusiamo per l'inconveniente e ti invitiamo a riprovare più tardi."
										   delegate:self
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil] show];
			}
			
			dispatch_async(dispatch_get_main_queue(), ^{
				[_myCollectionView reloadData];
			});
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		}];
	}
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [eventiCaricati count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	BoccaccioEvent * datiEvento = [eventiCaricati objectAtIndex:indexPath.row];
	
	NSString* titolo = [NSString stringWithFormat:@"%@ %@ %@ - %@", datiEvento.event_day_name, datiEvento.event_day_number, datiEvento.event_month, datiEvento.event_sala];
	titolo = [titolo stringByReplacingOccurrencesOfString:@"u00ed" withString:@"ì"];
	
	MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
	cell.layer.shouldRasterize = YES;
	cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
	
	cell.contentView.frame = cell.bounds;
	cell.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	[cell.myImageView sd_setImageWithURL:[NSURL URLWithString:datiEvento.event_link_image] placeholderImage:[UIImage imageNamed:@"loading.png"]];
	[cell.myImageView.layer setBorderColor:[[UIColor colorWithRed:(32.0/255.0) green:(77.0/255.0) blue:(126.0/255.0) alpha:1.0] CGColor]];
	[cell.myImageView.layer setBorderWidth:1.2];
	cell.myLabel.text = titolo;
	[cell.myLabel setTextColor:[UIColor whiteColor]];
	cell.backgroundColor = [UIColor colorWithRed:(27.0/255.0) green:(27.0/255.0) blue:(27.0/255.0) alpha:1];
	
	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize newCellSize = _myCollectionView.frame.size;
	
	if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
	{
		newCellSize.height = 350;
	} else {
		newCellSize.height = 230;
	}
	
	return newCellSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	BoccaccioEvent * datiEvento = [eventiCaricati objectAtIndex:indexPath.row];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
		NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
		if ( !(networkStatus == NotReachable) ) {
			AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
			manager.responseSerializer = [AFHTTPResponseSerializer serializer];
			NSString * udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
			NSDictionary *params = @{
									 @"data_type": @"EVENT_CLICK",
									 @"view": @"eventi_lista",
									 @"id_event": datiEvento.event_id,
									 @"photo_name": @"",
									 @"device": udid
									 };
			[manager POST:[NSString stringWithFormat:@"%@HttpApp.php?token_access=B5522CLUB5522CLUB&request_info=SET_DATA", BASE_URL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
			} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			}];
		}
	});
	
	NSString * pulsantePresente = [NSString stringWithFormat:@"%@", [eventiCaricati objectAtIndex:0]];
	
	if ([pulsantePresente isEqualToString:@"0"]) {
		[[[UIAlertView alloc] initWithTitle:@"Non Disponibile"
									message:@"La prenotazione della lista internet non è disponibile per l'evento scielto."
								   delegate:self
						  cancelButtonTitle:@"OK!"
						  otherButtonTitles:nil] show];
	} else {
		UINavigationController * destinationNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"EventoNavigationController"];
		EventoViewController * destinationViewcontroller =  destinationNavController.viewControllers[0];
		destinationViewcontroller.selected_event = datiEvento;
		self.slidingViewController.topViewController = destinationNavController;
		[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
	}
}

@end
