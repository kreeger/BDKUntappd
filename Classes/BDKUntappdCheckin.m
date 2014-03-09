//
//  BDKUntappdCheckin.h
//
//  Created by Ben Kreeger on 3/4/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "BDKUntappdCheckin.h"

@implementation BDKUntappdCheckin

#pragma mark - BDKUntappdModel

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    [super updateWithDictionary:dictionary];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (NSString *)remoteIdentifierName {
    return @"checkin_id";
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@, createdAt: %@ }",
            NSStringFromClass([self class]), self, self.identifier, self.createdAt];
}

@end