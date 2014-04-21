//
//  BDKUntappdCheckinResult.h
//

#import "BDKUntappdModel.h"

@class BDKUntappdUser, BDKUntappdBeer, BDKUntappdBrewery, BDKUntappdVenue;

@interface BDKUntappdCheckinResult : BDKUntappdModel

@property (strong, nonatomic) NSString *result;
@property (assign, nonatomic, getter = badgeIsValid) BOOL badgeValid;
@property (strong, nonatomic) NSString *checkinComment;
@property (strong, nonatomic) NSDictionary *stats;
@property (strong, nonatomic) NSDictionary *rating;
@property (strong, nonatomic) BDKUntappdUser *user;
@property (strong, nonatomic) BDKUntappdBeer *beer;
@property (strong, nonatomic) BDKUntappdBrewery *brewery;
@property (strong, nonatomic) BDKUntappdVenue *venue;
@property (strong, nonatomic) NSArray *recommendations;
@property (strong, nonatomic) NSNumber *distance;
@property (strong, nonatomic) NSDictionary *media;
@property (assign, nonatomic, getter = mediaIsAllowed) BOOL mediaAllowed;
@property (strong, nonatomic) NSDictionary *socialSettings;
@property (strong, nonatomic) NSString *sourceAppName;
@property (strong, nonatomic) NSURL *sourceAppWebsite;
@property (strong, nonatomic) NSDictionary *followStatus;
@property (strong, nonatomic) NSArray *promotions;
@property (strong, nonatomic) NSArray *badges;
@property (strong, nonatomic) NSArray *social;

@end
