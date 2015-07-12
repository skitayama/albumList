//
//  AppManager.m
//

#import "AppManager.h"

@implementation AppManager

static AppManager *_instance = nil;

+ (void)initialize {
    
    @synchronized(self) {
        if(_instance == nil) {
            _instance = [[AppManager alloc] initInternal];
        }
    }
}

+ (AppManager *)sharedInstance {
    
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
            return _instance;
        }
    }
    return nil;
}

- (id)init {
    
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initInternal {
    
    self = [super init];
    if (self) {
        // init
    }
    
    return self;
}

@end
