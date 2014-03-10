//
//  BDKUntappdVenue.m
//  Pods
//
//  Created by Ben Kreeger on 3/9/14.
//
//

#import "BDKUntappdVenue.h"

@implementation BDKUntappdVenue

#pragma mark - BDKUntappdModel

- (NSString *)remoteIdentifierName {
    return @"venue_id";
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@, venueName: %@, primaryCategory: %@, location: %@ }",
            NSStringFromClass([self class]), self, self.identifier, self.venueName, self.primaryCategory, self.location[@"venue_city"]];
}

@end
