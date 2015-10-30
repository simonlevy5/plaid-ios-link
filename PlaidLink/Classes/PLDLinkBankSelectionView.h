//
//  PLDLinkBankSelectionView.h
//  PlaidLink
//
//  Created by Simon Levy on 10/13/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PLDInstitution;
@class PLDLinkBankSelectionView;
@class PLDLinkBankSelectionViewCell;
@class PLDLinkBankTileView;

@protocol PLDLinkBankSelectionViewDelegate <NSObject>

- (void)bankSelectionView:(PLDLinkBankSelectionView *)view
     didSelectInstitution:(PLDInstitution *)institution;
- (void)bankSelectionViewDidSelectSearch:(PLDLinkBankSelectionView *)view;
- (void)bankSelectionViewDidSelectNotListed:(PLDLinkBankSelectionView *)view;

@end

@interface PLDLinkBankSelectionViewCell : UICollectionViewCell

@property(nonatomic, readonly) PLDLinkBankTileView *tileView;

@end

@interface PLDLinkBankSelectionView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, weak) id<PLDLinkBankSelectionViewDelegate> delegate;
@property(nonatomic) UICollectionView *collectionView;
@property(nonatomic) NSArray *institutions;  // NSArray<PLDInstitution *>
@property(nonatomic) PLDLinkBankSelectionViewCell *selectedCell;

- (void)scrollToBottom;
- (void)showLoadingSpinner;
- (void)hideLoadingSpinner;

@end
