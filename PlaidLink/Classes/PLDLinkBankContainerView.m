//
//  PLDLinkBankContainerView.m
//  Plaid
//
//  Created by Simon Levy on 10/20/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLinkBankContainerView.h"

#import "PLDLinkBankTileView.h"
#import "PLDLinkBankMFAExplainerView.h"

#import "PLDInstitution.h"

static CGFloat const kContentPadding = 8.0;

@implementation PLDLinkBankContainerView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _bankTileView = [[PLDLinkBankTileView alloc] initWithFrame:CGRectZero];
    // Don't add it as a subview yet.

    _contentContainer = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_contentContainer];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect bounds = self.bounds;
  _bankTileView.frame =
      CGRectMake(kContentPadding, 0, bounds.size.width - kContentPadding * 2, bounds.size.height / 4);
  _contentContainer.frame = CGRectMake(kContentPadding,
                                       CGRectGetMaxY(_bankTileView.frame),
                                       self.bounds.size.width - 2 * kContentPadding,
                                       220);

  UIBezierPath *path =
      [UIBezierPath bezierPathWithRoundedRect:_contentContainer.bounds
                            byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                  cornerRadii:CGSizeMake(8, 8)];
  CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
  maskLayer.frame = _contentContainer.bounds;
  maskLayer.path  = path.CGPath;
  _contentContainer.layer.mask = maskLayer;

}

- (void)setBankTileView:(PLDLinkBankTileView *)bankTileView {
  [bankTileView removeFromSuperview];
  _bankTileView = bankTileView;
  [self insertSubview:_bankTileView aboveSubview:_contentContainer];
  _contentContainer.backgroundColor = _bankTileView.institution.backgroundColor;
}

@end
