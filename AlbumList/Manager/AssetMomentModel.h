//
//  AssetMomentModel.h
//

#import <Foundation/Foundation.h>

@interface AssetMomentModel : NSObject

@property (nonatomic, strong) NSMutableArray *assetModelList;   // AssetModelクラスのリスト
@property (nonatomic) NSDate *date;                             // Moment内の最終作成日

@end
