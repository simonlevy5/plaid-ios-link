//
//  PLDLinkStyledButton.m
//  PlaidLink
//
//  Created by Andres Ugarte on 10/23/15.
//

#import "PLDLinkStyledButton.h"

#import "NSString+Localization.h"
#import "UIColor+PLDLinkUIColor.h"

@implementation PLDLinkStyledButton {
  UIActivityIndicatorView *_spinner;
  NSString *_loadingText;
  NSString *_originalText;
  BOOL _loading;
}

- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor {
  if (self = [super initWithFrame:frame]) {
    self.tintColor = tintColor;
    self.backgroundColor = [tintColor lighterColorForBackground];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.layer.cornerRadius = 6.0;

    _loading = NO;
    _spinner = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _spinner.hidesWhenStopped = YES;
    _spinner.alpha = 0.6;
    [self addSubview:_spinner];

    _loadingText = [NSString stringWithIdentifier:@"button_sending"];
  }
  return self;
}

- (void)showLoadingState {
  self.enabled = NO;
  _loading = YES;
  _originalText = self.titleLabel.text;
  [self setTitle:_loadingText forState:UIControlStateNormal];
  [self setTitleColor:[self.tintColor lighterColorForText] forState:UIControlStateNormal];
  [_spinner startAnimating];
  self.backgroundColor = [self.tintColor darkerColorForBackground];
}

- (void)hideLoadingState {
  self.enabled = YES;
  _loading = NO;
  [self setTitle:_originalText forState:UIControlStateNormal];
  [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_spinner stopAnimating];
  self.backgroundColor = [self.tintColor lighterColorForBackground];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _spinner.center = CGPointMake(CGRectGetMaxX(self.bounds) - CGRectGetWidth(_spinner.bounds) - 4,
                                CGRectGetMidY(self.bounds));
}

-(void)setHighlighted:(BOOL)highlighted {
  if (highlighted || _loading) {
    self.backgroundColor = [self.tintColor darkerColorForBackground];
    [self setTitleColor:[self.tintColor lighterColorForText] forState:UIControlStateNormal];
  } else {
    self.backgroundColor = [self.tintColor lighterColorForBackground];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  }
  [super setHighlighted:highlighted];
}

@end
