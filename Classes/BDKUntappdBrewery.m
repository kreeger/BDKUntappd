//
//  BDKUntappdBrewery.m
//  Pods
//
//  Created by Ben Kreeger on 3/9/14.
//
//

#import "BDKUntappdBrewery.h"

@implementation BDKUntappdBrewery

#pragma mark - BDKUntappdModel

- (NSDictionary *)remoteMappings {
    return @{@"active": @"brewery_active",
             @"identifier": @"brewery_id",
             @"label": @"brewery_label",
             @"name": @"brewery_name",
             @"contact": @"contact",
             @"countryName": @"country_name",
             @"city": @"location/brewery_city",
             @"state": @"location/brewery_state",
             @"latitude": @"location/lat",
             @"longitude": @"location/lng"};
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@, breweryName: %@, location: %@, %@ }",
            NSStringFromClass([self class]), self, self.identifier, self.name, self.city, self.state];
}

@end
