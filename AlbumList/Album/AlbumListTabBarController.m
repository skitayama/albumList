//
//  AlbumListTabBarController.m
//

#import "AlbumListTabBarController.h"
#import "AlbumListViewController.h"
#import "AlbumListMomentViewController.h"

@interface AlbumListTabBarController ()

@end

@implementation AlbumListTabBarController

#pragma mark - Lifecycle method

- (void)viewDidLoad {

    [super viewDidLoad];
    // self init
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    // プライバシー設定をチェック
    [self checkAuthorizationStatus];
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

    [self initTabController];
}

- (void)initData {

    // init For Data
}

- (void)initTabController {

    [self.view setBackgroundColor:[UIColor clearColor]];

    // アルバムタブ
    UIStoryboard *albumSB = [UIStoryboard storyboardWithName:@"AlbumListView" bundle:[NSBundle mainBundle]];
    AlbumListViewController *albumVC = [albumSB instantiateViewControllerWithIdentifier:@"AlbumListView"];
    albumVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"アルバム" image:[UIImage imageNamed:@"AlbumsTabUnselected"] selectedImage:[UIImage imageNamed:@"AlbumsTabSelected"]];
    UINavigationController *albumNC = [[UINavigationController alloc] initWithRootViewController:albumVC];

    // モーメント(写真)タブ
    UIStoryboard *momentSB = [UIStoryboard storyboardWithName:@"AlbumListMomentView" bundle:[NSBundle mainBundle]];
    AlbumListMomentViewController *momentVC = [momentSB instantiateViewControllerWithIdentifier:@"AlbumListMomentView"];
    momentVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"写真" image:[UIImage imageNamed:@"PhotosTabUnselected"] selectedImage:[UIImage imageNamed:@"PhotosTabSelected"]];
    UINavigationController *momentNC = [[UINavigationController alloc] initWithRootViewController:momentVC];
    NSArray *tabs = [NSArray arrayWithObjects:momentNC, albumNC, nil];
    
    [self setViewControllers:tabs animated:NO];
}

// タブ用イメージの生成 
- (UIImage *)imageForTabBarWithName:(NSString *)name {
    
    UIImage* image = [UIImage imageNamed:name];
    if ([image respondsToSelector:@selector(imageWithRenderingMode:)]) {
        return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

#pragma mark - Privacy Setting

- (void)checkAuthorizationStatus {
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        switch (status) {
            case PHAuthorizationStatusAuthorized:       // 許可
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
