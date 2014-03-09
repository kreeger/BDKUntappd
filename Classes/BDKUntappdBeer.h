//
//  BDKUntappdBeer.h
//  Pods
//
//  Created by Ben Kreeger on 3/9/14.
//
//

#import "BDKUntappdModel.h"

@interface BDKUntappdBeer : BDKUntappdModel

@property (strong, nonatomic) NSNumber *authRating;
@property (strong, nonatomic) NSNumber *beerAbv;
@property (assign, nonatomic, getter = beerIsActive) BOOL beerActive;
@property (strong, nonatomic) NSURL *beerLabel;
@property (strong, nonatomic) NSString *beerName;
@property (strong, nonatomic) NSString *beerStyle;
@property (assign, nonatomic, getter = isOnWishList) BOOL wishList;

@end
