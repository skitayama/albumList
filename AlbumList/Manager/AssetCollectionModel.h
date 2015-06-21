//
//  AssetCollectionModel.h
//

#import <Foundation/Foundation.h>
@import Photos;

@interface AssetCollectionModel : NSObject

@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic, weak, readonly) NSString *title;
@property (nonatomic, readonly) NSInteger count;
@property (nonatomic, weak, readonly) NSString *countString;

@end
