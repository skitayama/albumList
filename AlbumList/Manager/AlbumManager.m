//
//  AlbumManager.m
//

#import "AlbumManager.h"

@interface AlbumManager () <PHPhotoLibraryChangeObserver>

@end

@implementation AlbumManager

#define THUMBNAIL_SIZE 60.0f

static AlbumManager *_instance;

#pragma mark - initialize

+ (void)initialize {
    
    @synchronized(self) {
        if(_instance == nil) {
            _instance = [[AlbumManager alloc] initInternal];
        }
    } // @synchronized(self)
}

+ (AlbumManager *)sharedInstance {
    
    return _instance;
}

- (id)init {
    
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initInternal {
    
    self = [super init];
    
    if (self) {
        // initialize
        [self initData];
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (!_instance) {
            _instance = [super allocWithZone:zone];
        }
    }
    return _instance;
}

- (void)initData {

    self.albumList = [NSMutableArray array];
    self.thumbnailList = [NSMutableArray array];
}

#pragma mark - getter

- (NSMutableArray *)selectedThumbnailList {
    
    NSMutableArray *selectedThumbnailList = [NSMutableArray array];
    if (!self.thumbnailList) {
        return selectedThumbnailList;
    } else {
        for (AssetModel *assetModel in self.thumbnailList) {
            if (assetModel.selected) {
                [selectedThumbnailList addObject:assetModel];
            }
        }
        return selectedThumbnailList;
    }
}

#pragma mark - Album Manager

// アルバム(PHAssetCollection)ロード
- (void)loadAlbums {

    dispatch_async(dispatch_get_main_queue(),^{
        self.albumList = [NSMutableArray array];

        // カメラロール
        PHFetchOptions *options = [PHFetchOptions new];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                         subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                         options:nil];

        AssetCollectionModel *model = [self addAssetCollectionModelObjectWithPHAssetCollection:(PHAssetCollection *)cameraRoll.firstObject];
        [self.albumList addObject:model];
        
        // モーメント
//        PHFetchResult *moments = [PHAssetCollection fetchMomentsWithOptions:nil];
//        for (PHAssetCollection *moment in moments) {
//            NSLog(@"%@",moment);
//        }

        // ユーザーアルバム
        PHFetchResult *userAlbums = [PHCollection fetchTopLevelUserCollectionsWithOptions:nil];
        for (PHAssetCollection *assetCollection in userAlbums) {
            AssetCollectionModel *model = [self addAssetCollectionModelObjectWithPHAssetCollection:(PHAssetCollection *)assetCollection];
            [self.albumList addObject:model];
        }
        // 更新通知
        if ([self.delegate respondsToSelector:@selector(didFinishLoadingAlbumList)]) {
            [self.delegate didFinishLoadingAlbumList];
        }
    });
}

- (AssetCollectionModel *)addAssetCollectionModelObjectWithPHAssetCollection:(PHAssetCollection *)assetCollection {

    PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    AssetCollectionModel *model = [[AssetCollectionModel alloc] init];
    model.assetCollection = assetCollection;
    model.thumbnailImage = [self thumbnailImageWithAsset:assets.lastObject];
    return model;
}

// サムネイル(PHAsset)ロード
- (void)loadThumbnailListWithAssetCollectionModel:(AssetCollectionModel *)model {

    dispatch_async(dispatch_get_main_queue(),^{
        self.thumbnailList = [NSMutableArray array];

        PHFetchOptions *options = [PHFetchOptions new];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        PHFetchResult *assets;
        if (!model) {
            // 全ての画像取得
            assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
        } else {
            // アルバムを戻るから判定してロード
            assets = [PHAsset fetchAssetsInAssetCollection:model.assetCollection options:options];
        }
        for(id fetchResult in assets) {
            PHAsset *asset = (PHAsset *)fetchResult;
            AssetModel *model = [self addAssetModelObjectWithPHAssetCollection:asset];
            [self.thumbnailList addObject:model];
        }
        // 更新通知
        if ([self.delegate respondsToSelector:@selector(didFinishLoadingThumbnailList)]) {
            [self.delegate didFinishLoadingThumbnailList];
        }
    });
}

- (AssetModel *)addAssetModelObjectWithPHAssetCollection:(PHAsset *)asset {

    AssetModel *model = [[AssetModel alloc] init];
    model.asset = asset;
    model.thumbnailImage = [self thumbnailImageWithAsset:asset];
    model.selected = NO;
    return model;
}

// サムネイル画像の取得
- (UIImage *)thumbnailImageWithAsset:(PHAsset *)asset {

    CGSize thumbnailSize = CGSizeMake(THUMBNAIL_SIZE, THUMBNAIL_SIZE);
    return [AlbumManager getImageWithAsset:asset size:thumbnailSize];
}

// 指定サイズでのUIImage取得
+ (UIImage *)getImageWithAsset:(PHAsset *)asset size:(CGSize)size {

    __block UIImage *image = nil;
    PHImageRequestOptions *thumbnailOptions = [[PHImageRequestOptions alloc] init];
    thumbnailOptions.synchronous = YES;
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:size
                                              contentMode:PHImageContentModeAspectFill
                                                  options:thumbnailOptions
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                image = result;
                                            }
     ];
    return image;
}


#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadAlbums];
        if ([self.delegate respondsToSelector:@selector(photoLibraryDidChange)]) {
            [self.delegate photoLibraryDidChange];
        }
    });
}

#pragma mark - Privacy Setting

+ (BOOL)isPhotoLibraryAccessNotDetermined {

    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusNotDetermined) {
        return YES;
    }
    return NO;
}
@end
