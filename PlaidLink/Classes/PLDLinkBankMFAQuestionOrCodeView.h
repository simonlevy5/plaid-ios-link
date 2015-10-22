//
//  PLDLinkBankMFAQuestionOrCodeView.h
//  PlaidLink
//
//  Created by Andres Ugarte on 10/22/15.
//  Copyright © 2015 Simon Levy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PLDLinkBankMFAQuestionOrCodeViewDelegate <NSObject>

- (void)inputView:(UIView *)view didTapSubmitWithResponse:(NSString *)response;

@end

@interface PLDLinkBankMFAQuestionOrCodeView : UIView

@property(nonatomic, weak) id<PLDLinkBankMFAQuestionOrCodeViewDelegate> delegate;
@property(nonatomic, readonly) UILabel *inputLabel;
@property(nonatomic, readonly) UITextField *inputTextField;
@property(nonatomic, readonly) UIButton *submitButton;

@end
