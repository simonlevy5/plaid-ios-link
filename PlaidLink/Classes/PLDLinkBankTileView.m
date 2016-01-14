//
//  PLDLinkBankTileView.m
//  PlaidLink
//
//  Created by Andres Ugarte on 10/21/15.
//

#import "PLDLinkBankTileView.h"

#import "PLDInstitution.h"

#import "PLDLinkResourceBundle.h"

@implementation PLDLinkBankTileView {
  UIImageView *_logo;
  UILabel *_fallbackLabel;
  UIBezierPath *_maskPath;
  CAShapeLayer *_maskLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.0f;

    _logo = [[UIImageView alloc] initWithFrame:frame];
    _logo.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_logo];

    _fallbackLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _fallbackLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightLight];
    _fallbackLabel.textAlignment = NSTextAlignmentCenter;
    _fallbackLabel.numberOfLines = 0;
    [self addSubview:_fallbackLabel];
  }
  return self;
}

- (void)setInstitution:(PLDInstitution *)institution {
  _institution = institution;
  _logo.hidden = YES;
  _fallbackLabel.hidden = YES;

  // Longtail institutions have a logoImage.
  if (institution.logoImage) {
    [_logo setImage:institution.logoImage];
    _logo.hidden = NO;
  } else {
    // For the top banks, we have better logos.
    NSBundle *resources = [PLDLinkResourceBundle mainBundle];
    UIImage *logo = [UIImage imageNamed:_institution.type
                               inBundle:resources
          compatibleWithTraitCollection:nil];
    if (logo) {
      [_logo setImage:logo];
      _logo.hidden = NO;
    } else {
      // Fallback to showing the name of the institution.
      _fallbackLabel.text = institution.name;
      _fallbackLabel.hidden = NO;
    }
  }
  [self setNeedsLayout];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _logo.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2.5);
  _logo.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
  _fallbackLabel.frame = CGRectInset(self.bounds, 16, 16);
  _fallbackLabel.center = _logo.center;
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
