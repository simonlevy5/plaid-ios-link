//
//  PLDLinkBankMFAQuestionOrCodeView.h
//  PlaidLink
//
//  Created by Andres Ugarte on 10/22/15.
//

#import <UIKit/UIKit.h>

#import "PLDLinkBankMFABaseStepView.h"

@class PLDLinkStyledButton;
@class PLDLinkStyledTextField;
@class PLDLinkBankMFAExplainerView;

@protocol PLDLinkBankMFAQuestionOrCodeViewDelegate <NSObject>

- (void)inputView:(UIView *)view didTapSubmitWithResponse:(NSString *)response;

@end

@interface PLDLinkBankMFAQuestionOrCodeView : PLDLinkBankMFABaseStepView

- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor;

@property(nonatomic, weak) id<PLDLinkBankMFAQuestionOrCodeViewDelegate> delegate;
@property(nonatomic, readonly) PLDLinkBankMFAExplainerView *explainer;
@property(nonatomic, readonly) UILabel *inputLabel;
@property(nonatomic, readonly) UITextField *inputTextField;
@property(nonatomic, readonly) PLDLinkStyledButton *submitButton;

@end
