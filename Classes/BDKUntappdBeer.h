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

@end
