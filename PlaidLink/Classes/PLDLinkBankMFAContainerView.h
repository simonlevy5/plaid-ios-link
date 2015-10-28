//
//  PLDLinkBankContainerView.h
//  Plaid
//
//  Created by Simon Levy on 10/20/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLDLinkBankTileView;

@interface PLDLinkBankMFAContainerView : UIScrollView

@property(nonatomic) PLDLinkBankTileView *bankTileView;
@property(nonatomic, assign) NSString *explainerText;
@property(nonatomic, readonly) UIView *contentContainer;
@property(nonatomic) BOOL showContentContainer;

- (void)setCurrentContentView:(UIView *)contentView;

@end
