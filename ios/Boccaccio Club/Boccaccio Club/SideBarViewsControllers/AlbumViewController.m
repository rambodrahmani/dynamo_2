//
//  AlbumViewController.m
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 22/09/14.
//  Copyright (c) 2014 Rambod Rahmani. All rights reserved.
//

#import "AlbumViewController.h"

@interface AlbumViewController ()

@end

@implementation AlbumViewController

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
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	hasOpenedMenuOnce = FALSE;
	
	[_mediaWebView setHidden:YES];
	
	_lblTitolo.text = @"";
	
	_library = [[ALAssetsLibrary alloc] init];
	
	[_myCollectionView setContentInset:UIEdgeInsetsMake(0, 0, 8, 0)];
	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter]
	 addObserver:self selector:@selector(orientationChanged:)
	 name:UIDeviceOrientationDidChangeNotification
	 object:[UIDevice currentDevice]];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[_activityIndic startAnimating];
	
	Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
	NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
	if (networkStatus == NotReachable) {
		[[[UIAlertView alloc] initWithTitle:@"Connessione Internet Assente"
									message:@"Connettiti ad internet per poter utilizzare l'App del Boccaccio Club."
								   delegate:self
						  cancelButtonTitle:@"OK!"
						  otherButtonTitles:nil] show];

        [_activityIndic stopAnimating];
        [_activityIndic setHidden:YES];
	} else {		
		[self getPhotosNumber];
		
	}
	
	_transitions = [[METransitions alloc] init];
	
	NSDictionary *params = @{
							 @"id_event": _selected_event.event_id
							 };
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer = [AFHTTPResponseSerializer serializer];
	
	[manager GET:[NSString stringWithFormat:@"%@HttpApp.php?token_access=B5522CLUB5522CLUB&request_info=GET_VIDEOS", BASE_URL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		NSError * error;
		NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&error];
            NSArray *results = [jsonArray objectForKey:@"result"];
        
        
		dispatch_async(dispatch_get_main_queue(), ^{
			if (!error) {
				if (results.count > 0) {
                    NSString * stringa_url_video = [NSString stringWithFormat:@"%@", [results[0] objectForKey:@"url"]];
                    stringa_url_video = [stringa_url_video stringByReplacingOccurrencesOfString:@"\t" withString:@""];
					event_video_url = [NSURL URLWithString:stringa_url_video];
					NSURLRequest* request = [NSURLRequest requestWithURL:event_video_url];
					[_mediaWebView loadRequest:request];
				}
			}
			else {
				[[[UIAlertView alloc] initWithTitle:@"Errore"
											message:@"Si è verificato un errore. Ci scusiamo per l'inconveniente e ti invitiamo a riprovare più tardi."
										   delegate:self
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil] show];
			}
		});
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
	}];
	
	selectedPhotoIndexPathRow = 0;
	
	self.slidingViewController.anchorRightPeekAmount = 80;
	
	// Add the pan gesture to allow sliding
	// [self.view addGestureRecognizer:self.slidingViewController.panGesture];
	
	_imgViewFoto.contentMode = UIViewContentModeScaleAspectFit;
}

- (IBAction)scSwitched:(id)sender
{
	if ((long)_scMedia.selectedSegmentIndex == 1)
	{
		[_mediaWebView setHidden:NO];
	}
	else
	{
		[_mediaWebView setHidden:YES];
	}
}

- (IBAction)menuButtonTapped:(id)sender
{
	self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FotoNavigationController"];
	[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
	
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

- (void)orientationChanged:(NSNotification *)note
{
	[_myCollectionView reloadData];
}

- (void)getPhotosNumber
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
        
        [_activityIndic stopAnimating];
        [_activityIndic setHidden:YES];
	}
	else
	{
		NSString * data = _selected_event.event_data;
		NSArray * data_splitter = [data componentsSeparatedByString:@"-"];
		
		NSString* titolo = [NSString stringWithFormat:@"%@ %@ %@", _selected_event.event_day_name, _selected_event.event_day_number, _selected_event.event_month];
		titolo = [titolo stringByReplacingOccurrencesOfString:@"u00ed" withString:@"ì"];
		[_lblTitolo setText:titolo];
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
			AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
			manager.responseSerializer = [AFHTTPResponseSerializer serializer];
			manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
			
			dataEvento = [NSString stringWithFormat:@"%@-%@-%@", [data_splitter objectAtIndex:2], [data_splitter objectAtIndex:1], [data_splitter objectAtIndex:0]];
			
			NSDictionary *params = @{
									 @"id": _selected_event.event_id,
									 @"data": dataEvento,
									 @"sala": _selected_event.event_sala
									 };
			
			[manager GET:@"http://boccaccio.it/gallery/photo.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
				dispatch_async(dispatch_get_main_queue(), ^{
					
					NSError *error;
					NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&error];
					
					if ([[jsonArray objectForKey:@"status"] isEqualToString:@"OK"]) {
						photosArray = [jsonArray objectForKey:@"array_name"];
						
						if (!error) {
							numeroFoto = [photosArray count];
							if (numeroFoto > 0) {
								[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
								[_activityIndic stopAnimating];
								[_myCollectionView reloadData];
							} else {
								[_lblNotAvailable setHidden:NO];
								[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
								[_activityIndic stopAnimating];
							}
						} else {
							[_lblNotAvailable setHidden:NO];
							[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
							[_activityIndic stopAnimating];
						}
					} else {
						[_lblNotAvailable setHidden:NO];
						[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
						[_activityIndic stopAnimating];
					}
				});
			} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
				//[self showErrorMessage:[NSString stringWithFormat:@"loadAddress: %@", error.description]];
			}];
		});
	}
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return numeroFoto;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
	cell.layer.shouldRasterize = YES;
	cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
	
	NSString * urlString = [NSString stringWithFormat:@"http://www.boccaccio.it/gallery/%@_%@_%@/th/%@", dataEvento, _selected_event.event_id, _selected_event.event_sala, [photosArray objectAtIndex:indexPath.row]];
	urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[cell.myImageView sd_setImageWithURL:[NSURL URLWithString:urlString]
						placeholderImage:[UIImage imageNamed:@"loading.png"]];
	
	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize newCellSize = _myCollectionView.frame.size;
	newCellSize.height = 121;
	newCellSize.width = 138;
	
	return newCellSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
		NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
		if ( !(networkStatus == NotReachable) ) {
			AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
			manager.responseSerializer = [AFHTTPResponseSerializer serializer];
			NSString * udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
			NSDictionary *params = @{
									 @"data_type": @"PHOTO_CLICK",
									 @"view": @"album",
									 @"id_event": _selected_event.event_id,
									 @"photo_name": [NSString stringWithFormat:@"%@_%@_%@/%@", dataEvento, _selected_event.event_id, _selected_event.event_sala, [photosArray objectAtIndex:indexPath.row]],
									 @"device": udid
									 };
			[manager POST:[NSString stringWithFormat:@"%@HttpApp.php?token_access=B5522CLUB5522CLUB&request_info=SET_DATA", BASE_URL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
			} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			}];
		}
	});
	
	//fotoSelezionata = indexPath.row;
	NSString * urlString = [NSString stringWithFormat:@"http://www.boccaccio.it/gallery/%@_%@_%@/%@", dataEvento, _selected_event.event_id, _selected_event.event_sala, [photosArray objectAtIndex:indexPath.row]];
	urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[_imgViewFoto sd_setImageWithURL:[NSURL URLWithString:urlString]
					placeholderImage:[UIImage imageNamed:@"loading.png"]];
	[_selectedFotoView setHidden:NO];
	
	selectedPhotoIndexPathRow = indexPath.row;
	
	UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(photoSliderSlideAnim:)];
	left.direction = UISwipeGestureRecognizerDirectionLeft ;
	[left setNumberOfTouchesRequired:1];
	[_selectedFotoView addGestureRecognizer:left];
	
	UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(photoSliderSlideAnim:)];
	right.direction = UISwipeGestureRecognizerDirectionRight ;
	[right setNumberOfTouchesRequired:1];
	[_selectedFotoView addGestureRecognizer:right];
}

- (void)photoSliderSlideAnim:(UISwipeGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight)
	{
		if (selectedPhotoIndexPathRow >= 1 && selectedPhotoIndexPathRow <= photosArray.count - 1) {
			NSString * urlString = [NSString stringWithFormat:@"http://www.boccaccio.it/gallery/%@_%@_%@/%@", dataEvento, _selected_event.event_id, _selected_event.event_sala, [photosArray objectAtIndex:--selectedPhotoIndexPathRow]];
			urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			
			[_imgViewFoto sd_setImageWithURL:[NSURL URLWithString:urlString]
							placeholderImage:[UIImage imageNamed:@"loading.png"]];
			
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
				Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
				NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
				if ( !(networkStatus == NotReachable) ) {
					AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
					manager.responseSerializer = [AFHTTPResponseSerializer serializer];
					NSString * udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
					NSDictionary *params = @{
											 @"data_type": @"PHOTO_VIEW",
											 @"view": @"album",
											 @"id_event": _selected_event.event_id,
											 @"photo_name": [NSString stringWithFormat:@"%@_%@_%@/%@", dataEvento, _selected_event.event_id, _selected_event.event_sala, [photosArray objectAtIndex:selectedPhotoIndexPathRow]],
											 @"device": udid
											 };
					[manager POST:[NSString stringWithFormat:@"%@HttpApp.php?token_access=B5522CLUB5522CLUB&request_info=SET_DATA", BASE_URL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
					} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
					}];
				}
			});
		}
	}
	else if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft)
	{
		if (selectedPhotoIndexPathRow >= 0 && selectedPhotoIndexPathRow < photosArray.count - 1) {
			NSString * urlString = [NSString stringWithFormat:@"http://www.boccaccio.it/gallery/%@_%@_%@/%@", dataEvento, _selected_event.event_id, _selected_event.event_sala, [photosArray objectAtIndex:++selectedPhotoIndexPathRow]];
			urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			
			[_imgViewFoto sd_setImageWithURL:[NSURL URLWithString:urlString]
							placeholderImage:[UIImage imageNamed:@"loading.png"]];
			
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
				Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
				NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
				if ( !(networkStatus == NotReachable) ) {
					AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
					manager.responseSerializer = [AFHTTPResponseSerializer serializer];
					NSString * udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
					NSDictionary *params = @{
											 @"data_type": @"PHOTO_VIEW",
											 @"view": @"album",
											 @"id_event": _selected_event.event_id,
											 @"photo_name": [NSString stringWithFormat:@"%@_%@_%@/%@", dataEvento, _selected_event.event_id, _selected_event.event_sala, [photosArray objectAtIndex:selectedPhotoIndexPathRow]],
											 @"device": udid
											 };
					[manager POST:[NSString stringWithFormat:@"%@HttpApp.php?token_access=B5522CLUB5522CLUB&request_info=SET_DATA", BASE_URL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
					} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
					}];
				}
			});
		}
	}
}

- (void)saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
	if ([[extension lowercaseString] isEqualToString:@"png"]) {
		[UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
	} else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
		[UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
	} else {
		NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
	}
}

- (IBAction)closeFotoView:(id)sender {
	[_selectedFotoView setHidden:YES];
}

- (IBAction)downloadSelectedFoto:(id)sender {
	//NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	//[self saveImage:[fotoAlbum objectAtIndex:fotoSelezionata] withFileName:@"My Image" ofType:@"jpg" inDirectory:documentsDirectoryPath];
	
	UIImageWriteToSavedPhotosAlbum(_imgViewFoto.image,
								   nil,
								   nil,
								   nil);
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Salvataggio Foto"
													message:@"Foto salvata con successo."
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
		NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
		if ( !(networkStatus == NotReachable) ) {
			AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
			manager.responseSerializer = [AFHTTPResponseSerializer serializer];
			NSString * udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
			NSDictionary *params = @{
									 @"data_type": @"PHOTO_SAVE",
									 @"view": @"album",
									 @"id_event": _selected_event.event_id,
									 @"photo_name": [NSString stringWithFormat:@"%@_%@_%@/%@", dataEvento, _selected_event.event_id, _selected_event.event_sala, [photosArray objectAtIndex:selectedPhotoIndexPathRow]],
									 @"device": udid
									 };
			[manager POST:[NSString stringWithFormat:@"%@HttpApp.php?token_access=B5522CLUB5522CLUB&request_info=SET_DATA", BASE_URL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
			} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			}];
		}
	});
}


@end
