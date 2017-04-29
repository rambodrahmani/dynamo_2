//
//  SplashScreenViewController.h
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 30/08/14.
//  Copyright (c) 2014 Rambod Rahmani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <MapKit/MapKit.h>
#import "AFNetworking.h"
#import <Parse/Parse.h>

@interface SplashScreenViewController : UIViewController <CLLocationManagerDelegate, UIAlertViewDelegate>
{
	CLLocationManager * locationManager;
	NSString * udid;
}

@end
