//
//  PLDLinkBankContainerView.h
//  PlaidLink
//
//  Created by Simon Levy on 10/20/15.
//

#import <UIKit/UIKit.h>

@class PLDLinkBankTileView;

@interface PLDLinkBankMFAContainerView : UIScrollView

@property(nonatomic) PLDLinkBankTileView *bankTileView;
@property(nonatomic, readonly) UIView *contentContainer;
@property(nonatomic) BOOL showContentContainer;

- (void)setCurrentContentView:(UIView *)contentView;

@end
