//
//  BDKUntappdBeer.h
//

#import "BDKUntappdModel.h"

typedef NS_ENUM(NSInteger, BDKUntappdBeerDistributionKind) {
    BDKUntappdBeerDistributionKindUnknown,
    BDKUntappdBeerDistributionKindMacro,
    BDKUntappdBeerDistributionKindMicro
};

@class BDKUntappdBrewery;

@interface BDKUntappdBeer : BDKUntappdModel

@property (strong, nonatomic) NSNumber *authorRating;
@property (strong, nonatomic) NSNumber *alcoholByVolume;
@property (assign, nonatomic, getter = isActive) BOOL active;
@property (assign, nonatomic) BDKUntappdBeerDistributionKind distributionKind;
@property (strong, nonatomic) NSURL *labelURL;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *style;
@property (assign, nonatomic, getter = isOnWishList) BOOL onWishList;
@property (strong, nonatomic) BDKUntappdBrewery *brewery;
@property (assign, nonatomic, getter = hasHad) BOOL had;
@property (strong, nonatomic) NSNumber *totalCount;
@property (strong, nonatomic) NSNumber *yourCount;

// Detail properties
@property (strong, nonatomic) NSString *slug;
@property (assign, nonatomic, getter = isHomebrew) BOOL homebrew;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSNumber *ratingScore;
@property (strong, nonatomic) NSNumber *ratingCount;
@property (strong, nonatomic) NSNumber *monthlyCount;
@property (strong, nonatomic) NSNumber *userCount;
@property (strong, nonatomic) NSNumber *totalUserCount;
@property (strong, nonatomic) NSArray *media;
@property (strong, nonatomic) NSArray *checkins;

@end