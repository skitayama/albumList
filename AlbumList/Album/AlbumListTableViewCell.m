//
//  AlbumListTableViewCell.m
//

#import "AlbumListTableViewCell.h"

@interface AlbumListTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *albumThumbnailImageView;
@property (nonatomic, weak) IBOutlet UILabel *albumTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *photoCountLabel;

@end

@implementation AlbumListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setter

- (void)setAssetCollectionModel:(AssetCollectionModel *)model {

    [self setAlbumTitleLabelText:model.title];
    [self setAlbumThumbnailImageViewImage:model.thumbnailImage];
    [self setPhotoCountLabelText:model.countString];
}

- (void)setAlbumThumbnailImageViewImage:(UIImage *)image {
    
    [self.albumThumbnailImageView setImage:image];
}

- (void)setAlbumTitleLabelText:(NSString *)text {

    [self.albumTitleLabel setText:text];
}

- (void)setPhotoCountLabelText:(NSString *)text {
    
    [self.photoCountLabel setText:text];
}

@end
