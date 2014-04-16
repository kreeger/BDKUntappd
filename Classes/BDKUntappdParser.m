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
    return [BDKUntappdCheckin modelWithDictionary:responseObject[@"checkin"] dateFormatter:df];
}

- (NSArray *)beersFromResponseObject:(id)responseObject {
    return [self resultsFromResponseObject:responseObject
                                   ofClass:[BDKUntappdBeer class]
                               withKeyPath:@"response.beers.items"];
}

- (BDKUntappdBeer *)beerFromResponseObject:(id)responseObject {
    NSDateFormatter *df = [self dateFormatterForFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZ"];
    return [BDKUntappdBeer modelWithDictionary:responseObject[@"beer"] dateFormatter:df];

}

- (NSArray *)breweriesFromResponseObject:(id)responseObject {
    return [self resultsFromResponseObject:responseObject
                                   ofClass:[BDKUntappdBrewery class]
                               withKeyPath:@"response.brewery.items"
                            objectNodeName:@"brewery"];
}

- (BDKUntappdBrewery *)breweryFromResponseObject:(id)responseObject {
    NSDateFormatter *df = [self dateFormatterForFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZ"];
    return [BDKUntappdBrewery modelWithDictionary:responseObject[@"brewery"] dateFormatter:df];
}

- (NSArray *)usersFromResponseObject:(id)responseObject {
    return [self resultsFromResponseObject:responseObject
                                   ofClass:[BDKUntappdUser class]
                               withKeyPath:@"response.items"];
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
