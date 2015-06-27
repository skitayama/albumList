//
//  AlbumThumbnailViewController.h
//

#import <UIKit/UIKit.h>
#import "AlbumManager.h"

@interface AlbumThumbnailViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, AlbumManagerDelegate>

@property AssetCollectionModel *selectedModel;

@end
