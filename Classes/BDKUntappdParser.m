//
//  BDKUntappdParser.m
//  Pods
//
//  Created by Ben Kreeger on 3/9/14.
//
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
    }];
    NSLog(@"Parsed %i objects.", [objects count]);
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
