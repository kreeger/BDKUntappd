//
//  BDKUntappdBrewery.h
//

#import "BDKUntappdModel.h"

@interface BDKUntappdBrewery : BDKUntappdModel

@property (assign, nonatomic, getter = breweryIsActive) BOOL active;
@property (strong, nonatomic) NSURL *label;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDictionary *contact;
@property (strong, nonatomic) NSString *countryName;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, readonly, nonatomic) NSString *locationDisplay;

@end
