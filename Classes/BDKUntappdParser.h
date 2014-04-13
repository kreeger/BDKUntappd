//
//  BDKUntappdParser.h
//

@import Foundation;

@class BDKUntappdCheckin, BDKUntappdBeer, BDKUntappdBrewery, BDKUntappdUser, BDKUntappdVenue;

@interface BDKUntappdParser : NSObject

- (NSArray *)checkinsFromResponseObject:(id)responseObject;
- (BDKUntappdCheckin *)checkinFromResponseObject:(id)responseObject;

- (NSArray *)beersFromResponseObject:(id)responseObject;
- (BDKUntappdBeer *)beerFromResponseObject:(id)responseObject;

- (BDKUntappdBrewery *)breweryFromResponseObject:(id)responseObject;

- (NSArray *)usersFromResponseObject:(id)responseObject;
- (BDKUntappdUser *)userFromResponseObject:(id)responseObject;

- (BDKUntappdVenue *)venueFromResponseObject:(id)responseObject;

- (NSArray *)badgesFromResponseObject:(id)responseObject;

@end
