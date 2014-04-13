//
//  BDKUntappdModel.h
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

@interface BDKUntappdModel : NSObject <NSCoding>

@property (strong, nonatomic) NSString *identifier;
@property (readonly, strong, nonatomic) NSDictionary *remoteMappings;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)dateFormatter;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)dateFormatter;
- (void)updateWithDictionary:(NSDictionary *)dictionary;
- (void)updateWithDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)dateFormatter;

@end