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

static CGFloat const kLogoHeight = 160.0;
static CGFloat const kContentPadding = 8.0;
static CGFloat const kExplainerHeight = 50.0;

@implementation PLDLinkBankContainerView {
  PLDLinkBankMFAExplainerView *_explainerView;
}

- (NSString *)explainerText {
  return _explainerView.explainerText;
}

- (void)setExplainerText:(NSString *)explainerText {
  _explainerView.explainerText = explainerText;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor whiteColor];

    _bankTileView = [[PLDLinkBankTileView alloc] initWithFrame:CGRectZero];
    _explainerView = [[PLDLinkBankMFAExplainerView alloc] initWithFrame:CGRectZero];
    [self addSubview:_explainerView];

    _contentContainer = [[UIView alloc] initWithFrame:CGRectZero];
    _contentContainer.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    [self addSubview:_contentContainer];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect bounds = self.bounds;
  _bankTileView.frame =
      CGRectMake(kContentPadding, 0, bounds.size.width - kContentPadding * 2, kLogoHeight);
  _explainerView.frame =
      CGRectMake(0, kLogoHeight - kExplainerHeight, self.bounds.size.width, kExplainerHeight);
  _contentContainer.frame = CGRectMake(kContentPadding,
                                       CGRectGetMaxY(_bankTileView.frame),
                                       self.bounds.size.width - 2 * kContentPadding,
                                       220);
}

- (void)setBankTileView:(PLDLinkBankTileView *)bankTileView {
  [bankTileView removeFromSuperview];
  _bankTileView = bankTileView;
  [self insertSubview:_bankTileView aboveSubview:_contentContainer];
}

@end
