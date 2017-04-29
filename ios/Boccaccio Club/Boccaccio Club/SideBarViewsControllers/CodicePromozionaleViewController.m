//
//  CodicePromozionaleViewController.m
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 07/10/15.
//  Copyright © 2015 Rambod Rahmani. All rights reserved.
//

#import "CodicePromozionaleViewController.h"

@interface CodicePromozionaleViewController ()

@end

@implementation CodicePromozionaleViewController

#define BASE_URL @"http://www.boccaccio.it/app/1.5/"

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	_btnPrenota.layer.borderWidth = 1;
	_btnPrenota.layer.borderColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
	_btnPrenota.layer.cornerRadius = 10;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	_mainView.clipsToBounds = YES;
	_mainView.layer.cornerRadius = 5;
	_mainView.layer.borderWidth = 1.0;
	_mainView.layer.borderColor = [[UIColor colorWithRed:(0.0/255.0) green:(110.0/255.0) blue:(253.0/255.0) alpha:1] CGColor];
	
	_bgView.backgroundColor = [UIColor blackColor];
	_bgView.alpha = 0.0;
	
	if ( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ) {
		_mainView_top.constant = 280.0;
		[_mainView needsUpdateConstraints];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[UIView animateWithDuration:0.8 animations:^(void) {
		_bgView.alpha = 0.7;
	}];
	
	UITapGestureRecognizer *singleFingerTap =
	[[UITapGestureRecognizer alloc] initWithTarget:self
											action:@selector(handleSingleTap:)];
	[_bgView addGestureRecognizer:singleFingerTap];
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
	CGPoint location = [recognizer locationInView:[recognizer.view superview]];
	
	[UIView animateWithDuration:0.8 animations:^(void) {
		_bgView.alpha = 0.0;
	} completion:^(BOOL finished) {
		[self dismissViewControllerAnimated:YES completion:nil];
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (IBAction)utilizzaCodice:(id)sender {
	
	if ([_txtFieldCodice.text length] > 3) {
		Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
		NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
		if (networkStatus == NotReachable) {
			[[[UIAlertView alloc] initWithTitle:@"Connessione Internet Assente"
										message:@"Connettiti ad internet per poter utilizzare l'App del Boccaccio Club."
									   delegate:self
							  cancelButtonTitle:@"OK!"
							  otherButtonTitles:nil] show];
		} else {
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
				NSString * udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
				
				AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
				manager.responseSerializer = [AFHTTPResponseSerializer serializer];
				
				NSDictionary *params = @{
										 @"device": udid,
										 @"code": [_txtFieldCodice text]
										 };
				
				[manager POST:[NSString stringWithFormat:@"%@HttpApp.php?token_access=B5522CLUB5522CLUB&request_info=GET_PROMO", BASE_URL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
					dispatch_async(dispatch_get_main_queue(), ^{
						NSError * error;
						NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&error];
						NSArray *results = [jsonArray objectForKey:@"result"];
						
						NSString * codice = [results valueForKey:@"codice"];
						NSString * scadenza = [results valueForKey:@"scadenza"];
						NSString * tipo = [results valueForKey:@"tipo"];
						NSString * validita = [results valueForKey:@"validita"];
						
						if ([results count] > 0) {
							AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
							manager.responseSerializer = [AFHTTPResponseSerializer serializer];
							
							[manager POST:[NSString stringWithFormat:@"%@HttpApp.php?token_access=B5522CLUB5522CLUB&request_info=SET_PROMO_CLIENT", BASE_URL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
								dispatch_async(dispatch_get_main_queue(), ^{
									[[[UIAlertView alloc] initWithTitle:@"Codice Promozionale"
																message:[NSString stringWithFormat:@"Il tuo codice promozionale è stato registrato con successo. %@.\nValido il %@ fino al %@ con codice %@.", tipo, validita, scadenza, codice]
															   delegate:self
													  cancelButtonTitle:@"OK!"
													  otherButtonTitles:nil] show];
									[_txtFieldCodice setText:@""];
									[_txtFieldCodice resignFirstResponder];
								});
							} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
								[[[UIAlertView alloc] initWithTitle:@"Errore"
															message:@"Si è verificato un errore durante la registrazione del tuo codice promozionale. Riprova tra un istante."
														   delegate:self
												  cancelButtonTitle:@"OK!"
												  otherButtonTitles:nil] show];
							}];
						}
						else
						{
							[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
							[[[UIAlertView alloc] initWithTitle:@"Codice Errato"
														message:@"Il codice promozione che hai inserito non è valido."
													   delegate:self
											  cancelButtonTitle:@"OK!"
											  otherButtonTitles:nil] show];
						}
					});
				} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
				}];
			});
		}
	}
	else
	{
		[[[UIAlertView alloc] initWithTitle:@"Codice"
									message:@"Inserisci un codice promozionale per poter procedere."
								   delegate:self
						  cancelButtonTitle:@"OK!"
						  otherButtonTitles:nil] show];
	}
}

@end
