//
//  BoccaccioGift.m
//  Boccaccio Club
//
//  Created by Rambod Rahmani on 27/03/15.
//  Copyright (c) 2015 Rambod Rahmani. All rights reserved.
//

#import "BoccaccioGift.h"

@implementation BoccaccioGift

- (id)init
{
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    BoccaccioGift * copy = [[BoccaccioGift allocWithZone:zone] init];
	
	//copy.gift_id = _gift_id;
	
    return copy;
}

#pragma - NSKeyedArchiver
- (void)encodeWithCoder:(NSCoder *)encoder
{
	//[encoder encodeObject:_gift_id forKey:@"gift_id"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
	//_gift_id = [decoder decodeObjectForKey:@"gift_id"];
	
	return self;
}

- (void)showErrorMessage:(NSString *)message {
	NSLog(@"Something went wrong. Please retry. Message: %@", message);
}

@end
