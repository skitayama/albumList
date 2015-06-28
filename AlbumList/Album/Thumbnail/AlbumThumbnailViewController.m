//
//  AlbumThumbnailViewController.m
//

#import "AlbumThumbnailViewController.h"
#import "AlbumThumbnailCollectionViewCell.h"

@interface AlbumThumbnailViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIToolbar *albumToolBar;
@property AlbumManager *albumManager;

@end

static NSString * const ThumbnailCellIdentifier = @"AlbumThumbnailCollectionViewCell";

@implementation AlbumThumbnailViewController

#pragma mark - Lifecycle method

- (void)viewDidLoad {

    [super viewDidLoad];
    // self init
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self reloadCollectionView];
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
    [self setupNavigationItem];
    [self setupAlbumToolBar];
}

- (void)settingAlbumManager {
    
    if (!self.albumManager) {
        self.albumManager = [AlbumManager sharedInstance];
        self.albumManager.delegate = self;
        // nilは全イメージ取得モード
        [self.albumManager loadThumbnailListWithAssetCollectionModel:_selectedModel];
    }
}

- (void)setupNavigationItem {

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                              target:self
                                              action:@selector(onDoneButton)];
}

- (void)setupAlbumToolBar {

    UIBarButtonItem *allSelectButton = [[UIBarButtonItem alloc] initWithTitle:@"全選択"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(onAllSelectButton)];
    [self.albumToolBar setItems:[NSArray arrayWithObjects:allSelectButton, nil]];
}

- (void)initData {
    
    // init Data
}

- (void)initCollectionView {

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    UINib *nib = [UINib nibWithNibName:ThumbnailCellIdentifier bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:ThumbnailCellIdentifier];
}

#pragma mark - Handling NavigationBar Buttons

- (void)setEnableDoneButton {

    BOOL enable = YES;
    if ([self.albumManager.selectedThumbnailList count] == 0) {
        enable = NO;
    }
    [self.navigationItem.rightBarButtonItem setEnabled:enable];
}

- (void)setEnableAllSelectButton {
    
    BOOL enable = YES;
    if ([self.albumManager.selectedThumbnailList count] == [self.albumManager.thumbnailList count]) {
        enable = NO;
    }

    // 今はツールバーに1個しかないので、一括でDisableにする。
    for(UIBarButtonItem *button in [self.albumToolBar items]) {
        [button setEnabled:enable];
    }
}

#pragma mark - action

- (void)onDoneButton {
    
    UIStoryboard *thumbnailSB = [UIStoryboard storyboardWithName:@"AlbumGroupedThumbnailView" bundle:[NSBundle mainBundle]];
    UIViewController *thumbnailVC = [thumbnailSB instantiateViewControllerWithIdentifier:@"AlbumGroupedThumbnailView"];
    [self.navigationController pushViewController:thumbnailVC animated:YES];
}

- (void)onAllSelectButton {

    for (AssetModel *model in self.albumManager.thumbnailList) {
        model.selected = YES;
    }
    [self reloadCollectionView];
}

#pragma mark - UICollectionView Reload

- (void)reloadCollectionView {

    [self.collectionView reloadData];
    [self setEnableDoneButton];
    [self setEnableAllSelectButton];
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
        count = [self.albumManager.thumbnailList count];
    }
    return count;
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
    [self reloadCollectionView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    // セルサイズを正方形x4に変更
    float size = (self.collectionView.frame.size.width/4.0f) - 2.0f;
    return CGSizeMake(size, size);
}

#pragma mark - AlbumManagerDelegate

// 更新通知
- (void)photoLibraryDidChange {

    [self reloadCollectionView];
}

// ロード完了通知
- (void)didFinishLoadingThumbnailList {

    [self reloadCollectionView];
}

@end
