//
//  BoccaccioEvent.m
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 02/03/15.
//  Copyright (c) 2015 Rambod Rahmani. All rights reserved.
//

#import "BoccaccioEvent.h"

@implementation BoccaccioEvent

- (id)init
{
	_event_id = [NSString stringWithFormat:@""];
	_event_titolo = [NSString stringWithFormat:@""];
	_event_sala = [NSString stringWithFormat:@""];
	_event_lista_internet = [NSString stringWithFormat:@""];
	_event_promo_1_txt_1 = [NSString stringWithFormat:@""];
	_event_promo_1_txt_2 = [NSString stringWithFormat:@""];
	_event_promo_1_txt_3 = [NSString stringWithFormat:@""];
	_event_promo_2_txt_1 = [NSString stringWithFormat:@""];
	_event_promo_2_txt_2 = [NSString stringWithFormat:@""];
	_event_promo_2_txt_3 = [NSString stringWithFormat:@""];
	_event_descrizione = [NSString stringWithFormat:@""];
	_event_data = [NSString stringWithFormat:@""];
	_event_day_name = [NSString stringWithFormat:@""];
	_event_day_number = [NSString stringWithFormat:@""];
	_event_month = [NSString stringWithFormat:@""];
	_event_year = [NSString stringWithFormat:@""];
	_event_date_italy = [NSString stringWithFormat:@""];
	_event_link_image = [NSString stringWithFormat:@""];
	_page_source = [NSString stringWithFormat:@""];
	return self;
}

- (id)initWith_event_id:(NSString *)event_id event_titolo:(NSString *)event_titolo event_sala:(NSString *)event_sala event_lista_internet:(NSString *)event_lista_internet event_promo_1_txt_1:(NSString *)event_promo_1_txt_1 event_promo_1_txt_2:(NSString *)event_promo_1_txt_2 event_promo_1_txt_3:(NSString *)event_promo_1_txt_3 event_promo_2_txt_1:(NSString *)event_promo_2_txt_1 event_promo_2_txt_2:(NSString *)event_promo_2_txt_2 event_promo_2_txt_3:(NSString *)event_promo_2_txt_3 event_descrizione:(NSString *)event_descrizione event_data:(NSString *)event_data event_day_name:(NSString *)event_day_name event_day_number:(NSString *)event_day_number event_month:(NSString *)event_month event_year:(NSString *)event_year event_date_italy:(NSString *)event_date_italy event_link_image:(NSString *)event_link_image page_source:(NSString *)page_source
{
	_event_id = event_id;
	_event_titolo = event_titolo;
	_event_sala = event_sala;
	_event_lista_internet = event_lista_internet;
	_event_promo_1_txt_1 = event_promo_1_txt_1;
	_event_promo_1_txt_2 = event_promo_1_txt_2;
	_event_promo_1_txt_3 = event_promo_1_txt_3;
	_event_promo_2_txt_1 = event_promo_2_txt_1;
	_event_promo_2_txt_2 = event_promo_2_txt_2;
	_event_promo_2_txt_3 = event_promo_2_txt_3;
	_event_descrizione = event_descrizione;
	_event_data = event_data;
	_event_day_name = event_day_name;
	_event_day_number = event_day_number;
	_event_month = event_month;
	_event_year = event_year;
	_event_date_italy = event_date_italy;
	_event_link_image = event_link_image;
	_page_source = page_source;
	
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    BoccaccioEvent * copy = [[BoccaccioEvent allocWithZone:zone] init];
	
	copy.event_id = _event_id;
	copy.event_titolo = _event_titolo;
	copy.event_sala = _event_sala;
	copy.event_lista_internet = _event_lista_internet;
	copy.event_promo_1_txt_1 = _event_promo_1_txt_1;
	copy.event_promo_1_txt_2 = _event_promo_1_txt_2;
	copy.event_promo_1_txt_3 = _event_promo_1_txt_3;
	copy.event_promo_2_txt_1 = _event_promo_2_txt_1;
	copy.event_promo_2_txt_2 = _event_promo_2_txt_2;
	copy.event_promo_2_txt_3 = _event_promo_2_txt_3;
	copy.event_descrizione = _event_descrizione;
	copy.event_data = _event_data;
	copy.event_day_name = _event_day_name;
	copy.event_day_number = _event_day_number;
	copy.event_month = _event_month;
	copy.event_year = _event_year;
	copy.event_date_italy = _event_date_italy;
	copy.event_link_image = _event_link_image;
	copy.page_source = _page_source;
	
    return copy;
}

#pragma - NSKeyedArchiver
- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:_event_id forKey:@"event_id"];
	[encoder encodeObject:_event_titolo forKey:@"event_titolo"];
	[encoder encodeObject:_event_sala forKey:@"event_sala"];
	[encoder encodeObject:_event_lista_internet forKey:@"event_lista_internet"];
	[encoder encodeObject:_event_promo_1_txt_1 forKey:@"event_promo_1_txt_1"];
	[encoder encodeObject:_event_promo_1_txt_2 forKey:@"event_promo_1_txt_2"];
	[encoder encodeObject:_event_promo_1_txt_3 forKey:@"event_promo_1_txt_3"];
	[encoder encodeObject:_event_promo_2_txt_1 forKey:@"event_promo_2_txt_1"];
	[encoder encodeObject:_event_promo_2_txt_2 forKey:@"event_promo_2_txt_2"];
	[encoder encodeObject:_event_promo_2_txt_3 forKey:@"event_promo_2_txt_3"];
	[encoder encodeObject:_event_descrizione forKey:@"event_descrizione"];
	[encoder encodeObject:_event_data forKey:@"event_data"];
	[encoder encodeObject:_event_day_name forKey:@"event_day_name"];
	[encoder encodeObject:_event_day_number forKey:@"event_day_number"];
	[encoder encodeObject:_event_month forKey:@"event_month"];
	[encoder encodeObject:_event_year forKey:@"event_year"];
	[encoder encodeObject:_event_date_italy forKey:@"event_date_italy"];
	[encoder encodeObject:_event_link_image forKey:@"event_link_image"];
	[encoder encodeObject:_page_source forKey:@"event_page_source"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	_event_id = [decoder decodeObjectForKey:@"event_id"];
	_event_titolo = [decoder decodeObjectForKey:@"event_titolo"];
	_event_sala = [decoder decodeObjectForKey:@"event_sala"];
	_event_lista_internet = [decoder decodeObjectForKey:@"event_lista_internet"];
	_event_promo_1_txt_1 = [decoder decodeObjectForKey:@"event_promo_1_txt_1"];
	_event_promo_1_txt_2 = [decoder decodeObjectForKey:@"event_promo_1_txt_2"];
	_event_promo_1_txt_3 = [decoder decodeObjectForKey:@"event_promo_1_txt_3"];
	_event_promo_2_txt_1 = [decoder decodeObjectForKey:@"event_promo_2_txt_1"];
	_event_promo_2_txt_2 = [decoder decodeObjectForKey:@"event_promo_2_txt_2"];
	_event_promo_2_txt_3 = [decoder decodeObjectForKey:@"event_promo_2_txt_3"];
	_event_descrizione = [decoder decodeObjectForKey:@"event_descrizione"];
	_event_data = [decoder decodeObjectForKey:@"event_data"];
	_event_day_name = [decoder decodeObjectForKey:@"event_day_name"];
	_event_day_number = [decoder decodeObjectForKey:@"event_day_number"];
	_event_month = [decoder decodeObjectForKey:@"event_month"];
	_event_year = [decoder decodeObjectForKey:@"event_year"];
	_event_date_italy = [decoder decodeObjectForKey:@"event_date_italy"];
	_event_link_image = [decoder decodeObjectForKey:@"event_link_image"];
	_page_source = [decoder decodeObjectForKey:@"event_page_source"];
	
	return self;
}

- (void)showErrorMessage:(NSString *)message {
	NSLog(@"Something went wrong. Please retry. Message: %@", message);
}

@end
