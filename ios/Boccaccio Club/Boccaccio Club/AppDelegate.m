//
//  AppDelegate.m
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 24/08/14.
//  Copyright (c) 2014 Rambod Rahmani. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#define BASE_URL @"http://www.boccaccio.it/app/1.5/"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[Parse setApplicationId:@"gNsNmqZDxaZiWQg6hET7GEATDjJAEcuJacxJ72hi"
				  clientKey:@"sKb8knJEa4W18lu1qOLKIeH5UzTJjWWYrN3c4jYg"];
	
	// Register for Push Notitications
	UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
													UIUserNotificationTypeBadge |
													UIUserNotificationTypeSound);
	UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
																			 categories:nil];
	[application registerUserNotificationSettings:settings];
	[application registerForRemoteNotifications];
	
    // Override point for customization after application launch.
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce_BoccaccioClub"])
	{
		// app already launched
	}
	else
	{
        @try {
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
				Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
				NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
				if ( !(networkStatus == NotReachable) ) {
					NSString * udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
					
					AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
					manager.responseSerializer = [AFHTTPResponseSerializer serializer];
					NSDictionary *params = @{
											 @"device": udid,
											 @"typeDevice": @"appiOS"
											 };
					[manager POST:[NSString stringWithFormat:@"%@HttpApp.php?token_access=B5522CLUB5522CLUB&request_info=SET_DEVICE", BASE_URL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
						dispatch_async(dispatch_get_main_queue(), ^{
							
							PFInstallation *currentInstallation = [PFInstallation currentInstallation];
							[currentInstallation setObject:udid forKey:@"imei"];
							currentInstallation.channels = @[ @"global" ];
							[currentInstallation saveInBackground];
							
							[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce_BoccaccioClub"];
							[[NSUserDefaults standardUserDefaults] synchronize];
						});
					} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
					}];
				}
				dispatch_async(dispatch_get_main_queue(), ^{ // 2
				});
			});
        }
        @catch (NSException *exception) {
        }
        @finally {
        }

	}
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
		NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
		if ( !(networkStatus == NotReachable) ) {
			AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
			manager.responseSerializer = [AFHTTPResponseSerializer serializer];
			NSString * udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
			NSDictionary *params = @{
									 @"data_type": @"OPEN",
									 @"view": @"app",
									 @"id_event": @"",
									 @"photo_name": @"",
									 @"device": udid
									 };
			[manager POST:[NSString stringWithFormat:@"%@HttpApp.php?token_access=B5522CLUB5522CLUB&request_info=SET_DATA", BASE_URL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
			} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			}];
		}
	});

    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	// Store the deviceToken in the current installation and save it to Parse.
	PFInstallation *currentInstallation = [PFInstallation currentInstallation];
	[currentInstallation setDeviceTokenFromData:deviceToken];
	[currentInstallation addUniqueObject:@"global" forKey:@"channels"];
	[currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	[PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
		NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
		if ( !(networkStatus == NotReachable) ) {
			AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
			manager.responseSerializer = [AFHTTPResponseSerializer serializer];
			NSString * udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
			NSDictionary *params = @{
									 @"data_type": @"CLOSE",
									 @"view": @"app",
									 @"id_event": @"",
									 @"photo_name": @"",
									 @"device": udid
									 };
			[manager POST:[NSString stringWithFormat:@"%@HttpApp.php?token_access=B5522CLUB5522CLUB&request_info=SET_DATA", BASE_URL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
			} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			}];
		}
	});
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
		NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
		if ( !(networkStatus == NotReachable) ) {
			AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
			manager.responseSerializer = [AFHTTPResponseSerializer serializer];
			NSString * udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
			NSDictionary *params = @{
									 @"data_type": @"CLOSE",
									 @"view": @"app",
									 @"id_event": @"",
									 @"photo_name": @"",
									 @"device": udid
									 };
			[manager POST:[NSString stringWithFormat:@"%@HttpApp.php?token_access=B5522CLUB5522CLUB&request_info=SET_DATA", BASE_URL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
			} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			}];
		}
	});
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
	
	if ([[url scheme] isEqualToString:@"iosboccaccioapp"]) {
		if ([[url query] isEqualToString:@"boccaccioIosAppVerified"]) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://boccaccio.dynamo.ovh/ios_authenticate.php?device_type=iOS&authentication_type=normal"]];
		}
	}
 
	return YES;
}

@end
