//
//  BDKUntappdVenue.m
//

#import "BDKUntappdVenue.h"

#import "BDKUntappdCategory.h"

@implementation BDKUntappdVenue

- (Class)categories_class {
    return [BDKUntappdCategory class];
}

#pragma mark - BDKUntappdModel

- (NSDictionary *)remoteMappings {
    return @{@"categories": @"categories",
             @"twitterName": @"contact/twitter",
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
             @"name": @"venue_name",};
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@, name: %@, primaryCategory: %@, location: %@, %@ }",
            NSStringFromClass([self class]), self, self.identifier, self.name, self.primaryCategory,
            self.city, self.state];
}

@end
