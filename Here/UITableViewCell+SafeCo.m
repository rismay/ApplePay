//
//  UITableViewCell+SafeCo.m
//  Here
//
//  Created by Cristian Monterroza on 11/8/14.
//  Copyright (c) 2014 Cristian Monterroza. All rights reserved.
//

#import "UITableViewCell+SafeCo.h"

@implementation UITableViewCell (SafeCo)

- (void)prepareForProduct:(NSDictionary *)properties iconData:(NSData *)iconData path:(NSIndexPath *)path {
    //Image view;
    NSString *imagePath = [NSBundle.mainBundle pathForResource:[properties[@"SKU"] stringValue]
                                                        ofType:@"jpg"];
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    self.imageView.image = [UIImage imageWithData:data];
    
    //Label
    self.textLabel.text = properties[@"PartName"];
    self.textLabel.minimumScaleFactor = 0.5; 
    self.textLabel.numberOfLines = 0;
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    NSNumber *quantity = properties[@"Quantity"];
    NSNumber *price = properties[@"Price"];
    

    //Detail
    NSMutableString *detailText = @"Quantity: ".mutableCopy;
    [detailText appendString:quantity.stringValue];
    [detailText appendString:@" , Total Price: $"];

    NSNumber *totalPrice = @(quantity.floatValue * price.floatValue);
    [detailText appendString:totalPrice.stringValue];
    self.detailTextLabel.text = detailText;
    //Stepper
    UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    stepper.tag = path.row;
    stepper.value = quantity.integerValue;
    self.accessoryView = stepper;
}

+ (CGFloat)getCellHeightForJob:(NSDictionary *)properties view:(UIView *)tableView {
    CGFloat labelWidth = CGRectGetWidth(tableView.frame) - 55;
    CGFloat titleHeight = [UITableViewCell getTitleHeight:properties[@"title"] forWidth:labelWidth];
    CGFloat infoHeight = [UITableViewCell getInfoHeight:properties forWidth:labelWidth];
    CGFloat final = ceil(titleHeight + infoHeight);
    return final;
}

+ (CGFloat)getTitleHeight:(NSString *)title forWidth:(CGFloat)labelWidth {
    NSMutableParagraphStyle *paragrapthStyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    paragrapthStyle.alignment = NSTextAlignmentRight;
    UIFont *perferredFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    NSAttributedString *questionText = [[NSAttributedString alloc] initWithString:title
                                                                       attributes:@{NSParagraphStyleAttributeName:paragrapthStyle,
                                                                                    NSFontAttributeName:perferredFont}];
    CGSize labelConstraint = CGSizeMake(labelWidth, CGFLOAT_MAX);
    return CGRectGetHeight([questionText boundingRectWithSize:labelConstraint
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                      context:nil]) + perferredFont.pointSize;
}

+ (CGFloat)getInfoHeight:(CBLDocument *)document forWidth:(CGFloat)labelWidth {
    NSMutableString *text = @"".mutableCopy;
    NSInteger score = [document[@"score"] integerValue];
    [text appendString:[NSString stringWithFormat:@"%li %@",
                        (long)score, (score != 1) ? @"points":@"point"]];
    [text appendString:[NSString stringWithFormat:@" by %@ ", document[@"by"]]];
    [text appendString:@" ago | "];
    NSInteger comments = [document[@"kids"] count];
    [text appendString:[NSString stringWithFormat:@"%li %@",
                        (long)comments, (comments != 1) ? @"comments": @"comment"]];
    CGSize labelConstraint = CGSizeMake(labelWidth, CGFLOAT_MAX);
    NSMutableParagraphStyle *paragrapthStyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    paragrapthStyle.alignment = NSTextAlignmentRight;
    UIFont *perferredFont = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    NSAttributedString *detailText = [[NSAttributedString alloc] initWithString:text
                                                                     attributes:@{NSParagraphStyleAttributeName:paragrapthStyle,
                                                                                  NSFontAttributeName:perferredFont}];
    return CGRectGetHeight([detailText boundingRectWithSize:labelConstraint
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                    context:nil]) * 2.5;
}

@end
