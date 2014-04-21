//
//  BDKUntappdVenue.h
//

#import "BDKUntappdModel.h"

@interface BDKUntappdVenue : BDKUntappdModel

@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSString *twitterIdentifier;
@property (strong, nonatomic) NSURL *venueURL;
@property (strong, nonatomic) NSString *foursquareIdentifier;
@property (strong, nonatomic) NSURL *foursquareURL;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSString *streetAddress;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *parentCategoryIdentifier;
@property (strong, nonatomic) NSString *primaryCategory;
@property (strong, nonatomic) NSURL *venueIconLargeURL;
@property (strong, nonatomic) NSURL *venueIconMediumURL;
@property (strong, nonatomic) NSURL *venueIconSmallURL;
@property (strong, nonatomic) NSString *name;

// Detailed fields
@property (strong, nonatomic) NSNumber *totalCount;
@property (strong, nonatomic) NSNumber *userCount;
@property (strong, nonatomic) NSNumber *totalUserCount;
@property (strong, nonatomic) NSArray *media;
@property (strong, nonatomic) NSArray *checkins;
@property (strong, nonatomic) NSArray *topBeers;

@end
