//
//  BDKUntappdVenue.h
//  Pods
//
//  Created by Ben Kreeger on 3/9/14.
//
//

#import "BDKUntappdModel.h"

@interface BDKUntappdVenue : BDKUntappdModel

@property (strong, nonatomic) NSArray *categories;
@property (readonly, strong, nonatomic) Class categories_class;
@property (strong, nonatomic) NSString *twitterName;
@property (strong, nonatomic) NSURL *venueURL;
@property (strong, nonatomic) NSString *foursquareIdentifier;
@property (strong, nonatomic) NSURL *foursquareURL;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSString *streetAddress;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *parentCategoryIdentifier;
@property (strong, nonatomic) NSString *primaryCategory;
@property (strong, nonatomic) NSURL *venueIconLargeURL;
@property (strong, nonatomic) NSURL *venueIconMediumURL;
@property (strong, nonatomic) NSURL *venueIconSmallURL;
@property (strong, nonatomic) NSString *name;

@end
