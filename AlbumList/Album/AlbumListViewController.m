//
//  AlbumListViewController.m
//

#import "AlbumListViewController.h"
#import "AlbumListTableViewCell.h"
#import "AlbumThumbnailViewController.h"

static NSString * const AlbumListTableViewCellIdentifier = @"AlbumListTableViewCellIdentifier";

@interface AlbumListViewController ()

@property (nonatomic, weak) IBOutlet UITableView *albumTableView;
@property AlbumManager *albumManager;

@end

@implementation AlbumListViewController

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

    [self initTableView];
}

- (void)settingAlbumManager {

    if (!self.albumManager) {
        self.albumManager = [AlbumManager sharedInstance];
        self.albumManager.delegate = self;
        [self.albumManager loadAlbums];
    }
}

- (void)initData {

    // init Data
}

- (void)initTableView {

    self.albumTableView.delegate = self;
    self.albumTableView.dataSource = self;
    self.albumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    UINib *nib = [UINib nibWithNibName:@"AlbumListTableViewCell" bundle:nil];
    [self.albumTableView registerNib:nib forCellReuseIdentifier:AlbumListTableViewCellIdentifier];
}

#pragma mark - UITableViewDataSource

// セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

// セクションに含むセル数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger count = 0;
    if (self.albumManager) {
        count = [self.albumManager.albumList count];
    }
    return count;
}

// セル
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    AlbumListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AlbumListTableViewCellIdentifier];
    if (self.albumManager) {
        AssetCollectionModel *model = [self.albumManager.albumList objectAtIndex:indexPath.row];
        [cell setAssetCollectionModel:model];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.albumManager) {
        AssetCollectionModel *model = [self.albumManager.albumList objectAtIndex:indexPath.row];
        UIStoryboard *thumbnailSB = [UIStoryboard storyboardWithName:@"AlbumThumbnailView" bundle:[NSBundle mainBundle]];
        AlbumThumbnailViewController *thumbnailVC = [thumbnailSB instantiateViewControllerWithIdentifier:@"AlbumThumbnailView"];
        thumbnailVC.selectedModel = model;
        [self.navigationController pushViewController:thumbnailVC animated:YES];
    }
}

#pragma mark - AlbumManagerDelegate

// 更新通知
- (void)photoLibraryDidChange {

    NSLog(@"更新");
}

// ロード完了通知
- (void)didFinishLoadingAlbumList {

    [self.albumTableView reloadData];
}

@end
