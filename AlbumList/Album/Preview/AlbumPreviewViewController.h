//
//  AlbumPreviewViewController.h
//

#import <UIKit/UIKit.h>
#import "AlbumManager.h"

@interface AlbumPreviewViewController : UIViewController <
    UIScrollViewDelegate,
    AlbumManagerDelegate
>

@property BOOL isMoment;    // モーメントからの遷移か否か

@end
