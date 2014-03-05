//
//  BDKUntappdModel.h
//
//  Created by Ben Kreeger on 3/4/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

@interface BDKUntappdModel : NSObject <NSCoding>

@property (strong, nonatomic) NSString *identifier;
@property (readonly, strong, nonatomic) NSString *remoteIdentifierName;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)updateWithDictionary:(NSDictionary *)dictionary;

@end