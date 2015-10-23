//
//  PLDLinkStyledButton.m
//  PlaidLink
//
//  Created by Andres Ugarte on 10/23/15.
//  Copyright © 2015 Simon Levy. All rights reserved.
//

#import "PLDLinkStyledButton.h"

#import "UIColor+PLDLinkUIColor.h"

@implementation PLDLinkStyledButton {
  UIActivityIndicatorView *_spinner;
  NSString *_loadingText;
  NSString *_originalText;
  BOOL _loading;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _loading = NO;
    _spinner = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _spinner.hidesWhenStopped = YES;
    [self addSubview:_spinner];

    _loadingText = @"Sending";
  }
  return self;
}

- (void)startLoading {
  self.enabled = NO;
  _loading = YES;
  _originalText = self.titleLabel.text;
  [self setTitle:_loadingText forState:UIControlStateNormal];
  [_spinner startAnimating];
  self.backgroundColor = [self.tintColor darkerColorForBackground];
}

- (void)stopLoading {
  self.enabled = YES;
  _loading = NO;
  [self setTitle:_originalText forState:UIControlStateNormal];
  [_spinner stopAnimating];
  self.backgroundColor = [self.tintColor lighterColorForBackground];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _spinner.center = CGPointMake(CGRectGetMaxX(self.bounds) - CGRectGetWidth(_spinner.bounds) - 4,
                                CGRectGetMidY(self.bounds));
}

-(void) setHighlighted:(BOOL)highlighted {
  if (highlighted || _loading) {
    self.backgroundColor = [self.tintColor darkerColorForBackground];
  } else {
    self.backgroundColor = [self.tintColor lighterColorForBackground];
  }
  [super setHighlighted:highlighted];
}

@end
