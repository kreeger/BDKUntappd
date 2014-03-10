//
//  BDKUntappdBeer.h
//  Pods
//
//  Created by Ben Kreeger on 3/9/14.
//
//

#import "BDKUntappdModel.h"

@interface BDKUntappdBeer : BDKUntappdModel

@property (strong, nonatomic) NSNumber *authorRating;
@property (strong, nonatomic) NSNumber *alcoholByVolume;
@property (assign, nonatomic, getter = isActive) BOOL active;
@property (strong, nonatomic) NSURL *labelURL;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *style;
@property (assign, nonatomic, getter = isOnWishList) BOOL onWishList;

@end
