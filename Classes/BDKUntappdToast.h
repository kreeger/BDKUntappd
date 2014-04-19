//
//  BDKUntappdToast.h
//

#import "BDKUntappdModel.h"

@class BDKUntappdUser;

@interface BDKUntappdToast : BDKUntappdModel

@property (strong, nonatomic) BDKUntappdUser *user;
@property (assign, nonatomic, getter = isLikeOwner) BOOL likeOwner;
@property (strong, nonatomic) NSDate *createdAt;

@end
