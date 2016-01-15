//
//  PLDLinkBankMFABaseStepView.m
//  Pods
//
//  Created by Andres Ugarte on 1/12/16.
//
//

#import "PLDLinkBankMFABaseStepView.h"

#import "PLDLinkStyledButton.h"

static CGFloat const kInputVerticalPadding = 12.0;
static CGFloat const kInputHorizontalPadding = 24.0;
static CGFloat const kButtonHeight = 46.0;

@implementation PLDLinkBankMFABaseStepView

- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor {
  if (self = [super initWithFrame:frame]) {
    _errorContainer = [[UIView alloc] initWithFrame:frame];
    _errorContainer.backgroundColor = tintColor;
    _errorContainer.alpha = 0;
    [self addSubview:_errorContainer];

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.numberOfLines = 1;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.minimumScaleFactor = 0.6;
    [_errorContainer addSubview:_titleLabel];

    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _descriptionLabel.numberOfLines = 3;
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    _descriptionLabel.textColor = [UIColor whiteColor];
    _descriptionLabel.font = [UIFont systemFontOfSize:12];
    _descriptionLabel.adjustsFontSizeToFitWidth = YES;
    _descriptionLabel.minimumScaleFactor = 0.6;
    [_errorContainer addSubview:_descriptionLabel];

    _closeButton = [[PLDLinkStyledButton alloc] initWithFrame:CGRectZero tintColor:tintColor];
    [_errorContainer addSubview:_closeButton];

    [_closeButton addTarget:self
                     action:@selector(didTapOnCloseError)
           forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

- (void)showErrorWithTitle:(NSString *)title
               description:(NSString *)description
                buttonCopy:(NSString *)buttonCopy {
  _titleLabel.text = title;
  _descriptionLabel.text = description;
  [self bringSubviewToFront:_errorContainer];

  _titleLabel.transform = CGAffineTransformMakeTranslation(0, 20);
  _descriptionLabel.transform = CGAffineTransformMakeTranslation(0, 20);
  [UIView animateWithDuration:0.3
                        delay:0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     _errorContainer.alpha = 1;
                     _titleLabel.transform = CGAffineTransformIdentity;
                     _descriptionLabel.transform = CGAffineTransformIdentity;
                   } completion:nil];

  [_closeButton setTitle:buttonCopy forState:UIControlStateNormal];
}

- (void)didTapOnCloseError {
  [UIView animateWithDuration:0.3
                        delay:0
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     _errorContainer.alpha = 0;
                     _titleLabel.center =
                         CGPointMake(_titleLabel.center.x, _titleLabel.center.y + 20);
                     _descriptionLabel.center =
                         CGPointMake(_descriptionLabel.center.x, _descriptionLabel.center.y + 20);
                   } completion:^(BOOL finished) {
                     [self layoutSubviews];
                   }];
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect bounds = self.bounds;
  _errorContainer.frame = bounds;

  _titleLabel.frame = CGRectMake(kInputHorizontalPadding,
                                 kInputVerticalPadding + 6,
                                 bounds.size.width - kInputHorizontalPadding * 2,
                                 0);
  [_titleLabel sizeToFit];
  _titleLabel.center = CGPointMake(bounds.size.width / 2, _titleLabel.center.y);

  _descriptionLabel.frame = CGRectMake(kInputHorizontalPadding,
                                       CGRectGetMaxY(_titleLabel.frame) + kInputVerticalPadding,
                                       bounds.size.width - kInputHorizontalPadding * 2,
                                       0);
  [_descriptionLabel sizeToFit];
  _descriptionLabel.center = CGPointMake(bounds.size.width / 2, _descriptionLabel.center.y);
  _closeButton.frame = CGRectMake(kInputHorizontalPadding,
                                  bounds.size.height - kButtonHeight - 2 * kInputVerticalPadding,
                                  bounds.size.width - kInputHorizontalPadding * 2,
                                  kButtonHeight);
}

@end
