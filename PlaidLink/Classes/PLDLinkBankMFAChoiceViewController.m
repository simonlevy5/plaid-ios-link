//
//  PLDLinkBankMFAChoiceViewController.m
//  Plaid
//
//  Created by Simon Levy on 10/20/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLinkBankMFAChoiceViewController.h"

#import "PLDAuthentication.h"
#import "PLDLinkBankContainerView.h"

static CGFloat const kButtonHeight = 50.0;
static CGFloat const kPadding = 20.0;

@protocol PLDLinkBankMFAChoiceViewDelegate <NSObject>

- (void)choiceView:(UIView *)view didSelectChoice:(NSString *)choice;

@end

@interface PLDLinkBankMFAChoiceView : UIView

@property(nonatomic, weak) id<PLDLinkBankMFAChoiceViewDelegate> delegate;
@property(nonatomic) NSArray *choices;

@end

@implementation PLDLinkBankMFAChoiceView {
  NSMutableArray *_choiceButtons;
}

- (void)setChoices:(NSArray *)choices {
  _choices = choices;
  for (UIButton *button in _choiceButtons) {
    [button removeFromSuperview];
    [_choiceButtons removeAllObjects];
  }
  for (PLDMFAAuthenticationChoice *choice in _choices) {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:choice.displayText forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(didTapChoiceButton:)
     forControlEvents:UIControlEventTouchUpInside];
    [_choiceButtons addObject:button];
    [self addSubview:button];
  }
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _choiceButtons = [NSMutableArray array];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGFloat buttonY = kPadding;
  CGFloat buttonWidth = self.bounds.size.width - kPadding * 2;
  for (UIButton *button in _choiceButtons) {
    button.frame = CGRectMake(kPadding, buttonY, buttonWidth, kButtonHeight);
    buttonY += kButtonHeight + kPadding;
  }
}

- (void)didTapChoiceButton:(id)sender {
  NSUInteger index = [_choiceButtons indexOfObject:sender];
  PLDMFAAuthenticationChoice *choice = [_choices objectAtIndex:index];
  [self.delegate choiceView:self didSelectChoice:choice.choice];
}

@end

@interface PLDLinkBankMFAChoiceViewController ()<PLDLinkBankMFAChoiceViewDelegate>
@end

@implementation PLDLinkBankMFAChoiceViewController {
  PLDLinkBankMFAChoiceView *_view;
}

- (void)loadView {
  _view = [[PLDLinkBankMFAChoiceView alloc] initWithFrame:CGRectZero];
  _view.choices = self.authentication.mfa.data;
  _view.delegate = self;
  self.view = _view;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

#pragma mark - PLDLinkBankMFAChoiceViewDelegate

- (void)choiceView:(UIView *)view didSelectChoice:(NSString *)choice {
  NSDictionary *options = @{
    @"send_method" : @{
        @"type" : choice
      }
    };
  [self submitMFAStepResponse:nil options:options completion:^(NSError *error) {
    
  }];
}

@end
