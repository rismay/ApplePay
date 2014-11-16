//
//  CPSOrderItem.h
//  ChasePaymentech
//
//  Created by Yoder, Ryan on 6/23/14.
//  Copyright (c) 2014 Chase Paymentech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPSOrderItem : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger quantity;
@property (nonatomic, assign) NSUInteger price;
@property (nonatomic, assign) NSUInteger totalAmount;
@property (nonatomic, assign) NSUInteger discount;
@property (nonatomic, copy) NSString *taxIndicator;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *catalogId;

@end
