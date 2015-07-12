//
//  AppManager.h
//  testManager
//

#import <Foundation/Foundation.h>

@protocol AppManagerDelegate <NSObject>

- (void)notification;

@end

@interface AppManager : NSObject

@property id<AppManagerDelegate> delegate;

+ (AppManager *)sharedInstance;
- (id)init UNAVAILABLE_ATTRIBUTE;

@end
