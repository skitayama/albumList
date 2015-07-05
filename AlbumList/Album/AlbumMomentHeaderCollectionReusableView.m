//
//  AlbumMomentHeaderCollectionReusableView.m
//

#import "AlbumMomentHeaderCollectionReusableView.h"

@implementation AlbumMomentHeaderCollectionReusableView

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (UILabel *)titleLabel {

    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor darkTextColor];
        _titleLabel.backgroundColor = self.backgroundColor;
        _titleLabel.opaque = YES;
    }
    return _titleLabel;
}

- (void)layoutSubviews {

    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}
@end
