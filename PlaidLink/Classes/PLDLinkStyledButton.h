//
//  PLDLinkStyledButton.h
//  PlaidLink
//
//  Created by Andres Ugarte on 10/23/15.
//  Copyright © 2015 Simon Levy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLDLinkStyledButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor;

- (void)startLoading;
- (void)stopLoading;

@end
