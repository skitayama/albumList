//
//  AlbumGroupedThumbnailViewController.m
//

#import "AlbumGroupedThumbnailViewController.h"
#import "AlbumThumbnailCollectionViewCell.h"
#import "AlbumPreviewViewController.h"

@interface AlbumGroupedThumbnailViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property AlbumManager *albumManager;

@end

static NSString * const GroupedThumbnailCellIdentifier = @"AlbumThumbnailCollectionViewCell";

@implementation AlbumGroupedThumbnailViewController

#pragma mark - Lifecycle method

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // self init
    [self initView];
    [self settingAlbumManager];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
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
    
    // initCollectionView
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    UINib *nib = [UINib nibWithNibName:GroupedThumbnailCellIdentifier bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:GroupedThumbnailCellIdentifier];
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
        count = [self.albumManager.selectedThumbnailList count];
    }
    return count;
}

// セル
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AlbumThumbnailCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:GroupedThumbnailCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    AssetModel *model = [self.albumManager.selectedThumbnailList objectAtIndex:indexPath.row];
    [cell setAssetModel:model];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //
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
    [self.navigationController pushViewController:previewVC animated:YES];
}

- (void)didTapSelectedImage:(AssetModel *)model {

    model.selected = !model.selected;
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
