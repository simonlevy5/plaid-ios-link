//
//  PLDLinkBankMFAViewController.h
//  PlaidLink
//
//  Created by Simon Levy on 10/14/15.
//

#import <UIKit/UIKit.h>

@class PLDAuthentication;
@class PLDInstitution;
@class PLDLinkBankMFAViewController;

@protocol PLDLinkBankMFAViewControllerDelegate <NSObject>

- (void)bankMFAViewController:(PLDLinkBankMFAViewController *)viewController
    didFinishWithAuthentication:(PLDAuthentication *)authentication;

@end

@interface PLDLinkBankMFAViewController : UIViewController

@property(nonatomic, weak) id<PLDLinkBankMFAViewControllerDelegate> delegate;
@property(nonatomic, readonly) PLDAuthentication *authentication;
@property(nonatomic, readonly) PLDInstitution *institution;

- (instancetype)initWithAuthentication:(PLDAuthentication *)authentication
                           institution:(PLDInstitution *)institution;

- (void)submitMFAStepResponse:(id)response
                      options:(NSDictionary *)options
                   completion:(void (^)(NSError *))completion;

@end
