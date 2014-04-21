//
//  BDKUntappdBrewery.m
//

#import "BDKUntappdBrewery.h"
#import "BDKUntappdCheckin.h"
#import "BDKUntappdBeer.h"

#import "NSArray+BDKUntappd.h"

@interface BDKUntappdBrewery ()

@property (strong, readwrite, nonatomic) NSString *locationDisplay;

@end

@implementation BDKUntappdBrewery

#pragma mark - BDKUntappdModel

- (void)updateWithDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)dateFormatter {
    [super updateWithDictionary:dictionary dateFormatter:dateFormatter];
    
    NSMutableArray *locationComponents = [NSMutableArray arrayWithCapacity:3];
    if (self.city && ![self.city isEqualToString:@""]) [locationComponents addObject:self.city];
    if (self.state && ![self.state isEqualToString:@""]) [locationComponents addObject:self.state];
    if (self.country && ![self.country isEqualToString:@""]) [locationComponents addObject:self.country];
    self.locationDisplay = [locationComponents componentsJoinedByString:@", "];
    
    if (dictionary[@"brewery_active"]) self.active = [dictionary[@"brewery_active"] boolValue];
    if (dictionary[@"brewery_in_production"]) self.active = [dictionary[@"brewery_in_production"] boolValue];
    
    self.latitude = dictionary[@"location"][@"lat"] ?: dictionary[@"location"][@"brewery_lat"];
    self.longitude = dictionary[@"location"][@"lng"] ?: dictionary[@"location"][@"brewry_lng"];
    
    if (dictionary[@"owners"]) {
        self.owners = [dictionary[@"owners"][@"items"] bdkuntappd_map:^id(id obj) {
            return [BDKUntappdBrewery modelWithDictionary:obj dateFormatter:dateFormatter];
        }];
    }
    if (dictionary[@"checkins"]) {
        self.checkins = [dictionary[@"checkins"][@"items"] bdkuntappd_map:^id(id obj) {
            return [BDKUntappdCheckin modelWithDictionary:obj dateFormatter:dateFormatter];
        }];
    }
    if (dictionary[@"beer_list"]) {
        self.beers = [dictionary[@"beer_list"][@"items"] bdkuntappd_map:^id(id obj) {
            BDKUntappdBeer *beer = [BDKUntappdBeer modelWithDictionary:obj[@"beer"] dateFormatter:dateFormatter];
            beer.had = obj[@"has_had"];
            beer.totalCount = obj[@"total_count"];
            beer.brewery = [BDKUntappdBrewery modelWithDictionary:obj[@"brewery"] dateFormatter:dateFormatter];
            return beer;
        }];
    }
}

- (NSDictionary *)remoteMappings {
    return @{@"identifier": @"brewery_id",
             @"labelImage": @"brewery_label",
             @"name": @"brewery_name",
             @"country": @"country_name",
             @"claimedStatus": @"claimed_status",
             @"beerCount": @"beer_count",
             @"twitterIdentifier": @"contact/twitter",
             @"facebookURL": @"contact/facebook",
             @"websiteURL": @"contact/url",
             @"breweryType": @"brewery_type",
             @"streetAddress": @"location/brewery_address",
             @"city": @"location/brewery_city",
             @"state": @"location/brewery_state",
             @"ratingCount": @"rating/count",
             @"ratingScore": @"rating/rating_score",
             @"breweryDescription": @"brewery_description",
             @"totalCount": @"stats/total_count",
             @"uniqueCount": @"stats/unique_count",
             @"monthlyCount": @"stats/monthly_count",
             @"weeklyCount": @"stats/weekly_count",
             @"userCount": @"stats/user_count",
             @"media": @"media"
             };
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@, breweryName: %@, location: %@, %@ }",
            NSStringFromClass([self class]), self, self.identifier, self.name, self.city, self.state];
}

@end
