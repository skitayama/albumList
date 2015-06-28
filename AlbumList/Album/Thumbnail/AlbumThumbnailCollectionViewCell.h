//
//  AlbumThumbnailCollectionViewCell.h
//

#import <UIKit/UIKit.h>
#import "AssetModel.h"

@protocol AlbumThumbnailCollectionViewCellDelegate <NSObject>
@optional
- (void)didTapThumbnailImage:(AssetModel *)model;
- (void)didTapSelectedImage:(AssetModel *)model;

@end

@interface AlbumThumbnailCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) id<AlbumThumbnailCollectionViewCellDelegate> delegate;

- (void)setAssetModel:(AssetModel *)model;

- (void)setSelectedImage:(BOOL)selected;

@end
