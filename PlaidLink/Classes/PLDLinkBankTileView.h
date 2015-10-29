//
//  PLDLinkBankTileView.h
//  PlaidLink
//
//  Created by Andres Ugarte on 10/21/15.
//

#import <UIKit/UIKit.h>

@class PLDInstitution;

@interface PLDLinkBankTileView : UIView

@property(nonatomic) PLDInstitution *institution;

- (void)roundCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

@end
