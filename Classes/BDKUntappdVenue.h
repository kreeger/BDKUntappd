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
@property (strong, nonatomic) NSDictionary *contact;
@property (strong, nonatomic) NSDictionary *foursquare;
@property (strong, nonatomic) NSDictionary *location;
@property (strong, nonatomic) NSString *parentCategoryId;
@property (strong, nonatomic) NSString *primaryCategory;
@property (strong, nonatomic) NSDictionary *venueIcon;
@property (strong, nonatomic) NSString *venueName;

@end
