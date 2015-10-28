//
//  PLDLinkBankTileView.m
//  plaid
//
//  Created by Andres Ugarte on 10/21/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLinkBankTileView.h"

#import "PLDInstitution.h"

@implementation PLDLinkBankTileView {
  UIImageView *_logo;
  UIBezierPath *_maskPath;
  CAShapeLayer *_maskLayer;
}

- (void)setInstitution:(PLDInstitution *)institution {
  _institution = institution;
  if (institution.logoImage) {
    [_logo setImage:institution.logoImage];
  } else {
    [_logo setImage:[UIImage imageNamed:_institution.type]];
  }
  [self setNeedsLayout];
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.0f;

    _logo = [[UIImageView alloc] initWithFrame:frame];
    _logo.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_logo];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _logo.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2.5);
  _logo.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)roundCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii {
  _maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                    byRoundingCorners:corners cornerRadii:cornerRadii];
  _maskLayer = [[CAShapeLayer alloc] init];
  _maskLayer.frame = self.bounds;
  _maskLayer.path  = _maskPath.CGPath;
  self.layer.mask = _maskLayer;
  self.layer.cornerRadius = 0;
}

@end
