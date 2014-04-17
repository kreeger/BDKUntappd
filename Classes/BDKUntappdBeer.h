//
//  BDKUntappdBeer.h
//

#import "BDKUntappdModel.h"

@class BDKUntappdBrewery;

@interface BDKUntappdBeer : BDKUntappdModel

@property (strong, nonatomic) NSNumber *authorRating;
@property (strong, nonatomic) NSNumber *alcoholByVolume;
@property (assign, nonatomic, getter = isActive) BOOL active;
@property (strong, nonatomic) NSURL *labelURL;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *style;
@property (assign, nonatomic, getter = isOnWishList) BOOL onWishList;
@property (strong, nonatomic) BDKUntappdBrewery *brewery;

@end
