//
//  PLDLinkBankMFAContainerViewController.m
//  PlaidLink
//
//  Created by Simon Levy on 10/21/15.
//

#import "PLDLinkBankMFAContainerViewController.h"

#import "PLDAuthentication.h"
#import "PLDInstitution.h"
#import "PLDLinkBankMFALoginViewController.h"
#import "PLDLinkBankMFAContainerView.h"
#import "PLDLinkBankMFAViewController.h"
#import "PLDLinkBankMFAChoiceViewController.h"
#import "PLDLinkBankMFAQuestionOrCodeViewController.h"
#import "PLDLinkBankMFASelectionsViewController.h"

static const CGFloat kTopEdgeInset = 64.0f;
static const CGFloat kKeyboardPadding = 8.0f;

@interface PLDLinkBankMFAContainerViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate,
    PLDLinkBankLoginViewControllerDelegate, PLDLinkBankMFAViewControllerDelegate>
@end

@implementation PLDLinkBankMFAContainerViewController {
  UIViewController *_currentChildViewController;
  PLDLinkBankMFAContainerView *_view;
  BOOL _shouldHideStatusBar;
  BOOL _draggingScrollView;

  PLDInstitution *_institution;
  PlaidProduct _product;
}

- (instancetype)initWithInstitution:(PLDInstitution *)institution product:(PlaidProduct)product {
  if (self = [super init]) {
    _institution = institution;
    _product = product;
  }
  return self;
}

- (void)loadView {
  _view = [[PLDLinkBankMFAContainerView alloc] initWithFrame:CGRectZero];
  _view.delegate = self;
  self.view = _view;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = _institution.name;
  self.edgesForExtendedLayout = UIRectEdgeAll;
  self.automaticallyAdjustsScrollViewInsets = NO;
  [_view setContentInset:UIEdgeInsetsMake(kTopEdgeInset, 0, kKeyboardPadding, 0)];

  self.navigationItem.backBarButtonItem.action = @selector(didTapBack);
  self.navigationItem.backBarButtonItem.target = self;
  self.navigationController.interactivePopGestureRecognizer.delegate = self;

  PLDLinkBankMFALoginViewController *viewController =
      [[PLDLinkBankMFALoginViewController alloc] initWithInstitution:_institution
                                                          product:_product];
  viewController.delegate = self;
  [self addChildViewController:viewController];
  [_view setCurrentContentView:viewController.view];
  [viewController didMoveToParentViewController:self];
  _currentChildViewController = viewController;
}

- (void)viewWillAppear:(BOOL)animated {
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  [notificationCenter addObserver:self
                         selector:@selector(keyboardWillShow:)
                             name:UIKeyboardWillShowNotification
                           object:nil];
  [notificationCenter addObserver:self
                         selector:@selector(keyboardWillHide:)
                             name:UIKeyboardWillHideNotification
                           object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)prefersStatusBarHidden {
  return _shouldHideStatusBar;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
  return UIStatusBarAnimationSlide;
}

#pragma mark - Keyboard management

- (void)keyboardWillShow:(NSNotification *)notification {
  CGRect keyboardFrame = [notification.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];
  UIEdgeInsets currentInsets = _view.contentInset;
  currentInsets.bottom = keyboardFrame.size.height + kKeyboardPadding;
  [_view setContentInset:currentInsets];
  CGFloat realViewHeight = _view.bounds.size.height - (currentInsets.bottom + currentInsets.top);
  CGFloat contentDelta = _view.contentSize.height - realViewHeight;
  if (contentDelta > 0) {
    _draggingScrollView = YES;
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                       [_view setContentOffset:CGPointMake(0, -kTopEdgeInset + contentDelta)];
                     } completion:^(BOOL finished) {
                       _draggingScrollView = NO;
                     }];
  }
}

- (void)keyboardWillHide:(NSNotification *)notification {
  _draggingScrollView = YES;
  UIEdgeInsets currentInsets = _view.contentInset;
  currentInsets.bottom = kKeyboardPadding;
  [_view setContentInset:currentInsets];
  [UIView animateWithDuration:0.25
                        delay:0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     [_view setContentOffset:CGPointMake(0, -kTopEdgeInset)];
                   } completion:nil];
}

#pragma mark - PLDLinkBankLoginViewControllerDelegate

- (void)loginViewController:(PLDLinkBankMFALoginViewController *)loginViewController
    didFinishWithAuthentication:(PLDAuthentication *)authentication {
  if (authentication.mfa) {
    [self displayNextMFAStepWithAuthentication:authentication];
    return;
  }

  [_delegate mfaContainerViewController:self didFinishWithAuthentication:authentication];
}

#pragma mark - PLDLinkBankMFAViewControllerDelegate

- (void)bankMFAViewController:(PLDLinkBankMFAViewController *)viewController
  didFinishWithAuthentication:(PLDAuthentication *)authentication {
  if (authentication.mfa) {
    [self displayNextMFAStepWithAuthentication:authentication];
    return;
  }

  [_delegate mfaContainerViewController:self didFinishWithAuthentication:authentication];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (!_draggingScrollView) {
    return;
  }
  if (scrollView.contentOffset.y > -22 && !_shouldHideStatusBar) {
    _shouldHideStatusBar = YES;
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
      [self setNeedsStatusBarAppearanceUpdate];
    }];
  } else if (scrollView.contentOffset.y < -22 && _shouldHideStatusBar) {
    _shouldHideStatusBar = NO;
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
      [self setNeedsStatusBarAppearanceUpdate];
    }];
  }

  if (scrollView.contentOffset.y > -kTopEdgeInset && !self.navigationController.isNavigationBarHidden) {
    [self.navigationController setNavigationBarHidden:YES animated:YES];

  } else if (scrollView.contentOffset.y <= -kTopEdgeInset && self.navigationController.isNavigationBarHidden) {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
  }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  _draggingScrollView = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
  _draggingScrollView = NO;
  if (targetContentOffset->y == -kTopEdgeInset) {
    _shouldHideStatusBar = NO;
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
      [self setNeedsStatusBarAppearanceUpdate];
    }];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
  } else if (targetContentOffset->y > - 22) {
    _shouldHideStatusBar = YES;
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
      [self setNeedsStatusBarAppearanceUpdate];
    }];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
  }
}

#pragma mark - Private

- (void)didTapBack {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)displayNextMFAStepWithAuthentication:(PLDAuthentication *)authentication {
  PLDMFAType mfaType = authentication.mfa.type;
  PLDLinkBankMFAViewController *mfaViewController = nil;
  if (mfaType == kPLDMFATypeList) {
    mfaViewController =
        [[PLDLinkBankMFAChoiceViewController alloc] initWithAuthentication:authentication
                                                               institution:_institution];
  } else if (mfaType == kPLDMFATypeCode) {
    mfaViewController =
        [[PLDLinkBankMFAQuestionOrCodeViewController alloc] initWithAuthentication:authentication
                                                                       institution:_institution];
  } else if (mfaType == kPLDMFATypeSelection) {
    mfaViewController =
        [[PLDLinkBankMFASelectionsViewController alloc] initWithAuthentication:authentication
                                                                   institution:_institution];
  } else if (mfaType == kPLDMFATypeQuestion) {
    mfaViewController =
        [[PLDLinkBankMFAQuestionOrCodeViewController alloc] initWithAuthentication:authentication
                                                                       institution:_institution];
  } else {
    NSAssert(NO, @"Invalid mfa type");
  }

  mfaViewController.delegate = self;
  [self addChildViewController:mfaViewController];
  [_view setCurrentContentView:mfaViewController.view];
  [mfaViewController didMoveToParentViewController:self];

  if (_currentChildViewController) {
    [_currentChildViewController willMoveToParentViewController:nil];
    [_currentChildViewController removeFromParentViewController];
  }
  _currentChildViewController = mfaViewController;
}

@end
