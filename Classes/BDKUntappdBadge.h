//
//  BDKUntappdBadge.h
//

#import "BDKUntappdModel.h"

@interface BDKUntappdBadge : BDKUntappdModel

@property (strong, nonatomic) NSNumber *userBadgeIdentifier;
@property (strong, nonatomic) NSNumber *checkinIdentifier;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *badgeDescription;
@property (strong, nonatomic) NSString *hint;
@property (assign, nonatomic, getter = isActive) BOOL active;
@property (strong, nonatomic) NSDictionary *media;
@property (strong, nonatomic) NSDate *createdAt;
@property (assign, nonatomic, getter = isLevel) BOOL level;
@property (strong, nonatomic) NSArray *levels;

@end
