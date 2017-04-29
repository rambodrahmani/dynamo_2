//
//  AppDelegate.h
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 24/08/14.
//  Copyright (c) 2014 Rambod Rahmani. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "AFNetworking.h"
#import "Reachability.h"
#import <Parse/Parse.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
