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

- (NSString *)remoteIdentifierName {
    return @"bid";
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@, beerName: %@, beerStyle: %@ }",
            NSStringFromClass([self class]), self, self.identifier, self.beerName, self.beerStyle];
}

@end
