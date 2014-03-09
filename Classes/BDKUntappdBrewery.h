//
//  BDKUntappdBrewery.h
//  Pods
//
//  Created by Ben Kreeger on 3/9/14.
//
//

#import "BDKUntappdModel.h"

@interface BDKUntappdBrewery : BDKUntappdModel

@property (assign, nonatomic, getter = breweryIsActive) BOOL breweryActive;
@property (strong, nonatomic) NSURL *breweryLabel;
@property (strong, nonatomic) NSString *breweryName;
@property (strong, nonatomic) NSDictionary *contact;
@property (strong, nonatomic) NSString *countryName;
@property (strong, nonatomic) NSDictionary *location;

@end
