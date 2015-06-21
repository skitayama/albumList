//
//  AlbumThumbnailViewController.m
//

#import "AlbumThumbnailViewController.h"
#import "AlbumThumbnailCollectionViewCell.h"

@interface AlbumThumbnailViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property AlbumManager *albumManager;

@end

static NSString * const ThumbnailCellIdentifier = @"AlbumThumbnailCollectionViewCell";

@implementation AlbumThumbnailViewController

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
    [self setupNavigationItem];
}

- (void)settingAlbumManager {
    
    if (!self.albumManager) {
        self.albumManager = [AlbumManager sharedInstance];
        self.albumManager.delegate = self;
        // nilは全イメージ取得モード
        [self.albumManager loadThumbnailListWithAssetCollectionModel:nil];
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

    // initCollectionView
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    UINib *nib = [UINib nibWithNibName:ThumbnailCellIdentifier bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:ThumbnailCellIdentifier];
}

#pragma mark - action

- (void)onDoneButton {
    
    UIStoryboard *thumbnailSB = [UIStoryboard storyboardWithName:@"AlbumGroupedThumbnailView" bundle:[NSBundle mainBundle]];
    UIViewController *thumbnailVC = [thumbnailSB instantiateViewControllerWithIdentifier:@"AlbumGroupedThumbnailView"];
    [self.navigationController pushViewController:thumbnailVC animated:YES];
}

#pragma mark - UICollectionViewDataSource

// セクション数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

// セクション内セル数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.albumManager.thumbnailList count];
}

// セル
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AlbumThumbnailCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:ThumbnailCellIdentifier
                                                                                      forIndexPath:indexPath];
    AssetModel *model = [self.albumManager.thumbnailList objectAtIndex:indexPath.row];
    [cell setAssetModel:model];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    AssetModel *model = [self.albumManager.thumbnailList objectAtIndex:indexPath.row];
    model.selected = !model.selected;
    AlbumThumbnailCollectionViewCell *cell = (AlbumThumbnailCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setSelectedImage:model.selected];
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    // セルサイズを正方形x4に変更
    float size = self.collectionView.frame.size.width/4;
    return CGSizeMake(size, size);
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