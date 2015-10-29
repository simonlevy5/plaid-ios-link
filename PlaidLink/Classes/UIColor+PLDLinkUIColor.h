//
//  PLDLinkUIColor+UIColor.h
//  PlaidLink
//
//  Created by Andres Ugarte on 10/23/15.
//

#import <UIKit/UIKit.h>

@interface UIColor (PLDLinkUIColor)

- (UIColor *)lighterColorForBackground;
- (UIColor *)lighterColorForText;
- (UIColor *)lighterColorForLine;

- (UIColor *)darkerColorForBackground;
- (UIColor *)darkerColorForText;

@end
