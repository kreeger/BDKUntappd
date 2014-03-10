//
//  BDKUntappdBeer.m
//  Pods
//
//  Created by Ben Kreeger on 3/9/14.
//
//

#import "BDKUntappdBeer.h"

@implementation BDKUntappdBeer

#pragma mark - BDKUntappdModel

- (NSDictionary *)remoteMappings {
    return @{@"authorRating": @"auth_rating",
             @"alcoholByVolume": @"beer_abv",
             @"active": @"beer_active",
             @"labelURL": @"beer_label",
             @"name": @"beer_name",
             @"style": @"beer_style",
             @"identifier": @"bid",
             @"onWishList": @"wish_list",};
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@, name: %@, style: %@, ABV: %@%% }",
            NSStringFromClass([self class]), self, self.identifier, self.name, self.style, self.alcoholByVolume];
}

@end
