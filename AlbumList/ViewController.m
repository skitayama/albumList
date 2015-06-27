//
//  ViewController.m
//  AlbumList
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIButton *albumButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAlbumButton:(id)sender {

    [self setupTabController];
}

- (void)setupTabController {

    // アルバム
    UIStoryboard *albumSB = [UIStoryboard storyboardWithName:@"AlbumListView" bundle:[NSBundle mainBundle]];
    UIViewController *albumVC = [albumSB instantiateViewControllerWithIdentifier:@"AlbumListView"];
    UINavigationController *albumNC = [[UINavigationController alloc] initWithRootViewController:albumVC];
    [self presentViewController:albumNC animated:YES completion:nil];
}

// タブ用イメージの生成
- (UIImage *)imageForTabBarWithName:(NSString *)name {

    UIImage* image = [UIImage imageNamed:name];
    if ([image respondsToSelector:@selector(imageWithRenderingMode:)]) {
        return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

@end
