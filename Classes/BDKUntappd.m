//
//  BDKUntappd.m
//
//  Created by Ben Kreeger on 3/4/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import "BDKUntappd.h"

#import "BDKUntappdModels.h"
#import "BDKUntappdParser.h"

NSString * const BDKUntappdBaseURL = @"http://api.untappd.com/v4";
NSString * const BDKUntappdAuthenticateURL = @"https://untappd.com/oauth/authenticate";
NSString * const BDKUntappdAuthorizeURL = @"https://untappd.com/oauth/authorize";

@interface BDKUntappd ()

- (NSDictionary *)authorizationParams;
- (NSMutableDictionary *)authorizationParamsWithParams:(NSDictionary *)params;
- (NSMutableDictionary *)requestParamsWithMinID:(NSNumber *)minID maxID:(NSNumber *)maxID limit:(NSInteger)limit;
- (void)handleError:(NSError *)error forTask:(NSURLSessionDataTask *)task completion:(BDKUntappdResultBlock)completion;

@end

@implementation BDKUntappd

#pragma mark - Lifecycle

- (instancetype)initWithClientId:(NSString *)clientId
                    clientSecret:(NSString *)clientSecret
                     redirectUrl:(NSString *)redirectUrl {
    self = [super initWithBaseURL:[NSURL URLWithString:BDKUntappdBaseURL]];
    if (!self) return nil;
    
    _clientId = clientId;
    _clientSecret = clientSecret;
    _redirectUrl = redirectUrl;
    _parser = [BDKUntappdParser new];
    
    return self;
}

#pragma mark - Authentication

- (NSURLRequest *)authenticationURLRequest {
    NSDictionary *params = @{@"client_id": self.clientId,
                             @"response_type": @"code",
                             @"redirect_url": self.redirectUrl};
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET"
                                                                   URLString:BDKUntappdAuthenticateURL
                                                                  parameters:params
                                                                       error:nil];
    return [request copy];
}

- (void)authorizeForAccessCode:(NSString *)accessCode completion:(BDKUntappdResultBlock)completion {
    NSString *url = [NSString stringWithFormat:BDKUntappdAuthorizeURL];
    NSDictionary *params = @{@"client_id": self.clientId,
                             @"client_secret": self.clientSecret,
                             @"redirect_url": self.redirectUrl,
                             @"response_type": @"code",
                             @"code": accessCode};
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject[@"response"][@"access_token"]) {
            self.accessToken = responseObject[@"response"][@"access_token"];
        }
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

#pragma mark - Checkin feeds

- (void)checkinsForFriendsWithMaxID:(NSNumber *)maxID
                              limit:(NSInteger)limit
                         completion:(BDKUntappdResultBlock)completion {
    NSString *url = @"/v4/checkin/recent";
    NSMutableDictionary *params = [self requestParamsWithMinID:nil maxID:maxID limit:limit];
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser checkinsFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)checkinsForUser:(NSString *)username
                  maxID:(NSNumber *)maxID
                  limit:(NSInteger)limit
             completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!username || !!self.accessToken, @"Either username or a saved access token must be supplied.");
    
    NSString *url = [NSString stringWithFormat:@"/v4/user/checkins%@%@", username ? @"/" : @"", username ?: @""];
    NSMutableDictionary *params = [self requestParamsWithMinID:nil maxID:maxID limit:limit];
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser checkinsFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)publicFeedForLatitude:(float)latitude
                    longitude:(float)longitude
                       radius:(NSInteger)radius
                        minID:(NSNumber *)minID
                        maxID:(NSNumber *)maxID
                        limit:(NSInteger)limit
                   completion:(BDKUntappdResultBlock)completion {
    NSString *url = @"/v4/thepub/local";
    NSMutableDictionary *params = [self requestParamsWithMinID:minID maxID:maxID limit:limit];
    if (latitude > 0) params[@"lat"] = @(latitude);
    if (longitude > 0) params[@"lng"] = @(longitude);
    if (radius > 0) params[@"radius"] = @(radius);
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser checkinsFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)checkinsForVenue:(NSNumber *)venueID
                   minID:(NSNumber *)minID
                   maxID:(NSNumber *)maxID
                   limit:(NSInteger)limit
              completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!venueID, @"A venue ID must be supplied.");
    
    NSString *url = [NSString stringWithFormat:@"/v4/venue/checkins/%@", venueID];
    NSMutableDictionary *params = [self requestParamsWithMinID:minID maxID:maxID limit:limit];
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser checkinsFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)checkinsForBeer:(NSNumber *)beerID
                  minID:(NSNumber *)minID
                  maxID:(NSNumber *)maxID
                  limit:(NSInteger)limit
             completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!beerID, @"A beer ID must be supplied.");
    
    NSString *url = [NSString stringWithFormat:@"/v4/beer/checkins/%@", beerID];
    NSMutableDictionary *params = [self requestParamsWithMinID:minID maxID:maxID limit:limit];
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser checkinsFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)checkinsForBrewery:(NSNumber *)breweryID
                     minID:(NSNumber *)minID
                     maxID:(NSNumber *)maxID
                     limit:(NSInteger)limit
                completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!breweryID, @"A beer ID must be supplied.");
    
    NSString *url = [NSString stringWithFormat:@"/v4/brewery/checkins/%@", breweryID];
    NSMutableDictionary *params = [self requestParamsWithMinID:minID maxID:maxID limit:limit];
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser checkinsFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

#pragma mark - Private methods

- (NSDictionary *)authorizationParams {
    if (self.accessToken) {
        return @{@"access_token": self.accessToken};
    }
    return @{@"client_id": self.clientId,
             @"client_secret": self.clientSecret,};
}

- (NSMutableDictionary *)authorizationParamsWithParams:(NSDictionary *)params {
    if ([params count] == 0) return [[self authorizationParams] mutableCopy];
    
    NSMutableDictionary *merge = [[self authorizationParams] mutableCopy];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        merge[key] = obj;
    }];
    return merge;
}

- (NSMutableDictionary *)requestParamsWithMinID:(NSNumber *)minID maxID:(NSNumber *)maxID limit:(NSInteger)limit {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (minID) params[@"min_id"] = minID;
    if (maxID) params[@"max_id"] = maxID;
    if (limit > 0 && limit <= 50) params[@"limit"] = @(limit);
    params = [self authorizationParamsWithParams:params];
    return params;
}

- (void)handleError:(NSError *)error forTask:(NSURLSessionDataTask *)task completion:(BDKUntappdResultBlock)completion {
    NSLog(@"API ERROR. %@", [error localizedDescription]);
    
    if (completion) {
        completion(nil, error);
    }
}

@end
