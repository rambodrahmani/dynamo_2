//
//  SplashScreenViewController.m
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 30/08/14.
//  Copyright (c) 2014 Rambod Rahmani. All rights reserved.
//

#import "SplashScreenViewController.h"

#define versioneApp @"1.9"

@interface SplashScreenViewController ()

@end

@implementation SplashScreenViewController

#define BASE_URL @"http://www.boccaccio.it/app/1.5/"

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	locationManager = [[CLLocationManager alloc] init];
	
	udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
	
    @try {
        if ([CLLocationManager locationServicesEnabled]) {
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            if (status == kCLAuthorizationStatusNotDetermined) {
                [locationManager requestAlwaysAuthorization];
                locationManager.delegate = self;
                locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                [locationManager startUpdatingLocation];
                
                [NSTimer scheduledTimerWithTimeInterval:10
                                                 target:self
                                               selector:@selector(onTickSendUserPos)
                                               userInfo:nil
                                                repeats:NO];
            }
            else if (status != kCLAuthorizationStatusAuthorizedAlways) {
                // PERMESSO NEGATO
				PFInstallation *currentInstallation = [PFInstallation currentInstallation];
				[currentInstallation addUniqueObject:@"iosNoGeo" forKey:@"channels"];
				[currentInstallation saveInBackground];
            }
            else {
                locationManager.delegate = self;
                locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                [locationManager startUpdatingLocation];
                
                [NSTimer scheduledTimerWithTimeInterval:10
                                                 target:self
                                               selector:@selector(onTickSendUserPos)
                                               userInfo:nil
                                                repeats:NO];
            }
        }
        else {
            // GPS SPENTO
			PFInstallation *currentInstallation = [PFInstallation currentInstallation];
			[currentInstallation addUniqueObject:@"iosNoGeo" forKey:@"channels"];
			[currentInstallation saveInBackground];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    NSTimeInterval interval = 2.0;
    [NSTimer scheduledTimerWithTimeInterval:interval
                                     target:self
                                   selector:@selector(closeSplashScreen)
                                   userInfo:nil
                                    repeats:NO];
    
    [self getAppVersion];
}

- (void)getAppVersion
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
		Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
		NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
		if (networkStatus == NotReachable) {
			[[[UIAlertView alloc] initWithTitle:@"Connessione Internet Assente"
										message:@"Connettiti ad internet per poter utilizzare l'App del Boccaccio Club."
									   delegate:self
							  cancelButtonTitle:@"OK!"
							  otherButtonTitles:nil] show];
		} else {
			@try {
				AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
				manager.responseSerializer = [AFHTTPResponseSerializer serializer];
				
				NSDictionary *params = @{@"settings": @"version_ios"};
				
				[manager POST:[NSString stringWithFormat:@"%@HttpApp.php?token_access=B5522CLUB5522CLUB&request_info=GET_SETTINGS", BASE_URL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
					dispatch_async(dispatch_get_main_queue(), ^{ // 2
						NSError * error;
						NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&error];
						NSArray *results = [jsonArray objectForKey:@"result"];
						
						if ([results valueForKey:@"value"]) {
							if (![[results valueForKey:@"value"] isEqualToString:versioneApp]) {
								[[[UIAlertView alloc] initWithTitle:@"Aggiornamento Disponibile"
															message:[NSString stringWithFormat:@"Una nuova versione dell'Applicazione del Boccaccio Club è disponibile nello store. Passa dalla %@ alla versione %@ per utilizzare le nuove funzionalità.", versioneApp, [results valueForKey:@"value"]]
														   delegate:self
												  cancelButtonTitle:@"Chiudi"
												  otherButtonTitles:nil] show];
							}
						}
						
						NSString *service_status = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://rambodrahmani.it/bcccc_service_status.txt"] encoding:NSUTF8StringEncoding error:nil];
						if (![service_status containsString:@"SERVICE_STATUS_OK"]) {
							[[[UIAlertView alloc] initWithTitle:@"Servizio Non Disponibile"
														message:[NSString stringWithFormat:@"Il servizio non è momentaneamente disponibile."]
													   delegate:self
											  cancelButtonTitle:@"Chiudi"
											  otherButtonTitles:nil] show];
						}
					});
				} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
				}];
			}
			@catch (NSException *exception) {
			}
			@finally {
			}
		}
	});
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Chiudi"])
	{
		exit(0);
	}
}


- (void)onTickSendUserPos
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
		Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
		NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
		if (networkStatus == NotReachable) {
			[[[UIAlertView alloc] initWithTitle:@"Connessione Internet Assente"
										message:@"Connettiti ad internet per poter utilizzare l'App del Boccaccio Club."
									   delegate:self
							  cancelButtonTitle:@"OK!"
							  otherButtonTitles:nil] show];
		} else {
			@try {
				AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
				manager.responseSerializer = [AFHTTPResponseSerializer serializer];
				
				NSDictionary *params = @{
										 @"device": udid,
										 @"lat": [NSNumber numberWithDouble:locationManager.location.coordinate.latitude],
										 @"lon": [NSNumber numberWithDouble:locationManager.location.coordinate.longitude],
										 @"pre": [NSNumber numberWithDouble:locationManager.location.horizontalAccuracy],
										 @"typeDevice": @"appiOS"
										 };
				
				[manager POST:[NSString stringWithFormat:@"%@HttpApp.php?token_access=B5522CLUB5522CLUB&request_info=SET_POSITION", BASE_URL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
				} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
				}];
			}
			@catch (NSException *exception) {
			}
			@finally {
			}
		}
	});
}

- (void)closeSplashScreen
{
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"InitView"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    // Impostiamo il full screen per questa view.
    return YES;
}

@end
