//
//  AlbumManager.m
//

#import "AlbumManager.h"

@interface AlbumManager () <PHPhotoLibraryChangeObserver>

@end

@implementation AlbumManager

#define THUMBNAIL_SIZE 120.0f

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

- (NSMutableArray *)selectedMomentThumbnailList {

    NSMutableArray *selectedMomentThumbnailList = [NSMutableArray array];
    if (!self.momentList) {
        return selectedMomentThumbnailList;
    } else {
        for (AssetMomentModel *assetMomentModel in self.momentList) {
            for (AssetModel *assetModel in assetMomentModel.assetModelList) {
                if (assetModel.selected) {
                    [selectedMomentThumbnailList addObject:assetModel];
                }
            }
        }
        return selectedMomentThumbnailList;
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

        AssetCollectionModel *model = [self assetCollectionModelObjectWithPHAssetCollection:(PHAssetCollection *)cameraRoll.firstObject];
        [self.albumList addObject:model];

        // ユーザーアルバム
        PHFetchResult *userAlbums = [PHCollection fetchTopLevelUserCollectionsWithOptions:nil];
        for (PHAssetCollection *assetCollection in userAlbums) {
            AssetCollectionModel *model = [self assetCollectionModelObjectWithPHAssetCollection:(PHAssetCollection *)assetCollection];
            [self.albumList addObject:model];
        }
        // 更新通知
        if ([self.delegate respondsToSelector:@selector(didFinishLoadingAlbumList)]) {
            [self.delegate didFinishLoadingAlbumList];
        }
    });
}

// PHAssetCollectionから最終イメージをサムネイル用に作成。AssetCollectionModelに詰めて返却
- (AssetCollectionModel *)assetCollectionModelObjectWithPHAssetCollection:(PHAssetCollection *)assetCollection {

    PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    AssetCollectionModel *model = [[AssetCollectionModel alloc] init];
    model.assetCollection = assetCollection;
    model.thumbnailImage = [self thumbnailImageWithAsset:assets.lastObject];
    return model;
}

// モーメントのロード
// モーメントはアルバムと違い、全てのサムネイルが必要なため、構造を変更。
// PHAssetCollectionからすべてのAssetを切り出してリスト保持する。
- (void)loadMoments {
    dispatch_async(dispatch_get_main_queue(),^{
        self.momentList = [NSMutableArray array];
        
        //モーメント
        PHFetchResult *moments = [PHAssetCollection fetchMomentsWithOptions:nil];
        for (PHAssetCollection *moment in moments) {
            AssetCollectionModel *collectionModel = [self assetCollectionModelObjectWithPHAssetCollection:(PHAssetCollection *)moment];
            NSMutableArray *assetModelList = [self thumbnailListWithAssetCollectionModel:collectionModel];
            AssetMomentModel *momentModel = [[AssetMomentModel alloc] init];
            [momentModel setAssetModelList:assetModelList];
            [momentModel setDate:collectionModel.assetCollection.endDate];
            [self.momentList addObject:momentModel];
        }
        // 更新通知
        if ([self.delegate respondsToSelector:@selector(didFinishLoadingMomentList)]) {
            [self.delegate didFinishLoadingMomentList];
        }
    });
}

// サムネイル(PHAsset)ロード
- (void)loadThumbnailListWithAssetCollectionModel:(AssetCollectionModel *)model {

    dispatch_async(dispatch_get_main_queue(),^{
        self.thumbnailList = [self thumbnailListWithAssetCollectionModel:model];
        // 更新通知
        if ([self.delegate respondsToSelector:@selector(didFinishLoadingThumbnailList)]) {
            [self.delegate didFinishLoadingThumbnailList];
        }
    });
}

// AssetCollectionModelからAssetModelリストを作成して返す
- (NSMutableArray *)thumbnailListWithAssetCollectionModel:(AssetCollectionModel *)model {

    NSMutableArray *thumbnailList = [NSMutableArray array];
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
        AssetModel *model = [self assetModelObjectWithPHAssetCollection:asset];
        [thumbnailList addObject:model];
    }
    return thumbnailList;
}

// PHAssetからサムネイル画像を取得してAssetModelに詰めて返却する。
- (AssetModel *)assetModelObjectWithPHAssetCollection:(PHAsset *)asset {

    AssetModel *model = [[AssetModel alloc] init];
    model.asset = asset;
    model.thumbnailImage = [self thumbnailImageWithAsset:asset];
    model.selected = NO;
    return model;
}

// サムネイル画像の取得
- (UIImage *)thumbnailImageWithAsset:(PHAsset *)asset {

    // イメージをサムネイル用トリミング
    UIImage *image = [self resizeImageForThumbnailWithImage:[AlbumManager getImageWithAsset:asset]];

    // イメージをサムネイルサイズに縮小
    CGSize newSize = CGSizeMake(THUMBNAIL_SIZE, THUMBNAIL_SIZE);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// イメージを縮小しても違和感無いRectでトリミングする
- (UIImage *)resizeImageForThumbnailWithImage:(UIImage *)target {

    float width = target.size.width;
    float height = target.size.height;
    CGRect rect;
    if (height <= width) {
        float x = width / 2 - height / 2;
        float y = 0;
        rect = CGRectMake(x, y, height, height);
    } else {
        float x = 0;
        float y = height / 2 - width / 2;
        rect = CGRectMake(x, y, width, width);
    }

    CGImageRef cgImage = CGImageCreateWithImageInRect(target.CGImage, rect);
    UIImage *thumbnailImage = [UIImage imageWithCGImage:cgImage];
    return thumbnailImage;
}

// UIImage取得。外部でもPHAssetからの画像取得を可能とするためクラスメソッド化。
+ (UIImage *)getImageWithAsset:(PHAsset *)asset {

    __block UIImage *image = nil;
    CGRect rect = [[UIScreen mainScreen] bounds];
    PHImageRequestOptions *thumbnailOptions = [[PHImageRequestOptions alloc] init];
    thumbnailOptions.synchronous = YES;
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:rect.size
                                              contentMode:PHImageContentModeAspectFill
                                                  options:thumbnailOptions
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                image = result;
                                            }];
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

#pragma mark - Util
// Util にクラスメソッド化すべき
+ (NSString *)convertedDateStringWithDate:(NSDate *)date {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDoesRelativeDateFormatting:YES];
    return [dateFormatter stringFromDate:date];
}

@end
