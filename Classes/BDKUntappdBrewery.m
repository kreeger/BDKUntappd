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

- (NSString *)remoteIdentifierName {
    return @"brewery_id";
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@, breweryName: %@, location: %@ }",
            NSStringFromClass([self class]), self, self.identifier, self.breweryName, self.location[@"brewery_city"]];
}

@end
