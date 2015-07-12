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

    [self.selectedImageView setImage:[UIImage imageNamed:@"ThumbnailCheck"]];
}

- (void)setAssetModel:(AssetModel *)model mode:(ThumbnailCollectionViewCellMode)mode {

    [self setModel:model];
    [self.thumbnailImageView setImage:model.thumbnailImage];
    [self setSelectedImageAlpha:model.selected];
    [self setSelectedImage:mode];
    if ([self.delegate conformsToProtocol:@protocol(AlbumThumbnailCollectionViewCellDelegate)]) {
        [self createGestureRecognizers];
    }
}

#pragma mark - Setter

- (void)setSelectedImageAlpha:(BOOL)selected {

    if (selected) {
        [self.selectedImageView setAlpha:1.0f];
    } else {
        [self.selectedImageView setAlpha:0.3f];
    }
}

- (void)setSelectedImage:(ThumbnailCollectionViewCellMode)mode {

    switch (mode) {
        case ThumbnailCollectionViewCellModeNormal:
            [self.selectedImageView setImage:[UIImage imageNamed:@"ThumbnailCheck"]];
            break;
        case ThumbnailCollectionViewCellModeGrouped:
            [self.selectedImageView setImage:[UIImage imageNamed:@"ThumbnailClear"]];
            break;
        default:
            [self.selectedImageView setImage:nil];
            break;
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
