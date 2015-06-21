//
//  AssetModel.m
//

#import "AssetModel.h"

@implementation AssetModel

- (UIImage *)thumbnailImage {
    
    if (_thumbnailImage) {
        return _thumbnailImage;
    } else {
        return [UIImage imageNamed:@"AlbumNoPhotos"];
    }
}

@end
