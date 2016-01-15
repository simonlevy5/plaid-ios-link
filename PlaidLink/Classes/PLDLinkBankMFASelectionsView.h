//
//  PLDLinkBankMFASelectionsView.h
//  PlaidLink
//
//  Created by Andres Ugarte on 10/28/15.
//

#import <UIKit/UIKit.h>

#import "PLDLinkBankMFABaseStepView.h"

@class PLDLinkBankMFAExplainerView;

@interface PLDLinkBankMFASelectionsView : PLDLinkBankMFABaseStepView

@property(nonatomic, readonly) PLDLinkBankMFAExplainerView *explainer;

- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor;
- (void)setCurrentSelectionView:(UIView *)selectionView;

@end
