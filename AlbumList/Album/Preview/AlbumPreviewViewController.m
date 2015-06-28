//
//  AlbumPreviewViewController.m
//

#import "AlbumPreviewViewController.h"

#define kNumberOfPages 5
#define kPageControlHeight 50.0f
#define kDefaultZoomScaleMin 1.0f
#define kDefaultZoomScaleMax 3.0f

@interface AlbumPreviewViewController ()

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIPageControl *pageControl;

@property AlbumManager *albumManager;

@end

@implementation AlbumPreviewViewController

#pragma mark - Lifecycle method

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self settingAlbumManager];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated {

    [self initView];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - initialize

- (void)initView {
    
    [self initUI];
    [self initData];
}

- (void)initUI {

    [self setupScrollView];
    [self setupPageControll];
}

- (void)settingAlbumManager {
    
    if (!self.albumManager) {
        self.albumManager = [AlbumManager sharedInstance];
        self.albumManager.delegate = self;
    }
}

- (void)initData {
    
    // init Data
}

#pragma mark - setupPageControll

- (void)setupScrollView {

    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    NSInteger count = [self getNumberOfPages];

    self.scrollView = [[UIScrollView alloc]init];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView setFrame:self.view.bounds];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setUserInteractionEnabled:YES];

    // ピンチイン・アウトによる拡大縮小スケールサイズ
    [self.scrollView setMinimumZoomScale:kDefaultZoomScaleMin];
    [self.scrollView setMaximumZoomScale:kDefaultZoomScaleMax];
    self.scrollView.delegate = self;
    
    // スクロールの範囲設定
    [self.scrollView setContentSize:CGSizeMake((count * width), height)];

    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                             0.0f,
                                                             self.scrollView.contentSize.width,
                                                             self.scrollView.contentSize.height)];
    // スクロールビューにラベルを貼付ける
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        AssetModel *model = [self.albumManager.selectedThumbnailList objectAtIndex:i];
        [imageView setImage:[AlbumManager getImageWithAsset:model.asset size:imageView.bounds.size]];
        [aView addSubview:imageView];
        //[self.scrollView addSubview:imageView];
    }
    [self.scrollView addSubview:aView];
    [self.view addSubview:self.scrollView];
}

- (void)setupPageControll {

    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height - kPageControlHeight;
    NSInteger count = [self getNumberOfPages];

    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, height, width, kPageControlHeight)];
    [self.pageControl setBackgroundColor:[UIColor clearColor]];
    [self.pageControl setHidesForSinglePage:YES];
    [self.pageControl setNumberOfPages:count];
    [self.pageControl setCurrentPage:0];
    [self.pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor yellowColor]];

    [self.view addSubview:self.pageControl];

}

- (NSInteger)getNumberOfPages {

    NSInteger count = kNumberOfPages;
    if (self.albumManager) {
        NSInteger selectCount = [self.albumManager.selectedThumbnailList count];
        count = (selectCount < kNumberOfPages) ? selectCount : kNumberOfPages;
    }
    return count;
}

#pragma mark - UIScrollViewDelegate

// スクロールビュースワイプ
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView {

    CGFloat scale = self.scrollView.zoomScale;
    CGFloat pageWidth = self.scrollView.frame.size.width * scale;
    if ((NSInteger)fmod(self.scrollView.contentOffset.x , pageWidth) == 0) {
        // ページコントロールに現在のページを設定
        NSInteger nextPage = self.scrollView.contentOffset.x / pageWidth;
        if (self.pageControl.currentPage != nextPage) {
            self.pageControl.currentPage = self.scrollView.contentOffset.x / pageWidth;
            [self.scrollView setZoomScale:1.0f];
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {

//    CGFloat pageWidth = self.scrollView.frame.size.width;
//    for (id view in [self.scrollView subviews]) {
//        if ([view isKindOfClass:[UIImageView class]]) {
//            UIImageView *imageView = (UIImageView *)view;
//            if (imageView.frame.origin.x/pageWidth == self.pageControl.currentPage) {
//                return imageView;
//            }
//        }
//    }
    return [[self.scrollView subviews] objectAtIndex:0];
}

#pragma mark - AlbumManagerDelegate

- (void)photoLibraryDidChange {

}

@end
