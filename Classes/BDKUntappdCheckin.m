//
//  BDKUntappdCheckin.h
//
//  Created by Ben Kreeger on 3/4/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "BDKUntappdCheckin.h"

@implementation BDKUntappdCheckin

#pragma mark - BDKUntappdModel

- (NSDictionary *)remoteMappings {
    return @{@"badges": @"badges",
             @"beer": @"beer",
             @"brewery": @"brewery",
             @"checkinComment": @"checkin_comment",
             @"identifier": @"checkin_id",
             @"comments": @"comments",
             @"createdAt": @"created_at",
             @"media": @"media",
             @"ratingScore": @"rating_score",
             @"sourceAppName": @"source/app_name",
             @"sourceAppWebsite": @"source/app_website",
             @"toasts": @"toasts",
             @"user": @"user",
             @"venue": @"venue"};
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@, createdAt: %@ }",
            NSStringFromClass([self class]), self, self.identifier, self.createdAt];
}

@end