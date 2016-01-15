//
//  PLDLinkBankMFABaseStepView.h
//  Pods
//
//  Created by Andres Ugarte on 1/12/16.
//
//

#import <UIKit/UIKit.h>

@class PLDLinkStyledButton;

@interface PLDLinkBankMFABaseStepView : UIView

@property(nonatomic, readonly) UIView *errorContainer;
@property(nonatomic, readonly) UILabel *titleLabel;
@property(nonatomic, readonly) UILabel *descriptionLabel;
@property(nonatomic, readonly) PLDLinkStyledButton *closeButton;

- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor;

- (void)showErrorWithTitle:(NSString *)title
               description:(NSString *)description
                buttonCopy:(NSString *)buttonCopy;
@end
