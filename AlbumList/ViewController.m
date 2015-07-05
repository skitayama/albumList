//
//  ViewController.m
//  AlbumList
//

#import "ViewController.h"
#import "AlbumListTabBarController.h"

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
    AlbumListTabBarController *albumTC = [[AlbumListTabBarController alloc] init];
    [self presentViewController:albumTC animated:YES completion:nil];
}

@end
