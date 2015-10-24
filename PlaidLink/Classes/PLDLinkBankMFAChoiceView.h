//
//  PLDLinkBankMFAChoiceView.h
//  PlaidLink
//
//  Created by Andres Ugarte on 10/22/15.
//  Copyright © 2015 Simon Levy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PLDLinkBankMFAChoiceViewDelegate <NSObject>

- (void)choiceView:(UIView *)view didSelectChoice:(NSString *)choice;

@end

@interface PLDLinkBankMFAChoiceView : UIView

- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor;

@property(nonatomic, weak) id<PLDLinkBankMFAChoiceViewDelegate> delegate;
@property(nonatomic) NSArray *choices;

@end
