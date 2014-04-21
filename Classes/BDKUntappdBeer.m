//
//  BDKUntappdBeer.m
//

#import "BDKUntappdBeer.h"
#import "BDKUntappdCheckin.h"
#import "BDKUntappdPhoto.h"

#import "NSArray+BDKUntappd.h"

@implementation BDKUntappdBeer

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    _distributionKind = BDKUntappdBeerDistributionKindUnknown;
    return self;
}

#pragma mark - BDKUntappdModel

- (void)updateWithDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)dateFormatter {
    [super updateWithDictionary:dictionary dateFormatter:dateFormatter];
    
    if (dictionary[@"beer_active"]) self.active = [dictionary[@"beer_active"] boolValue];
    if (dictionary[@"is_in_production"]) self.active = [dictionary[@"is_in_production"] boolValue];
    
    if (dictionary[@"media"]) {
        self.media = [dictionary[@"media"][@"items"] bdkuntappd_map:^id(id obj) {
            return [BDKUntappdPhoto modelWithDictionary:obj dateFormatter:dateFormatter];
        }];
    }
    if (dictionary[@"checkins"]) {
        self.checkins = [dictionary[@"checkins"][@"items"] bdkuntappd_map:^id(id obj) {
            return [BDKUntappdCheckin modelWithDictionary:obj dateFormatter:dateFormatter];
        }];
    }
}

- (NSDictionary *)remoteMappings {
    return @{@"identifier": @"bid",
             @"authorRating": @"auth_rating",
             @"alcoholByVolume": @"beer_abv",
             @"labelURL": @"beer_label",
             @"name": @"beer_name",
             @"style": @"beer_style",
             @"slug": @"beer_slug",
             @"homebrew": @"is_homebrew",
             @"createdAt": @"created_at",
             @"ratingCount": @"rating_count",
             @"ratingScore": @"rating_score",
             @"totalCount": @"stats/total_count",
             @"monthlyCount": @"stats/monthly_count",
             @"userCount": @"stats/user_count",
             @"totalUserCount": @"stats/total_user_count",
             @"onWishList": @"wish_list",
             @"had": @"has_had",};
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@, name: %@, style: %@, ABV: %@%% }",
            NSStringFromClass([self class]), self, self.identifier, self.name, self.style, self.alcoholByVolume];
}

@end
