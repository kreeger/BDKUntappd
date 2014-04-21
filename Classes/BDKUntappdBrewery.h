//
//  BDKUntappdBrewery.h
//

#import "BDKUntappdModel.h"

@interface BDKUntappdBrewery : BDKUntappdModel

@property (assign, nonatomic, getter = isActive) BOOL active;
@property (strong, nonatomic) NSURL *labelImage;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *twitterIdentifier;
@property (strong, nonatomic) NSURL *facebookURL;
@property (strong, nonatomic) NSURL *websiteURL;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, readonly, nonatomic) NSString *locationDisplay;

// These fields are populated with data from explicit info calls
@property (strong, nonatomic) NSDictionary *claimedStatus;
@property (strong, nonatomic) NSNumber *beerCount;
@property (strong, nonatomic) NSString *breweryType;
@property (strong, nonatomic) NSString *streetAddress;
@property (strong, nonatomic) NSNumber *ratingCount;
@property (strong, nonatomic) NSNumber *ratingScore;
@property (strong, nonatomic) NSArray *owners;
@property (strong, nonatomic) NSString *breweryDescription;
@property (strong, nonatomic) NSNumber *totalCount;
@property (strong, nonatomic) NSNumber *uniqueCount;
@property (strong, nonatomic) NSNumber *monthlyCount;
@property (strong, nonatomic) NSNumber *weeklyCount;
@property (strong, nonatomic) NSNumber *userCount;
@property (strong, nonatomic) NSArray *media;
@property (strong, nonatomic) NSArray *checkins;
@property (strong, nonatomic) NSArray *beers;

@end
