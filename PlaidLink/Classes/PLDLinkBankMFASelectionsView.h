//
//  PLDLinkBankMFASelectionsView.h
//  PlaidLink
//
//  Created by Andres Ugarte on 10/28/15.
//  Copyright © 2015 Simon Levy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLDLinkBankMFAExplainerView;

@interface PLDLinkBankMFASelectionsView : UIView

@property(nonatomic, readonly) PLDLinkBankMFAExplainerView *explainer;

- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor;
- (void)setCurrentSelectionView:(UIView *)selectionView;

@end
