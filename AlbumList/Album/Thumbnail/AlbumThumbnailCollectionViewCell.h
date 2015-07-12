//
//  AlbumThumbnailCollectionViewCell.h
//

#import <UIKit/UIKit.h>
#import "AssetModel.h"

typedef NS_ENUM (NSUInteger, ThumbnailCollectionViewCellMode) {
    ThumbnailCollectionViewCellModeNormal,
    ThumbnailCollectionViewCellModeGrouped
};

@protocol AlbumThumbnailCollectionViewCellDelegate <NSObject>
@optional
- (void)didTapThumbnailImage:(AssetModel *)model;
- (void)didTapSelectedImage:(AssetModel *)model;

@end

@interface AlbumThumbnailCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) id<AlbumThumbnailCollectionViewCellDelegate> delegate;

- (void)setAssetModel:(AssetModel *)model mode:(ThumbnailCollectionViewCellMode)mode;
- (void)setSelectedImageAlpha:(BOOL)selected;

@end
