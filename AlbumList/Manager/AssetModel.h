//
//  AssetModel.h
//

#import <Foundation/Foundation.h>
@import Photos;

@interface AssetModel : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic) BOOL selected;

@end
