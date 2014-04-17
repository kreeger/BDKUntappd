//
//  BDKUntappdCategory.m
//

#import "BDKUntappdCategory.h"

@implementation BDKUntappdCategory

#pragma mark - BDKUntappdModel

- (NSDictionary *)remoteMappings {
    return @{@"identifier": @"category_id",
             @"name": @"category_name",
             @"primary": @"is_primary",};
}

#pragma mark - NSDictionary

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@, name: %@, isPrimary: %@ }",
            NSStringFromClass([self class]), self, self.identifier, self.name, self.primary ? @"YES" : @"NO"];
}

@end
