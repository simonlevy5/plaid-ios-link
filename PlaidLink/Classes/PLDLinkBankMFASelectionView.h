//
//  PLDLinkBankMFASelectionView.h
//  PlaidLink
//
//  Created by Andres Ugarte on 10/28/15.
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
