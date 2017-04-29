//
//  HomeViewController.h
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 24/08/14.
//  Copyright (c) 2014 Rambod Rahmani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "METransitions.h"
#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MyCell.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import <MapKit/MapKit.h>
#import "BoccaccioEvent.h"
#import "EventoViewController.h"
#import "FotoViewController.h"

@interface HomeViewController : UIViewController <ECSlidingViewControllerDelegate, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray * eventiCaricati;
	
	CLLocationManager * locationManager;
	
	BOOL hasOpenedMenuOnce;
}

@property (weak, nonatomic) IBOutlet UICollectionView * myCollectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView * activityIndic;
@property (weak, nonatomic) IBOutlet UIImageView * galleryImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem * refreshBarButton;
@property (weak, nonatomic) IBOutlet UIButton * refreshButton;
@property (weak, nonatomic) IBOutlet UIButton * refreshLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblCaricamento;

@property (nonatomic, strong) METransitions *transitions;

- (IBAction)refreshButton:(id)sender;
- (IBAction)menuButtonTapped:(id)sender;

- (void)loadEvents;

@end
