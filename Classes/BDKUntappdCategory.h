//
//  BDKUntappdCategory.h
//  Pods
//
//  Created by Ben Kreeger on 3/10/14.
//
//

#import "BDKUntappdModel.h"

@interface BDKUntappdCategory : BDKUntappdModel

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic, getter = isPrimary) BOOL primary;

@end
