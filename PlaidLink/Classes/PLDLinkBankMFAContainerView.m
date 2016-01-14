//
//  PLDLinkBankContainerView.m
//  PlaidLink
//
//  Created by Simon Levy on 10/20/15.
//

#import "PLDLinkBankMFAContainerView.h"

#import "PLDInstitution.h"

#import "PLDLinkBankTileView.h"
#import "PLDLinkBankMFAExplainerView.h"
#import "NSString+Localization.h"

static CGFloat const kContentPadding = 8.0;
static CGFloat const kDefaultContentHeight = 200;

@implementation PLDLinkBankMFAContainerView {
  UIView *_currentContent;
  CAShapeLayer * _maskBehindTile;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.clipsToBounds = NO;
    self.alwaysBounceVertical = YES;
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    _bankTileView = [[PLDLinkBankTileView alloc] initWithFrame:CGRectZero];
    // Don't add it as a subview yet.

    _contentContainer = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_contentContainer];

    NSString *forgotPasswordTitle = [NSString stringWithIdentifier:@"forgot_password"];
    _forgotPasswordLink = [[UIButton alloc] initWithFrame:CGRectZero];
    [_forgotPasswordLink setTitle:forgotPasswordTitle
                         forState:UIControlStateNormal];
    [_forgotPasswordLink setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_forgotPasswordLink setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [_forgotPasswordLink.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_forgotPasswordLink setAlpha:0];
    [self addSubview:_forgotPasswordLink];
    [_forgotPasswordLink addTarget:self
                            action:@selector(didTapForgotPassword:)
                  forControlEvents:UIControlEventTouchUpInside];

    _maskBehindTile = [[CAShapeLayer alloc] init];
  }
  return self;
}

- (void)setBankTileView:(PLDLinkBankTileView *)bankTileView {
  [bankTileView removeFromSuperview];
  _bankTileView = bankTileView;
  [self insertSubview:_bankTileView aboveSubview:_contentContainer];
  _contentContainer.backgroundColor = _bankTileView.institution.backgroundColor;
}

- (void)setShowContentContainer:(BOOL)showContentContainer {
  _showContentContainer = showContentContainer;
  [self setNeedsLayout];
}

- (void)setShowForgotPasswordLink:(BOOL)showForgotPasswordLink {
  _showForgotPasswordLink = showForgotPasswordLink;
  [self setNeedsLayout];
}

- (void)setCurrentContentView:(UIView *)contentView {
  if (_currentContent) {
    [self animateCurrentContentOutWithCompletion:^(BOOL finished) {
      [_currentContent removeFromSuperview];
      _currentContent = contentView;
      [_contentContainer addSubview:_currentContent];
      [self setNeedsLayout];
      [self layoutIfNeeded];
      [self animateCurrentContentIn:^(BOOL finished) {
        [_currentContent becomeFirstResponder];
      }];
    }];
  } else {
    [_currentContent removeFromSuperview];
    _currentContent = contentView;
    [_contentContainer addSubview:_currentContent];
    [self setNeedsLayout];
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect bounds = self.bounds;

  _bankTileView.frame =
      CGRectMake(kContentPadding, 0, bounds.size.width - kContentPadding * 2, bounds.size.height / 4.5);
  _contentContainer.frame = CGRectMake(kContentPadding,
                                       CGRectGetMaxY(_bankTileView.frame),
                                       self.bounds.size.width - 2 * kContentPadding,
                                       kDefaultContentHeight);

  // The initial state of this view has the bottom half of the card hidden behind the tile with the
  // bank logo.
  if (!_showContentContainer) {
    _contentContainer.frame =
        CGRectOffset(_contentContainer.frame, 0,
                     -CGRectGetHeight(_contentContainer.bounds));
  }

  if (_currentContent) {
    _currentContent.frame = _contentContainer.bounds;
    [_currentContent sizeToFit];
    CGRect containerFrame = _contentContainer.frame;
    containerFrame.size.height = _currentContent.bounds.size.height;
    _contentContainer.frame = containerFrame;

    _forgotPasswordLink.frame = CGRectMake(0,
                                           CGRectGetMaxY(_contentContainer.frame) + 4,
                                           _contentContainer.bounds.size.width,
                                           30);
    _forgotPasswordLink.alpha = _showForgotPasswordLink;
  }

  [_bankTileView roundCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                  cornerRadii:CGSizeMake(8, 8)];

  UIBezierPath *path =
      [UIBezierPath bezierPathWithRoundedRect:_contentContainer.bounds
                            byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                  cornerRadii:CGSizeMake(8, 8)];
  CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
  maskLayer.frame = _contentContainer.bounds;
  maskLayer.path  = path.CGPath;
  _contentContainer.layer.mask = maskLayer;

  _maskBehindTile.frame = self.frame;
  _maskBehindTile.path =
      [UIBezierPath bezierPathWithRoundedRect:CGRectMake(kContentPadding,
                                                         0,
                                                         self.bounds.size.width - 2 * kContentPadding,
                                                         self.bounds.size.height)
                                 cornerRadius:8.0].CGPath;
  self.layer.mask = _maskBehindTile;
  CGFloat contentHeight = CGRectGetMaxY(_contentContainer.frame) + 32 * _showForgotPasswordLink;
  self.contentSize = CGSizeMake(bounds.size.width, contentHeight);
}

- (void)didTapForgotPassword:(id)sender {
  if (_bankTileView.institution.forgottenPasswordURL != nil) {
    [[UIApplication sharedApplication] openURL:_bankTileView.institution.forgottenPasswordURL];
  }
}

- (void)animateCurrentContentOutWithCompletion:(void (^ __nullable)(BOOL finished))completion {
  CGAffineTransform transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(self.bounds), 0);
  [UIView animateWithDuration:0.25
                        delay:0
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     _currentContent.alpha = 0;
                     _currentContent.transform = transform;
                   } completion:^(BOOL finished) {
                     self.showForgotPasswordLink = NO;
                     completion(finished);
                   }];
}

- (void)animateCurrentContentIn:(void (^ __nullable)(BOOL finished))completion {
  _currentContent.alpha = 0;
  _currentContent.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.bounds), 0);
  [UIView animateWithDuration:0.25
                        delay:0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     _currentContent.alpha = 1;
                     _currentContent.transform = CGAffineTransformIdentity;
                     [self layoutSubviews];
                   } completion:completion];
}

- (void)animateForgotPasswordButtonIn {
  [UIView animateWithDuration:0.5
                        delay:0.3
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     self.showForgotPasswordLink = YES;
                     [self layoutSubviews];
                   } completion:nil];
}

@end
