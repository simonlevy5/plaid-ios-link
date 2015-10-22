//
//  PLDLinkSelectionToLoginAnimator.m
//  plaid
//
//  Created by Andres Ugarte on 10/19/15.
//  Copyright © 2015 Vouch Financial, Inc. All rights reserved.
//

#import "PLDLinkSelectionToLoginAnimator.h"

#import "PLDLinkBankContainerView.h"
#import "PLDLinkBankSelectionView.h"
#import "PLDLinkBankTileView.h"

@implementation PLDLinkSelectionToLoginAnimator

static CGFloat const kInputContainerAnimationDuration = 0.3;
static CGFloat const kBankTileAnimationDuration = 0.4;

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
  return kBankTileAnimationDuration + kInputContainerAnimationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  if (!self.reverse) {
    PLDLinkBankSelectionView *bankSelectionView =
        [transitionContext viewForKey:UITransitionContextFromViewKey];
    PLDLinkBankContainerView *bankContainerView =
        [transitionContext viewForKey:UITransitionContextToViewKey];
    [[transitionContext containerView] setBackgroundColor:[UIColor colorWithWhite:0.96 alpha:1]];
    [[transitionContext containerView] addSubview:bankSelectionView];
    [[transitionContext containerView] addSubview:bankContainerView];
    bankContainerView.frame = bankSelectionView.frame;
    [bankContainerView layoutSubviews];
    bankContainerView.backgroundColor = [UIColor clearColor];

    PLDLinkBankSelectionViewCell *selectedCell = [bankSelectionView selectedCell];
    PLDLinkBankTileView *tileView = selectedCell.tileView;
    CGRect tileFrame = [bankSelectionView.collectionView convertRect:selectedCell.frame
                                                              toView:bankContainerView];
    PLDLinkBankTileView *animatedTileView = [[PLDLinkBankTileView alloc] initWithFrame:tileFrame];
    animatedTileView.institution = tileView.institution;
    [animatedTileView layoutSubviews];
    bankContainerView.bankTileView = animatedTileView;
    selectedCell.hidden = YES;

    bankContainerView.contentContainer.alpha = 0;
    bankContainerView.contentContainer.transform =
        CGAffineTransformMakeTranslation(0, -bankContainerView.contentContainer.bounds.size.height);

    [UIView animateWithDuration:kBankTileAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
      bankContainerView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
      [bankContainerView layoutSubviews];
      [animatedTileView layoutSubviews];
      CATransform3D fromViewTransform = CATransform3DIdentity;
      fromViewTransform.m34 = 1.0 / -500;
      bankSelectionView.layer.transform = CATransform3DTranslate(fromViewTransform, 0, 0, -200);
      } completion:^(BOOL finished) {
        [UIView animateWithDuration:kInputContainerAnimationDuration
                             delay:0
                           options:UIViewAnimationOptionCurveEaseOut
                        animations:^{
          bankContainerView.contentContainer.alpha = 1;
          bankContainerView.contentContainer.transform = CGAffineTransformIdentity;
          } completion:^(BOOL finished) {
            bankContainerView.alpha = 1;
            bankSelectionView.alpha = 1;
            selectedCell.hidden = NO;
            bankSelectionView.layer.transform = CATransform3DIdentity;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
          }];
    }];

  } else {
    PLDLinkBankSelectionView *bankSelectionView = [transitionContext viewForKey:UITransitionContextToViewKey];
    PLDLinkBankContainerView *bankContainerView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [[transitionContext containerView] setBackgroundColor:[UIColor colorWithWhite:0.96 alpha:1]];
    [[transitionContext containerView] addSubview:bankSelectionView];
    [[transitionContext containerView] addSubview:bankContainerView];
    bankSelectionView.frame = bankContainerView.frame;
    [bankSelectionView layoutSubviews];
    bankSelectionView.collectionView.alpha = 0;
    CATransform3D fromViewTransform = CATransform3DIdentity;
    fromViewTransform.m34 = 1.0 / -500;
    bankSelectionView.collectionView.layer.transform = CATransform3DTranslate(fromViewTransform, 0, 0, -200);
    bankContainerView.backgroundColor = [UIColor clearColor];

    PLDLinkBankSelectionViewCell *selectedCell = [bankSelectionView selectedCell];
    selectedCell.hidden = YES;

    [UIView animateWithDuration:kInputContainerAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
      bankContainerView.contentContainer.alpha = 0;
      bankContainerView.contentContainer.frame =
       CGRectOffset(bankContainerView.contentContainer.frame, 0,
                    -CGRectGetHeight(bankContainerView.contentContainer.bounds));
      } completion:^(BOOL finished) {
        PLDLinkBankTileView *bankTileView = bankContainerView.bankTileView;
        bankTileView.alpha = 0;
        PLDLinkBankTileView *animatedTileView = [[PLDLinkBankTileView alloc] initWithFrame:bankTileView.frame];
        animatedTileView.institution = bankTileView.institution;
        [animatedTileView layoutSubviews];
        [bankSelectionView addSubview:animatedTileView];
        [UIView animateWithDuration:kBankTileAnimationDuration
                             delay:0
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
          bankSelectionView.collectionView.alpha = 1;
          bankSelectionView.collectionView.layer.transform = CATransform3DIdentity;
          animatedTileView.frame = selectedCell.frame;
          [animatedTileView layoutSubviews];
        } completion:^(BOOL finished) {
          selectedCell.hidden = NO;
          [animatedTileView removeFromSuperview];
          [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }];
  }
}

@end
