//
//  PLDLinkSelectionToLoginAnimator.m
//  PlaidLink
//
//  Created by Andres Ugarte on 10/19/15.
//

#import "PLDLinkSelectionToLoginAnimator.h"

#import "PLDLinkBankMFAContainerView.h"
#import "PLDLinkBankSelectionView.h"
#import "PLDLinkBankTileView.h"

@implementation PLDLinkSelectionToLoginAnimator

static CGFloat const kInputContainerAnimationDuration = 0.25;
static CGFloat const kBankTileAnimationDuration = 0.35;

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
  return kBankTileAnimationDuration + kInputContainerAnimationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
  if (!self.reverse) {
    PLDLinkBankSelectionView *bankSelectionView =
        [transitionContext viewForKey:UITransitionContextFromViewKey];
    PLDLinkBankMFAContainerView *bankContainerView =
        [transitionContext viewForKey:UITransitionContextToViewKey];
    [[transitionContext containerView] addSubview:bankSelectionView];
    [[transitionContext containerView] addSubview:bankContainerView];
    bankContainerView.frame =
        [transitionContext finalFrameForViewController:[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey]];
    [bankContainerView layoutSubviews];

    PLDLinkBankSelectionViewCell *selectedCell = [bankSelectionView selectedCell];
    PLDLinkBankTileView *tileView = selectedCell.tileView;
    CGRect tileFrame = [bankSelectionView.collectionView convertRect:selectedCell.frame
                                                              toView:bankContainerView];
    PLDLinkBankTileView *animatedTileView = [[PLDLinkBankTileView alloc] initWithFrame:tileFrame];
    animatedTileView.institution = tileView.institution;
    [animatedTileView layoutSubviews];
    bankContainerView.bankTileView = animatedTileView;
    selectedCell.hidden = YES;

    bankContainerView.contentContainer.hidden = YES;

    [UIView animateWithDuration:kBankTileAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
      [bankContainerView layoutSubviews];
      [animatedTileView layoutSubviews];
      CATransform3D fromViewTransform = CATransform3DIdentity;
      fromViewTransform.m34 = 1.0 / -500;
      bankSelectionView.layer.transform = CATransform3DTranslate(fromViewTransform, 0, 0, -200);
      bankSelectionView.alpha = 0;
      } completion:^(BOOL finished) {
        [UIView animateWithDuration:kInputContainerAnimationDuration
                             delay:0
                           options:UIViewAnimationOptionCurveEaseOut
                        animations:^{
          bankContainerView.contentContainer.hidden = NO;
          bankContainerView.showContentContainer = YES;
          [bankContainerView layoutIfNeeded];
          } completion:^(BOOL finished) {
            bankContainerView.alpha = 1;
            bankSelectionView.alpha = 1;
            selectedCell.hidden = NO;
            bankSelectionView.layer.transform = CATransform3DIdentity;
            [bankContainerView animateForgotPasswordButtonIn];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
          }];
    }];
  } else {
    PLDLinkBankSelectionView *bankSelectionView =
        [transitionContext viewForKey:UITransitionContextToViewKey];
    PLDLinkBankMFAContainerView *bankContainerView =
        [transitionContext viewForKey:UITransitionContextFromViewKey];
    [[transitionContext containerView] addSubview:bankSelectionView];
    [[transitionContext containerView] addSubview:bankContainerView];
    bankSelectionView.frame = [transitionContext finalFrameForViewController:
        [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey]];
    [bankSelectionView layoutSubviews];
    bankSelectionView.collectionView.alpha = 0;
    CATransform3D fromViewTransform = CATransform3DIdentity;
    fromViewTransform.m34 = 1.0 / -500;
    bankSelectionView.collectionView.layer.transform =
        CATransform3DTranslate(fromViewTransform, 0, 0, -200);

    PLDLinkBankSelectionViewCell *selectedCell = [bankSelectionView selectedCell];
    selectedCell.hidden = YES;

    [UIView animateWithDuration:kInputContainerAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        bankContainerView.showContentContainer = NO;
        bankContainerView.showForgotPasswordLink = NO;
        [bankContainerView layoutIfNeeded];
      } completion:^(BOOL finished) {
        bankContainerView.contentContainer.hidden = YES;
        PLDLinkBankTileView *bankTileView = bankContainerView.bankTileView;
        bankTileView.alpha = 0;
        CGRect adjustedFrame = [bankContainerView convertRect:bankTileView.frame
                                                       toView:bankSelectionView];
        PLDLinkBankTileView *animatedTileView =
            [[PLDLinkBankTileView alloc] initWithFrame:adjustedFrame];
        animatedTileView.institution = bankTileView.institution;
        [animatedTileView layoutSubviews];
        [bankSelectionView addSubview:animatedTileView];
        [UIView animateWithDuration:kBankTileAnimationDuration
                             delay:0
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
          bankSelectionView.collectionView.alpha = 1;
          bankSelectionView.collectionView.layer.transform = CATransform3DIdentity;
          animatedTileView.frame = [bankSelectionView convertRect:selectedCell.frame
                                                         fromView:bankSelectionView.collectionView];
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
