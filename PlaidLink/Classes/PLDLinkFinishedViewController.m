//
//  PLDLinkFinishedViewController.m
//  Plaid
//
//  Created by Simon Levy on 10/19/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLinkFinishedViewController.h"

@interface PLDLinkFinishedView : UIView

@property(nonatomic) UIImageView *successImageView;
@property(nonatomic) UILabel *label;
@property(nonatomic) UIButton *continueButton;

@end

@implementation PLDLinkFinishedView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor whiteColor];
  
    _successImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _successImageView.backgroundColor = [UIColor redColor];
    [self addSubview:_successImageView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.textColor =  [UIColor grayColor];
    _label.text = @"Label Text";
    [_label sizeToFit];
    [self addSubview:_label];
    
    _continueButton = [[UIButton alloc] initWithFrame:CGRectZero];
    _continueButton.backgroundColor = [UIColor grayColor];
    [_continueButton setTitle:@"Continue" forState:UIControlStateNormal];
    [_continueButton sizeToFit];
    [self addSubview:_continueButton];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGRect bounds = self.bounds;
  CGFloat imageWidth = 200;
  _successImageView.frame = CGRectMake(bounds.size.width / 2 - imageWidth / 2, 100, imageWidth, 200);

  CGRect labelFrame = _label.frame;
  labelFrame.origin.x = bounds.size.width / 2 - _label.frame.size.width / 2;
  labelFrame.origin.y = CGRectGetMaxY(_successImageView.frame) + 20;
  _label.frame = labelFrame;

  CGRect buttonFrame = _continueButton.frame;
  buttonFrame.size.width += 10;
  buttonFrame.size.height += 10;
  buttonFrame.origin.x = bounds.size.width / 2 - buttonFrame.size.width / 2;
  buttonFrame.origin.y = CGRectGetMaxY(_label.frame) + 20;
  _continueButton.frame = buttonFrame;
}

@end

@interface PLDLinkFinishedViewController ()
@end

@implementation PLDLinkFinishedViewController {
  PLDLinkFinishedView *_view;
}

- (void)setLinkSuccessName:(NSString *)linkSuccessName {
  _view.label.text = linkSuccessName;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [_view.continueButton addTarget:self
                           action:@selector(didTapContinue)
                 forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadView {
  _view = [[PLDLinkFinishedView alloc] initWithFrame:CGRectZero];
  self.view = _view;
}

#pragma mark - Private

- (void)didTapContinue {
  [_delegate finishedViewControllerDidFinish:self];
}

@end
