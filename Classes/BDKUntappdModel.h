//
//  BDKUntappdModel.h
//

@interface BDKUntappdModel : NSObject <NSCoding, NSCopying>

@property (strong, nonatomic) NSNumber *identifier;
@property (readonly, strong, nonatomic) NSDictionary *remoteMappings;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)dateFormatter;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)dateFormatter;
- (void)updateWithDictionary:(NSDictionary *)dictionary;
- (void)updateWithDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)dateFormatter;

@end