//
//  BoccaccioEvent.h
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 02/03/15.
//  Copyright (c) 2015 Rambod Rahmani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoccaccioEvent : NSObject <NSCopying>

@property (nonatomic, copy)	NSString * event_id;
@property (nonatomic, copy)	NSString * event_titolo;
@property (nonatomic, copy)	NSString * event_sala;
@property (nonatomic, copy)	NSString * event_lista_internet;
@property (nonatomic, copy)	NSString * event_promo_1_txt_1;
@property (nonatomic, copy)	NSString * event_promo_1_txt_2;
@property (nonatomic, copy)	NSString * event_promo_1_txt_3;
@property (nonatomic, copy)	NSString * event_promo_2_txt_1;
@property (nonatomic, copy)	NSString * event_promo_2_txt_2;
@property (nonatomic, copy)	NSString * event_promo_2_txt_3;
@property (nonatomic, copy)	NSString * event_descrizione;
@property (nonatomic, copy)	NSString * event_data;
@property (nonatomic, copy)	NSString * event_day_name;
@property (nonatomic, copy)	NSString * event_day_number;
@property (nonatomic, copy)	NSString * event_month;
@property (nonatomic, copy)	NSString * event_year;
@property (nonatomic, copy)	NSString * event_date_italy;
@property (nonatomic, copy)	NSString * event_link_image;
@property (nonatomic, copy)	NSString * page_source;

- (id)init;
- (id)initWith_event_id:(NSString *)event_id event_titolo:(NSString *)event_titolo event_sala:(NSString *)event_sala event_lista_internet:(NSString *)event_lista_internet event_promo_1_txt_1:(NSString *)event_promo_1_txt_1 event_promo_1_txt_2:(NSString *)event_promo_1_txt_2 event_promo_1_txt_3:(NSString *)event_promo_1_txt_3 event_promo_2_txt_1:(NSString *)event_promo_2_txt_1 event_promo_2_txt_2:(NSString *)event_promo_2_txt_2 event_promo_2_txt_3:(NSString *)event_promo_2_txt_3 event_descrizione:(NSString *)event_descrizione event_data:(NSString *)event_data event_day_name:(NSString *)event_day_name event_day_number:(NSString *)event_day_number event_month:(NSString *)event_month event_year:(NSString *)event_year event_date_italy:(NSString *)event_date_italy event_link_image:(NSString *)event_link_image page_source:(NSString *)page_source;

@end
