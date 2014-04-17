//
//  BDKUntappdCategory.h
//

#import "BDKUntappdModel.h"

@interface BDKUntappdCategory : BDKUntappdModel

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic, getter = isPrimary) BOOL primary;

@end
