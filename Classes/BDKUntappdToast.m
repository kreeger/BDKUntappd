//
//  BDKUntappdToast.m
//

#import "BDKUntappdToast.h"

@implementation BDKUntappdToast

#pragma mark - BDKUntappdModel

- (NSDictionary *)remoteMappings {
    return @{@"user": @"user",
             @"identifier": @"like_id",
             @"likeOwner": @"like_owner",
             @"createdAt": @"created_at",};
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@, createdAt: %@ }",
            NSStringFromClass([self class]), self, self.identifier, self.createdAt];
}

@end
