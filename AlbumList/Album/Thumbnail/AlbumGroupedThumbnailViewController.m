//
//  AlbumGroupedThumbnailViewController.m
//

#import "AlbumGroupedThumbnailViewController.h"
#import "AlbumThumbnailCollectionViewCell.h"
#import "AlbumPreviewViewController.h"

@interface AlbumGroupedThumbnailViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSMutableArray *selectList;
@property AlbumManager *albumManager;

@end

static NSString * const GroupedThumbnailCellIdentifier = @"AlbumThumbnailCollectionViewCell";

@implementation AlbumGroupedThumbnailViewController

#pragma mark - Lifecycle method

- (void)viewDidLoad {

    [super viewDidLoad];
    // self init
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self settingAlbumManager];
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

- (void)initCollectionView {

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    UINib *nib = [UINib nibWithNibName:GroupedThumbnailCellIdentifier bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:GroupedThumbnailCellIdentifier];
}

#pragma mark - getter

- (NSMutableArray *)selectList {

    if (self.isMoment) {
        return self.albumManager.selectedMomentThumbnailList;
    } else {
        return self.albumManager.selectedThumbnailList;
    }
}

#pragma mark - UICollectionViewDataSource

// セクション数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}

// セクション内セル数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSInteger count = 0;
    if (self.albumManager) {
        count = [self.selectList count];
    }
    return count;
}

// セル
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    AlbumThumbnailCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:GroupedThumbnailCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    AssetModel *model = [self.selectList objectAtIndex:indexPath.row];
    [cell setAssetModel:model mode:ThumbnailCollectionViewCellModeGrouped];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    // 特に何もしない。
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    // セルサイズを正方形x4に変更
    float size = self.collectionView.frame.size.width/4;
    return CGSizeMake(size, size);
}

#pragma mark - AlbumThumbnailCollectionViewCellDelegate

- (void)didTapThumbnailImage:(AssetModel *)model {

    UIStoryboard *previewSB = [UIStoryboard storyboardWithName:@"AlbumPreviewView" bundle:[NSBundle mainBundle]];
    AlbumPreviewViewController *previewVC = [previewSB instantiateViewControllerWithIdentifier:@"AlbumPreviewView"];
    previewVC.isMoment = self.isMoment;
    [self.navigationController pushViewController:previewVC animated:YES];
}

- (void)didTapSelectedImage:(AssetModel *)model {

    model.selected = !model.selected;
    // 選択しているものがなくなればpopする
    if ([self.selectList count] <= 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.collectionView reloadData];
}

#pragma mark - AlbumManagerDelegate

// 更新通知
- (void)photoLibraryDidChange {
    
    [self.collectionView reloadData];
}

// ロード完了通知
- (void)didFinishLoading {
    
    [self.collectionView reloadData];
}


@end
