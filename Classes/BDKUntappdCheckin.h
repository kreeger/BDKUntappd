//
//  BDKUntappdCheckin.h
//
//  Created by Ben Kreeger on 3/4/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "BDKUntappdModel.h"

@interface BDKUntappdCheckin : BDKUntappdModel

@property (strong, nonatomic) NSArray *badges;
@property (strong, nonatomic) NSDictionary *beer;
@property (strong, nonatomic) NSDictionary *brewery;
@property (strong, nonatomic) NSArray *comments;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSArray *media;
@property (strong, nonatomic) NSNumber *ratingScore;
@property (strong, nonatomic) NSDictionary *source;
@property (strong, nonatomic) NSArray *toasts;
@property (strong, nonatomic) NSDictionary *user;
@property (strong, nonatomic) NSDictionary *venue;

@end