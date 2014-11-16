//
//  CPSGateway.h
//  ChasePaymentech
//
//  Created by Yoder, Ryan & Jefferies, Philip.
//  Copyright (c) 2014 Chase Paymentech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPSGateway.h"
#import "CPSAuthorizationResponse.h"
#import "CPSAuthorizationRequest.h"
#import "CPSDecryptionRequest.h"


typedef void (^CPSAuthorizationCompletionHandler)(CPSAuthorizationResponse *, NSError *);


/**
 * The CPSGateway provides access to the Chase Paymentech Gateway for in-app payment processing for registered merchants.
 */
@interface CPSGateway : NSObject

/**
   Set this flag to enable testing against the Paymentech test servers.
 */
@property (nonatomic, assign, getter = isTest) BOOL test;

#ifdef DEBUG
@property (nonatomic, assign, getter = isDevelopment) BOOL development;
#endif

/**
   Authorizes a payment given a PKPaymentToken and order id.  Calls back on the completionHandler with the results of the authorization
   @param request the request containing payment bundle data and other flags
   @param completionHandler the callback that passes back a CPSAuthorizationResponse
   @throws CPSGatewayUsage exception if client failed to initialize CPSGateway correctly by calling [CPSGateway access:]. Note that user errors will never trigger an exception. All user errors are reported through the NSError pointer.
 */
- (void)authorizePaymentWithRequest:(CPSAuthorizationRequest *)request withCompletionHandler:(CPSAuthorizationCompletionHandler)completionHandler;

/**
   Creates a formatted payment request which may be passed to ChasePaymentech's Gateway.
   @param request the request containing payment bundle data and other flags
   @param error a pointer to a pointer containing an error object that's owned by the caller. If the return value is false, error will contain an NSError object. Otherwise, it will be nil.
   @return NSData object containing the encoded, formatted payment data. If there was an error, false is returned
   @throws CPSGatewayUsage exception if client failed to initialize CPSGateway correctly by calling [CPSGateway access:]. Note that user errors will never trigger an exception. All user errors are reported through the NSError pointer.
 */
- (NSData *)formatPaymentWithRequest:(CPSAuthorizationRequest *)request error:(NSError * __autoreleasing *)error;

/**
   Returns an object containing a base64 encoded String used in merchant to Paymentech server decryption requests
   @param request the request containing payment bundle data and other flags
   @param error a pointer to a pointer containing an error object that's owned by the caller. If the return value is false, error will contain an NSError object. Otherwise, it will be nil.
   @return CPSDecryptionRequest, or nil if the operation failed.
   @throws CPSGatewayUsage exception if client failed to initialize CPSGateway correctly by calling [CPSGateway access:]. Note that user errors will never trigger an exception. All user errors are reported through the NSError pointer.
 */
- (CPSDecryptionRequest *)formatDecryptionRequestWithRequest:(CPSAuthorizationRequest *)request error:(NSError * __autoreleasing *)error;

@end
