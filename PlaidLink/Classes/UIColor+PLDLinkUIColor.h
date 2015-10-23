//
//  PLDLinkUIColor+UIColor.h
//  PlaidLink
//
//  Created by Andres Ugarte on 10/23/15.
//  Copyright © 2015 Simon Levy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (PLDLinkUIColor)

- (UIColor *)lighterColorForBackground;
- (UIColor *)lighterColorForText;

- (UIColor *)darkerColorForBackground;
- (UIColor *)darkerColorForText;

@end
