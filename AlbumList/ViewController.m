//
//  ViewController.m
//  AlbumList
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIButton *albumButton;
@property (nonatomic) UITabBarController *tabController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingTabController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)settingTabController {

    self.tabController = [[UITabBarController alloc] init];
    self.tabController.delegate = self;
}


- (IBAction)onAlbumButton:(id)sender {
    
    [self setupTabController];
    [self presentViewController:self.tabController animated:YES completion:nil];
}

- (void)setupTabController {
    // 画像一覧サムネイル
    UIStoryboard *thumbnailSB = [UIStoryboard storyboardWithName:@"AlbumThumbnailView" bundle:[NSBundle mainBundle]];
    UIViewController *thumbnailVC = [thumbnailSB instantiateViewControllerWithIdentifier:@"AlbumThumbnailView"];
    thumbnailVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Photos"
                                                           image:[self imageForTabBarWithName:@"AlbumTab"]
                                                             tag:0];
    UINavigationController *thumbnailNC = [[UINavigationController alloc] initWithRootViewController:thumbnailVC];
    
    // アルバム
    UIStoryboard *albumSB = [UIStoryboard storyboardWithName:@"AlbumListView" bundle:[NSBundle mainBundle]];
    UIViewController *albumVC = [albumSB instantiateViewControllerWithIdentifier:@"AlbumListView"];
    albumVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Albums"
                                                       image:[self imageForTabBarWithName:@"AlbumTab"]
                                                         tag:1];
    UINavigationController *albumNC = [[UINavigationController alloc] initWithRootViewController:albumVC];
    
    // タブ設定
    NSArray *tabs = [NSArray arrayWithObjects:thumbnailNC, albumNC, nil];
    [self.tabController setViewControllers:tabs animated:NO];
}

// タブ用イメージの生成
- (UIImage *)imageForTabBarWithName:(NSString *)name {

    UIImage* image = [UIImage imageNamed:name];
    if ([image respondsToSelector:@selector(imageWithRenderingMode:)]) {
        return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

- (void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSLog(@"tap:%ld",viewController.tabBarItem.tag);
}

@end
