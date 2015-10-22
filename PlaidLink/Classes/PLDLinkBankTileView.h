//
//  PLDLinkBankTileView.h
//  plaid
//
//  Created by Andres Ugarte on 10/21/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLDInstitution;

@interface PLDLinkBankTileView : UIView

@property(nonatomic) PLDInstitution *institution;

- (void)roundCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

@end
