//
//  BDKUntappdPhoto.m
//

#import "BDKUntappdPhoto.h"

@implementation BDKUntappdPhoto

#pragma mark - BDKUntappdPhoto

- (NSDictionary *)remoteMappings {
    return @{@"identifier": @"photo_id",
             @"smallPhoto": @"photo_img_sm",
             @"mediumPhoto": @"photo_img_md",
             @"largePhoto": @"photo_img_lg",
             @"originalPhoto": @"photo_img_og",};
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@, originalPhoto: %@ }",
            NSStringFromClass([self class]), self, self.identifier, self.originalPhoto];
}

@end
