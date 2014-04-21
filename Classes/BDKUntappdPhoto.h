//
//  BDKUntappdPhoto.h
//

#import "BDKUntappdModel.h"

@interface BDKUntappdPhoto : BDKUntappdModel

@property (strong, nonatomic) NSURL *smallPhoto;
@property (strong, nonatomic) NSURL *mediumPhoto;
@property (strong, nonatomic) NSURL *largePhoto;
@property (strong, nonatomic) NSURL *originalPhoto;

@end
