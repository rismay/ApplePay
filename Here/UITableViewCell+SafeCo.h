//
//  UITableViewCell+SafeCo.h
//  Here
//
//  Created by Cristian Monterroza on 11/8/14.
//  Copyright (c) 2014 Cristian Monterroza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (SafeCo)

- (void)prepareForProduct:(NSDictionary *)properties iconData:(NSData *)iconData path:(NSIndexPath *)path;

+ (CGFloat)getCellHeightForJob:(NSDictionary *)properties view:(UIView *)tableView;

@end
