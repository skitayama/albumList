//
//  AlbumThumbnailCollectionViewCell.m
//

#import "AlbumThumbnailCollectionViewCell.h"

@interface AlbumThumbnailCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, weak) IBOutlet UIImageView *selectedImageView;
@property (nonatomic) AssetModel *model;

@end

@implementation AlbumThumbnailCollectionViewCell

#pragma mark - initialize

- (void)awakeFromNib {

    [self.selectedImageView setImage:[UIImage imageNamed:@"ThumbnailNoCheck"]];
}

- (void)setAssetModel:(AssetModel *)model {

    [self setModel:model];
    [self.thumbnailImageView setImage:model.thumbnailImage];
    [self setSelectedImage:model.selected];
    if ([self.delegate conformsToProtocol:@protocol(AlbumThumbnailCollectionViewCellDelegate)]) {
        [self createGestureRecognizers];
    }
}

#pragma mark - Setter

- (void)setSelectedImage:(BOOL)selected {

    if (selected) {
        [self.selectedImageView setImage:[UIImage imageNamed:@"ThumbnailCheck"]];
    } else {
        [self.selectedImageView setImage:[UIImage imageNamed:@"ThumbnailNoCheck"]];
    }
}

#pragma mark - GestureRecognizer

- (void)createGestureRecognizers {

    [self.thumbnailImageView setUserInteractionEnabled:YES];
    [self.selectedImageView setUserInteractionEnabled:YES];
    // タップジェスチャー
    UIGestureRecognizer* thumbnailGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapThumbnailGesture:)];
    UIGestureRecognizer* selectedGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSelectedGesture:)];
    [self.thumbnailImageView addGestureRecognizer:thumbnailGesture];
    [self.selectedImageView addGestureRecognizer:selectedGesture];
}

#pragma mark - Action

- (void)didTapThumbnailGesture:(UITapGestureRecognizer*)tapGestureRecognizer {

    if ([self.delegate respondsToSelector:@selector(didTapThumbnailImage:)]) {
        [self.delegate didTapThumbnailImage:self.model];
    }
}

- (void)didTapSelectedGesture:(UITapGestureRecognizer*)tapGestureRecognizer {

    if ([self.delegate respondsToSelector:@selector(didTapSelectedImage:)]) {
        [self.delegate didTapSelectedImage:self.model];
    }
}

@end
