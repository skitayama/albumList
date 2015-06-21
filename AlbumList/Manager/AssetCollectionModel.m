//
//  AssetCollectionModel.m
//

#import "AssetCollectionModel.h"

@implementation AssetCollectionModel

- (UIImage *)thumbnailImage {

    if (_thumbnailImage) {
        return _thumbnailImage;
    } else {
        return [UIImage imageNamed:@"AlbumNoPhotos"];
    }
}

- (NSString *)title {

    return self.assetCollection.localizedTitle;
}

- (NSInteger)count {

    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:nil];
    return [result count];
}

- (NSString *)countString {

    NSString *photoCount = [NSString stringWithFormat:@"%lu",self.count];
    return photoCount;
}

@end
