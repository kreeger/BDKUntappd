//
//  BDKUntappdVenue.m
//

#import "BDKUntappdVenue.h"
#import "BDKUntappdCategory.h"
#import "BDKUntappdCheckin.h"
#import "BDKUntappdBeer.h"
#import "BDKUntappdBrewery.h"
#import "BDKUntappdPhoto.h"

#import "NSArray+BDKUntappd.h"

@implementation BDKUntappdVenue

#pragma mark - BDKUntappdModel

- (void)updateWithDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)dateFormatter {
    [super updateWithDictionary:dictionary dateFormatter:dateFormatter];
    if (dictionary[@"categories"]) {
        self.categories = [dictionary[@"categories"][@"items"] bdkuntappd_map:^id(id obj) {
            return [BDKUntappdCategory modelWithDictionary:obj dateFormatter:dateFormatter];
        }];
    }
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
    if (dictionary[@"top_beers"]) {
        self.topBeers = [dictionary[@"beer_list"][@"items"] bdkuntappd_map:^id(id obj) {
            BDKUntappdBeer *beer = [BDKUntappdBeer modelWithDictionary:obj[@"beer"] dateFormatter:dateFormatter];
            beer.yourCount = obj[@"your_count"];
            beer.totalCount = obj[@"total_count"];
            beer.brewery = [BDKUntappdBrewery modelWithDictionary:obj[@"brewery"] dateFormatter:dateFormatter];
            return beer;
        }];
    }
}

- (NSDictionary *)remoteMappings {
    return @{@"twitterIdentifier": @"contact/twitter",
             @"venueURL": @"contact/venue_url",
             @"foursquareIdentifier": @"foursqaure/foursquare_id",
             @"foursquareURL": @"foursquare/foursquare_url",
             @"latitude": @"location/lat",
             @"longitude": @"location/lng",
             @"streetAddress": @"location/venue_address",
             @"city": @"location/venue_city",
             @"state": @"location/venue_state",
             @"parentCategoryIdentifier": @"parent_category_id",
             @"primaryCategory": @"primary_category",
             @"venueIconLargeURL": @"venue_icon/lg",
             @"venueIconMediumURL": @"venue_icon/md",
             @"venueIconSmallURL": @"venue_icon/sm",
             @"identifier": @"venue_id",
             @"name": @"venue_name",
             @"totalCount": @"stats/total_count",
             @"userCount": @"stats/user_count",
             @"totalUserCount": @"stats/total_user_count",};
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@, name: %@, primaryCategory: %@, location: %@, %@ }",
            NSStringFromClass([self class]), self, self.identifier, self.name, self.primaryCategory,
            self.city, self.state];
}

@end
