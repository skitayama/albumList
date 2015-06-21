//
//  AlbumThumbnailCollectionViewCell.h
//

#import <UIKit/UIKit.h>
#import "AssetModel.h"

@interface AlbumThumbnailCollectionViewCell : UICollectionViewCell

- (void)setAssetModel:(AssetModel *)model;

- (void)setSelectedImage:(BOOL)selected;

@end
