//
//  AlbumManager.h
//

#import <Foundation/Foundation.h>
#import "AssetCollectionModel.h"
#import "AssetModel.h"
#import "AssetMomentModel.h"
@import Photos;

@protocol AlbumManagerDelegate <NSObject>

- (void)photoLibraryDidChange;

@optional
- (void)didFinishLoadingAlbumList;
- (void)didFinishLoadingMomentList;
- (void)didFinishLoadingThumbnailList;

@end

@interface AlbumManager : NSObject

@property (nonatomic, weak) id<AlbumManagerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *albumList;
@property (nonatomic, strong) NSMutableArray *momentList;
@property (nonatomic, strong) NSMutableArray *thumbnailList;
@property (nonatomic) NSMutableArray *selectedThumbnailList;
@property (nonatomic) NSMutableArray *selectedMomentThumbnailList;

#pragma mark - Singleton Implementation
+ (AlbumManager *)sharedInstance;
- (id)init UNAVAILABLE_ATTRIBUTE;

#pragma mark - AlbumManager
- (void)loadAlbums;
- (void)loadMoments;
- (void)loadThumbnailListWithAssetCollectionModel:(AssetCollectionModel *)model;

+ (UIImage *)getImageWithAsset:(PHAsset *)asset;

#pragma mark - Privacy Setting
+ (BOOL)isPhotoLibraryAccessNotDetermined;  // 未選択か

#pragma mark - Util
// Util にクラスメソッド化すべき
+ (NSString *)convertedDateStringWithDate:(NSDate *)date;

@end
