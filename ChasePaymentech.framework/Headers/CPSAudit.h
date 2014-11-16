//
//  CPSAudit.h
//  ChasePaymentech
//
//  Created by Anil on 01/08/14.
//  Copyright (c) 2014 ChasePaymentech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@interface CPSAudit : NSObject<NSCopying>

/**
   Set Vendor Id.(Optional)
   Maximum and Minimum length is 4.
 */
@property (nonatomic, copy)     NSString *vendorID;

/**
   Set Software Id.(Optional)
   Maximum and Minimum length is 4.
 */
@property (nonatomic, copy)     NSString *softwareID;

/**
   Set Mobiledevice Type.(Optional)
   Maximum and Minimum length is 2.
 */
@property (nonatomic, assign)   NSUInteger mobileDeviceType;


/**
   User location (Optional)
 */
@property (nonatomic, copy)     CLLocation *location;

- (NSArray *)validate;

@end
