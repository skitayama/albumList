//
//  AlbumListMomentViewController.m
//

#import "AlbumListMomentViewController.h"
#import "AlbumThumbnailCollectionViewCell.h"
#import "AlbumMomentHeaderCollectionReusableView.h"
#import "AlbumGroupedThumbnailViewController.h"

@interface AlbumListMomentViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property AlbumManager *albumManager;

@end

static NSString * const ThumbnailCellIdentifier = @"AlbumThumbnailCollectionViewCell";

@implementation AlbumListMomentViewController

#pragma mark - Lifecycle method

- (void)viewDidLoad {

    [super viewDidLoad];
    // self init
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self settingAlbumManager];
    [self reloadCollectionView];
}

- (void)viewDidLayoutSubviews {

    [super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated {

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

    [self initCollectionView];
    [self setupNavigationItem];
}

- (void)settingAlbumManager {

    if (!self.albumManager) {
        self.albumManager = [AlbumManager sharedInstance];
        self.albumManager.delegate = self;
        [self.albumManager loadMoments];
    }
}

- (void)setupNavigationItem {

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                              target:self
                                              action:@selector(onDoneButton)];
}

- (void)initData {

    // init Data
}

- (void)initCollectionView {

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    UINib *nib = [UINib nibWithNibName:ThumbnailCellIdentifier bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:ThumbnailCellIdentifier];
    [self.collectionView registerClass:[AlbumMomentHeaderCollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"header"];
}

#pragma mark - Handling NavigationBar Buttons

- (void)setEnableDoneButton {

    BOOL enable = YES;
    if ([self.albumManager.selectedMomentThumbnailList count] == 0) {
        enable = NO;
    }
    [self.navigationItem.rightBarButtonItem setEnabled:enable];
}

#pragma mark - action

- (void)onDoneButton {

    UIStoryboard *thumbnailSB = [UIStoryboard storyboardWithName:@"AlbumGroupedThumbnailView" bundle:[NSBundle mainBundle]];
    AlbumGroupedThumbnailViewController *thumbnailVC = (AlbumGroupedThumbnailViewController *)[thumbnailSB instantiateViewControllerWithIdentifier:@"AlbumGroupedThumbnailView"];
    thumbnailVC.isMoment = YES;
    [self.navigationController pushViewController:thumbnailVC animated:YES];
}

#pragma mark - UICollectionView Reload

- (void)reloadCollectionView {

    [self.collectionView reloadData];
    [self setEnableDoneButton];
}

#pragma mark - UICollectionViewDataSource

// セクション数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    NSInteger count = 1;
    if (self.albumManager) {
        count = [self.albumManager.momentList count];
    }
    return count;
}

// セクション内セル数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSInteger count = 0;
    if (self.albumManager) {
        AssetMomentModel *model = [self.albumManager.momentList objectAtIndex:section];
        count = [model.assetModelList count];
    }
    return count;
}

// セル
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    AlbumThumbnailCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:ThumbnailCellIdentifier
                                                                                      forIndexPath:indexPath];
    AssetMomentModel *momentModel = [self.albumManager.momentList objectAtIndex:indexPath.section];
    AssetModel *model = [momentModel.assetModelList objectAtIndex:indexPath.row];
    [cell setAssetModel:model];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if (kind == UICollectionElementKindSectionHeader) {
        AlbumMomentHeaderCollectionReusableView *headerView = (AlbumMomentHeaderCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];

        AssetMomentModel *momentModel = [self.albumManager.momentList objectAtIndex:indexPath.section];
        [headerView.titleLabel setText:[AlbumManager convertedDateStringWithDate:momentModel.date]];

        return headerView;
    } else {
        return nil;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    AssetMomentModel *momentModel = [self.albumManager.momentList objectAtIndex:indexPath.section];
    AssetModel *model = [momentModel.assetModelList objectAtIndex:indexPath.row];
    model.selected = !model.selected;
    [self reloadCollectionView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    // セルサイズを正方形x4に変更
    float size = (self.collectionView.frame.size.width/4.0f) - 3.0f;
    return CGSizeMake(size, size);
}

#pragma mark - AlbumManagerDelegate

// 更新通知
- (void)photoLibraryDidChange {

    [self reloadCollectionView];
}

// ロード完了通知
- (void)didFinishLoadingMomentList {

    [self reloadCollectionView];
}

@end
