//
//  BDKUntappdParser.m
//

#import "BDKUntappdParser.h"
#import "BDKUntappdModels.h"

@interface BDKUntappdParser ()

@property (strong, nonatomic) NSCache *dfCache;

- (NSDateFormatter *)dateFormatterForFormat:(NSString *)format;
- (NSArray *)resultsFromResponseObject:(NSDictionary *)responseObject
                               ofClass:(Class)objectClass
                           withKeyPath:(NSString *)keypath;
- (NSArray *)resultsFromResponseObject:(NSDictionary *)responseObject
                               ofClass:(Class)objectClass
                           withKeyPath:(NSString *)keypath
                        objectNodeName:(NSString *)objectNodeName;

@end

@implementation BDKUntappdParser

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    _dfCache = [NSCache new];
    return self;
}

- (NSArray *)checkinsFromResponseObject:(id)responseObject {
    return [self resultsFromResponseObject:responseObject
                                   ofClass:[BDKUntappdCheckin class]
                               withKeyPath:@"response.checkins.items"];
}

- (BDKUntappdCheckin *)checkinFromResponseObject:(id)responseObject {
    NSDateFormatter *df = [self dateFormatterForFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZ"];
    return [BDKUntappdCheckin modelWithDictionary:responseObject[@"response"][@"checkin"] dateFormatter:df];
}

- (BDKUntappdCheckinResult *)checkinResultFromCheckinCreationResponseObject:(id)responseObject {
    NSDateFormatter *df = [self dateFormatterForFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZ"];
    return [BDKUntappdCheckinResult modelWithDictionary:responseObject[@"response"] dateFormatter:df];
}

- (NSArray *)beersFromResponseObject:(id)responseObject {
    return [self resultsFromResponseObject:responseObject
                                   ofClass:[BDKUntappdBeer class]
                               withKeyPath:@"response.beers.items"];
}

- (NSArray *)beersAndBreweriesFromResponseObject:(id)responseObject {
    NSDateFormatter *df = [self dateFormatterForFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZ"];
    NSArray *objectsToCrawl = responseObject[@"response"][@"beers"][@"items"];
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[objectsToCrawl count]];
    [objectsToCrawl enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        BDKUntappdBeer *beer = [BDKUntappdBeer modelWithDictionary:obj[@"beer"] dateFormatter:df];
        BDKUntappdBrewery *brewery = [BDKUntappdBrewery modelWithDictionary:obj[@"brewery"] dateFormatter:df];
        beer.brewery = brewery;
        [objects addObject:beer];
    }];
    return [objects copy];
}

- (NSArray *)beersFromTrendingResponseObject:(id)responseObject {
    NSDateFormatter *df = [self dateFormatterForFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZ"];
    NSMutableArray *objects = [NSMutableArray array];
    [@[@"macro", @"micro"] enumerateObjectsUsingBlock:^(NSString *kind, NSUInteger idx, BOOL *stop) {
        BDKUntappdBeerDistributionKind distroKind = BDKUntappdBeerDistributionKindUnknown;
        if ([kind isEqualToString:@"macro"]) {
            distroKind = BDKUntappdBeerDistributionKindMacro;
        } else {
            distroKind = BDKUntappdBeerDistributionKindMicro;
        }
        [responseObject[@"response"][kind][@"items"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            BDKUntappdBeer *beer = [[BDKUntappdBeer alloc] initWithDictionary:obj[@"beer"] dateFormatter:df];
            beer.distributionKind = distroKind;
            BDKUntappdBrewery *brewery = [[BDKUntappdBrewery alloc] initWithDictionary:obj[@"brewery"] dateFormatter:df];
            beer.brewery = brewery;
            [objects addObject:beer];
        }];
    }];
    return [objects copy];
}

- (BDKUntappdBeer *)beerFromResponseObject:(id)responseObject {
    NSDateFormatter *df = [self dateFormatterForFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZ"];
    return [BDKUntappdBeer modelWithDictionary:responseObject[@"response"][@"beer"] dateFormatter:df];

}

- (NSArray *)breweriesFromResponseObject:(id)responseObject {
    return [self resultsFromResponseObject:responseObject
                                   ofClass:[BDKUntappdBrewery class]
                               withKeyPath:@"response.brewery.items"
                            objectNodeName:@"brewery"];
}

- (BDKUntappdBrewery *)breweryFromResponseObject:(id)responseObject {
    NSDateFormatter *df = [self dateFormatterForFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZ"];
    return [BDKUntappdBrewery modelWithDictionary:responseObject[@"response"][@"brewery"] dateFormatter:df];
}

- (BDKUntappdToast *)toastsFromResponseObject:(id)responseObject {
    NSDateFormatter *df = [self dateFormatterForFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZ"];
    NSDictionary *firstToast = [responseObject[@"response"][@"toasts"][@"items"] firstObject];
    return firstToast ? [BDKUntappdToast modelWithDictionary:firstToast dateFormatter:df] : nil;
}

- (NSArray *)usersFromResponseObject:(id)responseObject {
    return [self resultsFromResponseObject:responseObject
                                   ofClass:[BDKUntappdUser class]
                               withKeyPath:@"response.items"];
}

- (BDKUntappdUser *)userFromResponseObject:(id)responseObject {
    NSDateFormatter *df = [self dateFormatterForFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZ"];
    return [BDKUntappdUser modelWithDictionary:responseObject[@"response"][@"user"] dateFormatter:df];
}

- (BDKUntappdVenue *)venueFromResponseObject:(id)responseObject {
    NSDateFormatter *df = [self dateFormatterForFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZ"];
    return [BDKUntappdVenue modelWithDictionary:responseObject[@"response"][@"venue"] dateFormatter:df];
}

- (NSArray *)badgesFromResponseObject:(id)responseObject {
    return [self resultsFromResponseObject:responseObject
                                   ofClass:[BDKUntappdVenue class]
                               withKeyPath:@"response.items"];
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

- (NSArray *)resultsFromResponseObject:(NSDictionary *)responseObject
                               ofClass:(Class)objectClass
                           withKeyPath:(NSString *)keypath
                        objectNodeName:(NSString *)objectNodeName {
    NSAssert([objectClass isSubclassOfClass:[BDKUntappdModel class]], @"objectClass must be class of BDKUntappdModel.");
    __block id objectToCrawl = responseObject;
    [[keypath componentsSeparatedByString:@"."] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        objectToCrawl = objectToCrawl[obj];
    }];
    NSAssert([objectToCrawl isKindOfClass:[NSArray class]], @"Resulting object at keypath must be an NSArray.");
    
    NSDateFormatter *df = [self dateFormatterForFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZ"];
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[objectToCrawl count]];
    [objectToCrawl enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        if (objectNodeName) obj = obj[objectNodeName];
        id model = [[objectClass alloc] initWithDictionary:obj dateFormatter:df];
        [objects addObject:model];
    }];
    return [objects copy];
}

- (NSArray *)resultsFromResponseObject:(NSDictionary *)responseObject
                               ofClass:(Class)objectClass
                           withKeyPath:(NSString *)keypath {
    return [self resultsFromResponseObject:responseObject ofClass:objectClass withKeyPath:keypath objectNodeName:nil];
}

@end
