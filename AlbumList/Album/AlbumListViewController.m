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

// for debug
@property (nonatomic, strong) NSArray *debugDataSource;

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

    // プライバシー設定をチェック
    [self checkPrivacySettingStatus];
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

#pragma mark - Privacy Setting

- (void)checkPrivacySettingStatus {

    if ([AlbumManager isPhotoLibraryAccessNotDetermined]) {
        // 初回に許可を促すメッセージ
        [self showAlertPhotoAccessNotDetermined];
    } else {
        // 初回でなければ拒否チェック
        [self checkAuthorizationStatus];
    }
}

- (void)checkAuthorizationStatus {

    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        switch (status) {
            case PHAuthorizationStatusAuthorized:       // 許可
                [self settingAlbumManager];
                break;
            case PHAuthorizationStatusDenied:           // 拒否
                [self showAlertPhotoAccessDenied];
                break;
            case PHAuthorizationStatusRestricted:       // 機能制限
                [self showAlertPhotoAccessRestricted];
                break;
            default:
                break;
        }
    }];
}

- (void)showAlertPhotoAccessNotDetermined {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"PhotoLibraryAccessNotDeterminedTitle"
                                                                   message:@"PhotoLibraryAccessNotDeterminedMsg"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                [self checkAuthorizationStatus];
                                            }]];
}

- (void)showAlertPhotoAccessDenied {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"PhotoLibraryAccessDeniedTitle"
                                                                   message:@"PhotoLibraryAccessDeniedMsg"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"openSetting"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                            }]];
}

- (void)showAlertPhotoAccessRestricted {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"PhotoLibraryAccessRestrictedTitle"
                                                                   message:@"PhotoLibraryAccessRestrictedMsg"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"openSetting"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                            }]];
}

@end
