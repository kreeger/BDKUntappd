//
//  BDKUntappdCheckinResult.m
//

#import "BDKUntappdCheckinResult.h"
#import "BDKUntappdCheckin.h"
#import "BDKUntappdBeer.h"
#import "BDKUntappdBrewery.h"
#import "BDKUntappdBadge.h"

@implementation BDKUntappdCheckinResult

- (Class)badges_class {
    return [BDKUntappdBadge class];
}

#pragma mark - BDKUntappdModel

- (void)updateWithDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)dateFormatter {
    [super updateWithDictionary:dictionary dateFormatter:dateFormatter];
    self.beer.brewery = [[BDKUntappdBrewery alloc] initWithDictionary:dictionary[@"brewery"] dateFormatter:dateFormatter];
}

- (NSDictionary *)remoteMappings {
    return @{@"result": @"result",
             @"badgeValid": @"badge_valid",
             @"identifier": @"checkin_id",
             @"checkinComment": @"checkin_comment",
             @"stats": @"stats",
             @"rating": @"rating",
             @"user": @"user",
             @"beer": @"beer",
             @"brewery": @"brewery",
             @"venue": @"venue",
             @"recommendations": @"recommendations",
             @"distance": @"distance",
             @"media": @"media",
             @"mediaAllowed": @"media_allowed",
             @"socialSettings": @"social_settings",
             @"sourceAppName": @"source/app_name",
             @"sourceAppWebsite": @"source/app_website",
             @"followStatus": @"follow_status",
             @"promotions": @"promotions",
             @"badges": @"badges",
             @"social": @"social"};
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@, result: %@ }",
            NSStringFromClass([self class]), self, self.identifier, self.result];
}

@end
