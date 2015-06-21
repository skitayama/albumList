//
//  AlbumListTableViewCell.h
//

#import <UIKit/UIKit.h>
#import "AssetCollectionModel.h"

@interface AlbumListTableViewCell : UITableViewCell

#pragma mark - setter

- (void)setAssetCollectionModel:(AssetCollectionModel *)model;
- (void)setAlbumThumbnailImageViewImage:(UIImage *)image;
- (void)setAlbumTitleLabelText:(NSString *)text;
- (void)setPhotoCountLabelText:(NSString *)text;

@end
