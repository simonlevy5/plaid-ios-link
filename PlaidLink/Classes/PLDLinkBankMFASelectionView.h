//
//  PLDLinkBankMFASelectionView.h
//  PlaidLink
//
//  Created by Andres Ugarte on 10/28/15.
//  Copyright © 2015 Simon Levy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLDMFAAuthenticationSelection;

@protocol PLDLinkBankMFASelectionViewDelegate <NSObject>

- (void)selectionView:(UIView *)view didChooseAnswer:(NSString *)answer;

@end

@interface PLDLinkBankMFASelectionView : UIView

@property(nonatomic, weak) id<PLDLinkBankMFASelectionViewDelegate> delegate;
@property(nonatomic, readonly) UILabel *questionLabel;
@property(nonatomic, readonly) NSArray *answers;

- (instancetype)initWithSelection:(PLDMFAAuthenticationSelection *)selection tintColor:(UIColor *)tintColor;

@end
