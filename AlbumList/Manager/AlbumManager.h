//
//  AlbumManager.h
//

#import <Foundation/Foundation.h>
#import "AssetCollectionModel.h"
#import "AssetModel.h"
#import "SCAlbumThumbnailMode.h"
@import Photos;

@protocol AlbumManagerDelegate <NSObject>

- (void)photoLibraryDidChange;

- (void)didFinishLoading;

@end

@interface AlbumManager : NSObject

@property (nonatomic, weak) id<AlbumManagerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *albumList;
@property (nonatomic, strong) NSMutableArray *thumbnailList;
@property (nonatomic)NSMutableArray *selectedThumbnailList;

#pragma mark - Singleton Implementation
+ (AlbumManager *)sharedInstance;
- (id)init UNAVAILABLE_ATTRIBUTE;


- (void)loadAlbums;
- (void)loadThumbnailListWithAssetCollectionModel:(AssetCollectionModel *)model;

@end
