//
//  BDKUntappdUser.m
//

#import "BDKUntappdUser.h"

@implementation BDKUntappdUser

#pragma mark - BDKUntappdModel

- (NSDictionary *)remoteMappings {
    return @{@"bio": @"bio",
             @"facebookIdentifier": @"contact/facebook",
             @"foursquareIdentifier": @"contact/foursquare",
             @"twitterIdentifier": @"contact/twitter",
             @"firstName": @"first_name",
             @"privateUser": @"is_private",
             @"supporter": @"is_supporter",
             @"lastName": @"last_name",
             @"location": @"location",
             @"relationship": @"relationship",
             @"identifier": @"uid",
             @"url": @"url",
             @"userAvatar": @"user_avatar",
             @"userName": @"user_name",};
}

#pragma mark - Methods

- (NSString *)fullName {
    return [@[self.firstName, self.lastName] componentsJoinedByString:@" "];
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@, userName: %@, location: %@ }",
            NSStringFromClass([self class]), self, self.identifier, self.userName, self.location];
}

@end
