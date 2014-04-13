//
//  BDKUntappdModel.m
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "BDKUntappdModel.h"

#import "NSObject+BDKUntappd.h"

#import <objc/runtime.h>

// Praise be to Jastor. https://github.com/elado/jastor
static const char *property_getTypeName(objc_property_t property) {
	const char *attributes = property_getAttributes(property);
	char buffer[1 + strlen(attributes)];
	strcpy(buffer, attributes);
	char *state = buffer, *attribute;
	while ((attribute = strsep(&state, ",")) != NULL) {
		if (attribute[0] == 'T') {
			size_t len = strlen(attribute);
			attribute[len - 1] = '\0';
			return (const char *)[[NSData dataWithBytes:(attribute + 3) length:len - 2] bytes];
		}
	}
	return "@";
}

@implementation BDKUntappdModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    return [[self alloc] initWithDictionary:dictionary dateFormatter:nil];
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)dateFormatter {
    return [[self alloc] initWithDictionary:dictionary dateFormatter:dateFormatter];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!self) return nil;
    [self updateWithDictionary:dictionary];
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)dateFormatter {
    self = [super init];
    if (!self) return nil;
    [self updateWithDictionary:dictionary dateFormatter:dateFormatter];
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    [self updateWithDictionary:dictionary dateFormatter:nil];
}

- (void)updateWithDictionary:(NSDictionary *)dictionary dateFormatter:(NSDateFormatter *)dateFormatter {
    [self.remoteMappings enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, NSString *remoteName, BOOL *stop) {
        id remoteValue;
        if ([remoteName rangeOfString:@"/"].location == NSNotFound) {
            remoteValue = dictionary[remoteName];
        } else {
            NSArray *components = [remoteName componentsSeparatedByString:@"/"];
            id nestedValue = dictionary[components[0]];
            for (int idx = 1; idx < [components count]; idx++) {
                nestedValue = nestedValue[components[idx]];
            }
            remoteValue = nestedValue;
        }
        
        if (![remoteValue bdk_isPresent]) return;
        if ([[self class] property:propertyName isReadOnlyForClass:[self class]]) return;
        
        if ([remoteValue isKindOfClass:[NSDictionary class]]) {
            // Untappd's API has arrays nested in dictionaries with some metadata; this pulls it out and rights it.
            if (remoteValue[@"items"]) {
                remoteValue = remoteValue[@"items"];
            } else {
                Class klass = [[self class] classForPropertyName:propertyName inClass:[self class]];
                remoteValue = [[klass alloc] initWithDictionary:remoteValue];
            }
        }
        
        if ([remoteValue isKindOfClass:[NSArray class]]) {
            NSArray *valuesForVal = (NSArray *)remoteValue;
            NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[valuesForVal count]];
            [valuesForVal enumerateObjectsUsingBlock:^(id subVal, NSUInteger idx, BOOL *stop) {
                if ([[subVal class] isSubclassOfClass:[NSDictionary class]]) {
                    SEL classTypeSelector = NSSelectorFromString([NSString stringWithFormat:@"%@_class", propertyName]);
                    if ([self respondsToSelector:classTypeSelector]) {
                        Class (*func)(id, SEL) = (void *)[self methodForSelector:classTypeSelector];
                        Class klass = func(self, classTypeSelector);
                        if ([klass isSubclassOfClass:[BDKUntappdModel class]]) {
                            BDKUntappdModel *model = [[klass alloc] initWithDictionary:subVal];
                            [objects addObject:model];
                            return;
                        }
                    }
                    [objects addObject:subVal];
                }
            }];
            remoteValue = [objects copy];
        }
        
        // Check for a few additional string conversions based on the real property class.
        if ([remoteValue isKindOfClass:[NSString class]]) {
            Class klass = [[self class] classForPropertyName:propertyName inClass:[self class]];
            if ([klass isSubclassOfClass:[NSURL class]]) {
                remoteValue = [NSURL URLWithString:remoteValue];
            } else if ([klass isSubclassOfClass:[NSDate class]]) {
                remoteValue = [dateFormatter dateFromString:remoteValue];
            }
        }
        
        [self setValue:remoteValue forKey:propertyName];
    }];
    
    // Ensure an incoming identifier is really just a string.
    id identifierValue = dictionary[self.remoteMappings[@"identifier"]];
    if ([identifierValue bdk_isPresent]) {
        if (![identifierValue isKindOfClass:[NSString class]]) {
            identifierValue = [NSString stringWithFormat:@"%@", identifierValue];
        }
        [self setValue:identifierValue forKey:@"identifier"];
    }
    
    NSLog(@"Updated %@.", self);
}

- (void)dealloc {
    self.identifier = nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@ }", NSStringFromClass([self class]), self, self.identifier];
}

#pragma mark - Properties

- (NSDictionary *)remoteMappings {
    return @{};
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) return nil;
    
    [[self.remoteMappings allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if ([[self class] property:key isReadOnlyForClass:[self class]]) return;
        id decoded = [aDecoder decodeObjectForKey:key];
        if (![decoded bdk_isPresent]) return;
        [self setValue:decoded forKey:key];
    }];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [[self.remoteMappings allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
		[aCoder encodeObject:[self valueForKey:key] forKey:key];
    }];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    typeof(self) copy = [[[self class] alloc] init];
    if (!copy) return nil;
    [[self.remoteMappings allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        [self setValue:[[self valueForKey:key] copyWithZone:zone] forKey:key];
    }];
    return copy;
}

#pragma mark - Private methods

+ (BOOL)property:(NSString *)propertyName isReadOnlyForClass:(Class)klass {
    const char *type = property_getAttributes(class_getProperty(klass, [propertyName UTF8String]));
    NSString *typeAttribute = [[[NSString stringWithUTF8String:type] componentsSeparatedByString:@","] objectAtIndex:1];
    return [typeAttribute rangeOfString:@"R"].length > 0;
}

+ (Class)classForPropertyName:(NSString *)propertyName inClass:(Class)klass {
	uint numberOfProperties = 0;
	objc_property_t *propertyTypes = class_copyPropertyList(klass, &numberOfProperties);
	const char *cPropertyName = [propertyName UTF8String];
    
	for (int idx = 0; idx < numberOfProperties; idx++) {
		objc_property_t property = propertyTypes[idx];
		if (strcmp(cPropertyName, property_getName(property)) == 0) {
			free(propertyTypes);
			return NSClassFromString([NSString stringWithUTF8String:property_getTypeName(property)]);
		}
	}
    
    free(propertyTypes);
	return [self classForPropertyName:propertyName inClass:class_getSuperclass(klass)];
}

@end