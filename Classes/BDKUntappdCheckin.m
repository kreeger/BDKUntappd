//
//  BDKUntappdCheckin.h
//

#import "BDKUntappdCheckin.h"
#import "BDKUntappdBeer.h"
#import "BDKUntappdBrewery.h"
#import "BDKUntappdPhoto.h"

#import "NSArray+BDKUntappd.h"

@implementation BDKUntappdCheckin

#pragma mark - BDKUntappdModel

- (void)updateWithDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)dateFormatter {
    [super updateWithDictionary:dictionary dateFormatter:dateFormatter];
    self.beer.brewery = [[BDKUntappdBrewery alloc] initWithDictionary:dictionary[@"brewery"] dateFormatter:dateFormatter];
    if (dictionary[@"media"]) {
        self.media = [dictionary[@"media"][@"items"] bdkuntappd_map:^id(id obj) {
            return [BDKUntappdPhoto modelWithDictionary:obj dateFormatter:dateFormatter];
        }];
    }
}

- (NSDictionary *)remoteMappings {
    return @{@"badges": @"badges",
             @"beer": @"beer",
             @"brewery": @"brewery",
             @"checkinComment": @"checkin_comment",
             @"identifier": @"checkin_id",
             @"comments": @"comments",
             @"createdAt": @"created_at",
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