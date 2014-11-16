//
//  ViewController.m
//  Here
//
//  Created by Cristian Monterroza on 11/3/14.
//  Copyright (c) 2014 Cristian Monterroza. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "UITableViewCell+SafeCo.h"
#import <ChasePaymentech/ChasePaymentech.h>
#import <PassKit/PassKit.h>

@interface ViewController () <iCarouselDelegate, iCarouselDataSource, UITableViewDelegate, UITableViewDataSource, PKPaymentAuthorizationViewControllerDelegate>

@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (nonatomic, strong) IBOutlet UITableView *tableview;
- (IBAction)payAction:(UIBarButtonItem *)sender;

@property (nonatomic, strong) NSMutableDictionary *rowHeightDictionary;
@property (nonatomic, strong) NSMutableArray *currentShoppingCart;
@property PKPaymentAuthorizationViewController *vc;
@property Boolean didAuthorize;

@end

@implementation ViewController

#pragma mark - Properties

- (IBAction)payAction:(UIBarButtonItem *)sender {
	NSLog(@"authorizeClicked");
	PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
	/*
	 request.merchantIdentifier = @"merchant.ryanyoder.com";
	 request.countryCode = @"US";
	 request.supportedNetworks = @[@"MasterCard", @"Visa", @"AmEx"];
	 request.merchantCapabilities = PKMerchantCapability3DS;
	 request.currencyCode = @"USD";
	 NSDecimalNumber *total = [NSDecimalNumber decimalNumberWithString:self.amountFIeld.text];
	 PKPaymentSummaryItem *totalItem = [PKPaymentSummaryItem summaryItemWithLabel:@"Total" amount:total];
	 request.paymentSummaryItems = @[totalItem];
	 */
	
	request.merchantIdentifier = @"merchant.com.electricchasetest";
	
	//request.merchantIdentifier = @"merchant.chaseSDK.com.testMID";
	
	request.countryCode = @"US";
	request.currencyCode = @"USD";
	request.merchantCapabilities = PKMerchantCapability3DS;
	request.supportedNetworks = @[ PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa ];
	request.paymentSummaryItems = @[ [PKPaymentSummaryItem summaryItemWithLabel:@"Electrical Chase Test" amount:[NSDecimalNumber decimalNumberWithString:@"1.00"]] ];
	
	
	self.vc = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:request];
	self.vc.delegate = self;
	[self presentViewController:self.vc animated:YES completion:nil];
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller

					   didAuthorizePayment:(PKPayment *)payment

								completion:(void (^)(PKPaymentAuthorizationStatus status))completion

{
	
	
 NSLog(@"didAuthorizePaymentCalled");
	
	
	
	self.didAuthorize = YES;
	
	CPSAuthorizationRequest *req = [[CPSAuthorizationRequest alloc] initWithPaymentData:payment.token.paymentData];
	
	req.orderId = @"0u811";
	
	CPSGateway *gateway = [[CPSGateway alloc] init];
	
	gateway.test = YES;
	
	
	//Return from this call confirms payment.
	[gateway authorizePaymentWithRequest:req withCompletionHandler:^(CPSAuthorizationResponse *response, NSError *error) {
		
		if(error != nil) {
			
			UIAlertView *alert = [[UIAlertView alloc]
								  
								  initWithTitle:@"Unable to process your order"
								  
								  message:error.debugDescription
								  
								  delegate:nil
								  
								  cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			
			[alert show];
			
			completion(PKPaymentAuthorizationStatusFailure);
			
		} else {
			
			
			
			if([response.procStatus isEqualToString:@"0"] && [response.respCode isEqualToString:@"00"])
				
			{
				
				completion(PKPaymentAuthorizationStatusSuccess);
				
				
				
			} else {
				
				completion(PKPaymentAuthorizationStatusFailure);
				
			}
			
		}
		
	}];
	
	
	
	
	
}



- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
	NSLog(@"didFinish called");
	[self dismissViewControllerAnimated:YES completion:NULL];
	/*
	 if (!self.didAuthorize)
	 {
	 [self.navigationController popViewControllerAnimated:YES];
	 }
	 */
}


- (NSMutableDictionary *)rowHeightDictionary {
    return WSM_LAZY(_rowHeightDictionary, @{}.mutableCopy);
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    self.carousel.type = iCarouselTypeLinear;
    self.carousel.backgroundColor = [UIColor blackColor];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [WSMColorPalette colorGradient:kWSMGradientWhite forIndex:6 ofCount:6 reversed:NO];
    
    self.currentShoppingCart = [self.jobData[0][@"products"] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Carousel Helper Methods

- (NSDictionary *)jobDictionaryForIndex:(NSInteger)index {
    NSLog(@"%@", self.jobData[index]);
    return self.jobData[index];
}

- (NSArray *)jobData {
    return AppDelegate.jobData;
}

- (NSMutableDictionary *)productForRow:(NSInteger)row {
    return self.currentShoppingCart[row];
}

#pragma mark - Carousel Delegate Methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.jobData.count;
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    return (option == iCarouselOptionSpacing) ? value * 1.1 : value;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    UILabel *label;
        NSDictionary *job = [self jobDictionaryForIndex:index];
    
    WSM_LAZY(view, ({
        NSString *imagePath = [NSBundle.mainBundle pathForResource:job[@"JobType"]
                                                            ofType:@"jpg"];
            NSData *data = [NSData dataWithContentsOfFile:imagePath];
        view = [[UIImageView alloc] initWithImage:[UIImage imageWithData:data]];
        view.frame = self.carousel.bounds;
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
        view;
    }));
    
    //create new view if no view is available for recycling
    //get a reference to the label in the recycled view
    label = (UILabel *)[view viewWithTag:1];
    
    //set item label
    //remember to always set any properties of your carousel item views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing in the wrong place in the carousel
    
    label.text = job[@"JobType"];
    return view;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    self.currentShoppingCart = [self.jobData[carousel.currentItemIndex][@"products"] mutableCopy];
    NSLog(@"%@", self.currentShoppingCart);
    [self.tableview reloadData];
}

#pragma mark - TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentShoppingCart.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#define cellIdentifier @"tableViewCell"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:cellIdentifier];
    WSM_LAZY(cell, [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:cellIdentifier]);
    NSDictionary *product = [self productForRow:indexPath.row];
    //    NSDictionary *product = @{@"partName":@"1/3 Screw"};
    
    [cell prepareForProduct:product iconData:nil path:indexPath];
    [cell viewWithTag:1];
    
    UIStepper *stepper = (UIStepper *)cell.accessoryView;
    NSLog(@"Stepper: %@", stepper);
    [stepper addTarget:self action:@selector(respondToStepper:) forControlEvents:UIControlEventAllEvents];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //    cell.backgroundColor = [WSMColorPalette colorGradient:kWSMGradientWhite forIndex:indexPath.row
    //                                                  ofCount:self.currentShoppingCart.count reversed:NO];
}

- (void)respondToStepper:(UIStepper *)stepper  {
    NSLog(@"Action");
    NSMutableDictionary *prodcuct = [self productForRow:stepper.tag].mutableCopy;
    NSLog(@"Product: %@", prodcuct);
    if (stepper.value <= 0) {
        prodcuct[@"quantity"] = @(stepper.value);
    } if (stepper.value > 0) {
        stepper.value = 0;
    }
    self.currentShoppingCart[stepper.tag] = prodcuct;
}

@end
