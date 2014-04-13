//
//  BDKUntappdBadge.m
//

#import "BDKUntappdBadge.h"

@implementation BDKUntappdBadge

#pragma mark - BDKUntappdModel

- (NSDictionary *)remoteMappings {
    return @{@"userBadgeIdentifier": @"user_badge_id",
             @"checkinIdentifier": @"checkin_id",
             @"name": @"badge_name",
             @"badgeDescription": @"badge_description",
             @"hint": @"badge_hint",
             @"active": @"badge_active_status",
             @"identifier": @"badge_id",
             @"media": @"media",
             @"createdAt": @"created_at",
             @"isLevel": @"level",
             @"levels": @"levels",};
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@, name: %@, badgeDescription: %@ }",
            NSStringFromClass([self class]), self, self.identifier, self.name, self.badgeDescription];
}

@end
