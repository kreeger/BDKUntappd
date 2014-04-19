//
//  BDKUntappdParser.h
//

@import Foundation;

@class BDKUntappdCheckin, BDKUntappdCheckinResult, BDKUntappdBeer, BDKUntappdBrewery, BDKUntappdToast, BDKUntappdUser,
       BDKUntappdVenue;

@interface BDKUntappdParser : NSObject

- (NSArray *)checkinsFromResponseObject:(id)responseObject;
- (BDKUntappdCheckin *)checkinFromResponseObject:(id)responseObject;
- (BDKUntappdCheckinResult *)checkinResultFromCheckinCreationResponseObject:(id)responseObject;

- (NSArray *)beersFromResponseObject:(id)responseObject;
- (NSArray *)beersAndBreweriesFromResponseObject:(id)responseObject;
- (NSArray *)beersFromTrendingResponseObject:(id)responseObject;
- (BDKUntappdBeer *)beerFromResponseObject:(id)responseObject;

- (NSArray *)breweriesFromResponseObject:(id)responseObject;
- (BDKUntappdBrewery *)breweryFromResponseObject:(id)responseObject;

- (BDKUntappdToast *)toastsFromResponseObject:(id)responseObject;

- (NSArray *)usersFromResponseObject:(id)responseObject;
- (BDKUntappdUser *)userFromResponseObject:(id)responseObject;

- (BDKUntappdVenue *)venueFromResponseObject:(id)responseObject;

- (NSArray *)badgesFromResponseObject:(id)responseObject;

@end
