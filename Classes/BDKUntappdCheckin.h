//
//  BDKUntappdCheckin.h
//
//  Created by Ben Kreeger on 3/4/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "BDKUntappdModel.h"

@class BDKUntappdBeer, BDKUntappdBrewery, BDKUntappdUser, BDKUntappdVenue;

@interface BDKUntappdCheckin : BDKUntappdModel

@property (strong, nonatomic) NSArray *badges;
@property (strong, nonatomic) BDKUntappdBeer *beer;
@property (strong, nonatomic) BDKUntappdBrewery *brewery;
@property (strong, nonatomic) NSString *checkinComment;
@property (strong, nonatomic) NSArray *comments;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSArray *media;
@property (strong, nonatomic) NSNumber *ratingScore;
@property (strong, nonatomic) NSString *sourceAppName;
@property (strong, nonatomic) NSURL *sourceAppWebsite;
@property (strong, nonatomic) NSArray *toasts;
@property (strong, nonatomic) BDKUntappdUser *user;
@property (strong, nonatomic) BDKUntappdVenue *venue;

@end