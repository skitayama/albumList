//
//  AlbumThumbnailCollectionViewCell.m
//

#import "AlbumThumbnailCollectionViewCell.h"

@interface AlbumThumbnailCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, weak) IBOutlet UIImageView *selectedImageView;

@end

@implementation AlbumThumbnailCollectionViewCell

- (void)awakeFromNib {

    [self.selectedImageView setImage:[UIImage imageNamed:@"ThumbnailNoCheck"]];
}

- (void)setAssetModel:(AssetModel *)model {

    [self.thumbnailImageView setImage:model.thumbnailImage];
    [self setSelectedImage:model.selected];
}

- (void)setSelectedImage:(BOOL)selected {

    if (selected) {
        [self.selectedImageView setImage:[UIImage imageNamed:@"ThumbnailCheck"]];
    } else {
        [self.selectedImageView setImage:[UIImage imageNamed:@"ThumbnailNoCheck"]];
    }
}

@end
