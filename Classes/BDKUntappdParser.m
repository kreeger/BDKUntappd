//
//  BDKUntappdParser.m
//

#import "BDKUntappdParser.h"
#import "BDKUntappdModels.h"

@interface BDKUntappdParser ()

@property (strong, nonatomic) NSCache *dfCache;

- (NSDateFormatter *)dateFormatterForFormat:(NSString *)format;

@end

@implementation BDKUntappdParser

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    _dfCache = [NSCache new];
    return self;
}

- (NSArray *)checkinsFromResponseObject:(id)responseObject {
    NSDateFormatter *df = [self dateFormatterForFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZ"];
    NSMutableArray *objects = [NSMutableArray array];
    [responseObject[@"response"][@"checkins"][@"items"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [objects addObject:[BDKUntappdCheckin modelWithDictionary:obj dateFormatter:df]];
        NSLog(@"--- Parsed.");
    }];
    NSLog(@"Parsed %lu objects.", (unsigned long)[objects count]);
    return [objects copy];
}

- (BDKUntappdCheckin *)checkinFromResponseObject:(id)responseObject {
    NSDateFormatter *df = [self dateFormatterForFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZ"];
    return [BDKUntappdCheckin modelWithDictionary:responseObject[@"checkin"] dateFormatter:df];
}

- (NSArray *)beersFromResponseObject:(id)responseObject {
    NSDateFormatter *df = [self dateFormatterForFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZ"];
    NSMutableArray *objects = [NSMutableArray array];
    [responseObject[@"response"][@"beers"][@"items"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [objects addObject:[BDKUntappdBeer modelWithDictionary:obj dateFormatter:df]];
        NSLog(@"--- Parsed.");
    }];
    NSLog(@"Parsed %lu objects.", (unsigned long)[objects count]);
    return [objects copy];
}

- (BDKUntappdBeer *)beerFromResponseObject:(id)responseObject {
    NSDateFormatter *df = [self dateFormatterForFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZ"];
    return [BDKUntappdBeer modelWithDictionary:responseObject[@"beer"] dateFormatter:df];

}

- (BDKUntappdBrewery *)breweryFromResponseObject:(id)responseObject {
    NSDateFormatter *df = [self dateFormatterForFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZ"];
    return [BDKUntappdBrewery modelWithDictionary:responseObject[@"brewery"] dateFormatter:df];
}

- (NSArray *)usersFromResponseObject:(id)responseObject {
    NSDateFormatter *df = [self dateFormatterForFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZ"];
    NSMutableArray *objects = [NSMutableArray array];
    [responseObject[@"response"][@"items"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [objects addObject:[BDKUntappdUser modelWithDictionary:obj dateFormatter:df]];
        NSLog(@"--- Parsed.");
    }];
    NSLog(@"Parsed %lu objects.", (unsigned long)[objects count]);
    return [objects copy];
}

- (BDKUntappdUser *)userFromResponseObject:(id)responseObject {
    NSDateFormatter *df = [self dateFormatterForFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZ"];
    return [BDKUntappdUser modelWithDictionary:responseObject[@"user"] dateFormatter:df];
}

- (BDKUntappdVenue *)venueFromResponseObject:(id)responseObject {
    NSDateFormatter *df = [self dateFormatterForFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZ"];
    return [BDKUntappdVenue modelWithDictionary:responseObject[@"venue"] dateFormatter:df];
}

- (NSArray *)badgesFromResponseObject:(id)responseObject {
    NSDateFormatter *df = [self dateFormatterForFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZ"];
    NSMutableArray *objects = [NSMutableArray array];
    [responseObject[@"response"][@"items"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [objects addObject:[BDKUntappdVenue modelWithDictionary:obj dateFormatter:df]];
        NSLog(@"--- Parsed.");
    }];
    NSLog(@"Parsed %lu objects.", (unsigned long)[objects count]);
    return [objects copy];
}

#pragma mark - Methods

- (NSDateFormatter *)dateFormatterForFormat:(NSString *)format {
    if ([self.dfCache objectForKey:format]) {
        return [self.dfCache objectForKey:format];
    }
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:format];
    [self.dfCache setObject:df forKey:format];
    return df;
}

@end
