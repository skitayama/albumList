//
//  AlbumListViewController.m
//

#import "AlbumListViewController.h"
#import "AlbumListTableViewCell.h"

static NSString * const AlbumListTableViewCellIdentifier = @"AlbumListTableViewCell";

@interface AlbumListViewController ()

@property (nonatomic, weak) IBOutlet UITableView *albumTableView;
@property AlbumManager *albumManager;


// for debug
@property (nonatomic, strong) NSArray *debugDataSource;

@end

@implementation AlbumListViewController

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
    
    // for debug
    self.debugDataSource = @[@"iPhone 4", @"iPhone 4S", @"iPhone 5", @"iPhone 5c", @"iPhone 5s"];

    UINib *nib = [UINib nibWithNibName:AlbumListTableViewCellIdentifier bundle:nil];
    [self.albumTableView registerNib:nib forCellReuseIdentifier:@"Cell"];
}

#pragma mark - UITableViewDataSource

// セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // TimeLine未考慮
    return 1;
}

// セクションに含むセル数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.albumManager.albumList count];
}

// セル
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    AlbumListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    AssetCollectionModel *model = [self.albumManager.albumList objectAtIndex:indexPath.row];
    [cell setAssetCollectionModel:model];
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"select : %lu",indexPath.row);
}

#pragma mark - AlbumManagerDelegate

// 更新通知
- (void)photoLibraryDidChange {

    NSLog(@"更新");
}

// ロード完了通知
- (void)didFinishLoading {

    [self.albumTableView reloadData];
}





@end
