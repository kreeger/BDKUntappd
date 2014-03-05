//
//  BDKUntappdModel.m
//
//  Created by Ben Kreeger on 3/4/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "BDKUntappdModel.h"

#import "NSObject+BDKUntappd.h"

#import <TransformerKit/TransformerKit.h>
#import <TransformerKit/NSValueTransformer+TransformerKit.h>
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
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (!self) return nil;
    [self updateWithDictionary:dictionary];
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    NSArray *properties = [[self class] propertyNamesForClass:[self class]];
    [properties enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
        NSString *remoteName = [[self class] remotePropertyNameForLocalPropertyName:propertyName];
        id val = dictionary[remoteName];
        if (![val bdk_isPresent]) return;
        if ([[self class] property:propertyName isReadOnlyForClass:[self class]]) return;
        
        if ([val isKindOfClass:[NSDictionary class]]) {
            // Untappd's API has arrays nested in dictionaries with some metadata; this pulls it out and rights it.
            if (val[@"items"]) {
                val = val[@"items"];
            } else {
                Class klass = [[self class] classForPropertyName:propertyName inClass:[self class]];
                val = [[klass alloc] initWithDictionary:val];
            }
            
        }
        
        if ([val isKindOfClass:[NSArray class]]) {
            NSArray *valuesForVal = (NSArray *)val;
            NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[valuesForVal count]];
            [valuesForVal enumerateObjectsUsingBlock:^(id subVal, NSUInteger idx, BOOL *stop) {
                if ([[subVal class] isSubclassOfClass:[NSDictionary class]]) {
                    SEL classSelector = NSSelectorFromString([NSString stringWithFormat:@"%@_class", propertyName]);
                    if ([[self class] respondsToSelector:classSelector]) {
                        Class klass = [[self class] performSelector:classSelector];
                        if ([klass isSubclassOfClass:[BDKUntappdModel class]]) {
                            BDKUntappdModel *model = [[klass alloc] initWithDictionary:subVal];
                            [objects addObject:model];
                            return;
                        }
                    }
                    [objects addObject:subVal];
                }
            }];
            val = [objects copy];
            
        }
        
        [self setValue:val forKey:propertyName];
    }];
    
    id identifierValue = [dictionary objectForKey:self.remoteIdentifierName];
    if ([identifierValue bdk_isPresent]) {
        if (![identifierValue isKindOfClass:[NSString class]]) {
            identifierValue = [NSString stringWithFormat:@"%@", identifierValue];
        }
        [self setValue:identifierValue forKey:@"identifier"];
    }
}

- (void)dealloc {
    self.identifier = nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p> { id: %@ }", NSStringFromClass([self class]), self, self.identifier];
}

#pragma mark - Properties

- (NSString *)remoteIdentifierName {
    return @"id";
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) return nil;
    
    id decoded = [aDecoder decodeObjectForKey:@"identifier"];
    [self setValue:decoded forKey:@"identifier"];
    
    NSArray *propertyNames = [[self class] propertyNamesForClass:[self class]];
    [propertyNames enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if ([[self class] property:key isReadOnlyForClass:[self class]]) return;
        id decoded = [aDecoder decodeObjectForKey:key];
        if (![decoded bdk_isPresent]) return;
        [self setValue:decoded forKey:key];
    }];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    NSArray *propertyNames = [[self class] propertyNamesForClass:[self class]];
    [propertyNames enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
		[aCoder encodeObject:[self valueForKey:key] forKey:key];
    }];
}

#pragma mark - Private methods

+ (NSArray *)propertyNamesForClass:(Class)klass {
    if (klass == [BDKUntappdModel class]) {
        return [NSArray array];
    }
    
	int numberOfProperties = 0;
	objc_property_t *propertyTypes = class_copyPropertyList(klass, &numberOfProperties);
    
	NSMutableArray *propertyList = [NSMutableArray arrayWithCapacity:numberOfProperties];
	for (int idx = 0; idx < numberOfProperties; idx++) {
		objc_property_t property = propertyTypes[idx];
		[propertyList addObject:[NSString stringWithUTF8String:property_getName(property)]];
	}
    
	free(propertyTypes);
    return propertyList;
}

+ (NSString *)remotePropertyNameForLocalPropertyName:(NSString *)localPropertyName {
    NSString *unLlamad = [[NSValueTransformer valueTransformerForName:TTTLlamaCaseStringTransformerName]
                          reverseTransformedValue:localPropertyName];
    return [[NSValueTransformer valueTransformerForName:TTTTrainCaseStringTransformerName] transformedValue:unLlamad];
}

+ (BOOL)property:(NSString *)propertyName isReadOnlyForClass:(Class)klass {
    const char *type = property_getAttributes(class_getProperty(klass, [propertyName UTF8String]));
    NSString *typeAttribute = [[[NSString stringWithUTF8String:type] componentsSeparatedByString:@","] objectAtIndex:1];
    return [typeAttribute rangeOfString:@"R"].length > 0;
}

+ (Class)classForPropertyName:(NSString *)propertyName inClass:(Class)klass {
	int numberOfProperties = 0;
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