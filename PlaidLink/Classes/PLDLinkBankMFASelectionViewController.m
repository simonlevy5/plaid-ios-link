//
//  PLDLinkBankMFASelectionViewController.m
//  PlaidLink
//
//  Created by Simon Levy on 10/21/15.
//

#import "PLDLinkBankMFASelectionViewController.h"

#import "PLDAuthentication.h"
#import "PLDInstitution.h"
#import "PLDLinkBankMFAContainerView.h"
#import "PLDLinkBankMFASelectionView.h"

@interface PLDLinkBankMFASelectionViewController ()<PLDLinkBankMFASelectionViewDelegate>
@end

@implementation PLDLinkBankMFASelectionViewController {
  PLDMFAAuthenticationSelection *_selection;
  PLDInstitution *_institution;
  PLDLinkBankMFASelectionView *_view;
}

- (instancetype)initWithAuthenticationSelection:(PLDMFAAuthenticationSelection *)selection institution:(PLDInstitution *)institution {
  if (self = [super init]) {
    _selection = selection;
    _institution = institution;
  }
  return self;
}

- (void)loadView {
  _view = [[PLDLinkBankMFASelectionView alloc] initWithSelection:_selection
                                                       tintColor:_institution.backgroundColor];
  _view.delegate = self;
  self.view = _view;
}

#pragma mark - PLDLinkBankMFASelectionViewDelegate

- (void)selectionView:(UIView *)view didChooseAnswer:(NSString *)answer {
  [_delegate selectionViewController:self didChooseAnswer:answer];
}

@end
