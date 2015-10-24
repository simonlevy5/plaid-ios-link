//
//  PLDLinkStyledTextField.m
//  PlaidLink
//
//  Created by Andres Ugarte on 10/23/15.
//  Copyright © 2015 Simon Levy. All rights reserved.
//

#import "PLDLinkStyledTextField.h"

#import "UIColor+PLDLinkUIColor.h"

@implementation PLDLinkStyledTextField {
  UIColor *_containerColor;
}

- (instancetype)initWithFrame:(CGRect)frame
                    tintColor:(UIColor *)tintColor
                  placeholder:(NSString *)placeholder {
  if (self = [super initWithFrame:frame]) {
    _containerColor = tintColor;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textColor = [UIColor whiteColor];
    self.tintColor = [UIColor whiteColor];
    self.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:placeholder
        attributes:@{NSForegroundColorAttributeName:[tintColor lighterColorForText]}];
  }
  return self;
}

- (void)setPlaceholder:(NSString *)placeholder {
  self.attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:placeholder
      attributes:@{NSForegroundColorAttributeName:[_containerColor lighterColorForText]}];
}

@end
