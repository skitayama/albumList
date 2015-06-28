//
//  AlbumGroupedThumbnailViewController.h
//

#import <UIKit/UIKit.h>
#import "AlbumManager.h"
#import "AlbumThumbnailCollectionViewCell.h"

@interface AlbumGroupedThumbnailViewController : UIViewController <
    UICollectionViewDelegate,
    AlbumThumbnailCollectionViewCellDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    AlbumManagerDelegate
>

@end
