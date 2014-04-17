//
//  BDKUntappd.m
//

#import "BDKUntappd.h"

#import "BDKUntappdModels.h"
#import "BDKUntappdParser.h"

#define BDKStringFromBOOL(val) [NSString stringWithFormat:@"%@", val ? @"true" : @"false"]

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
    NSString *url = @"checkin/recent";
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

    NSString *url = [NSString stringWithFormat:@"user/checkins%@%@", username ? @"/" : @"", username ?: @""];
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
    NSString *url = @"thepub/local";
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

    NSString *url = [NSString stringWithFormat:@"venue/checkins/%@", venueID];
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

    NSString *url = [NSString stringWithFormat:@"beer/checkins/%@", beerID];
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
    NSAssert(!!breweryID, @"A brewery ID must be supplied.");

    NSString *url = [NSString stringWithFormat:@"brewery/checkins/%@", breweryID];
    NSMutableDictionary *params = [self requestParamsWithMinID:minID maxID:maxID limit:limit];

    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser checkinsFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}


#pragma mark - Object detail calls

- (void)infoForBrewery:(NSNumber *)breweryID compact:(BOOL)compact completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!breweryID, @"A brewery ID must be supplied.");
    
    NSString *url = [NSString stringWithFormat:@"brewery/info/%@", breweryID];
    NSMutableDictionary *params = [self authorizationParamsWithParams:@{@"compact": BDKStringFromBOOL(compact)}];
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser breweryFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)infoForBeer:(NSNumber *)beerID compact:(BOOL)compact completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!beerID, @"A beer ID must be supplied.");
    
    NSString *url = [NSString stringWithFormat:@"beer/info/%@", beerID];
    NSMutableDictionary *params = [self authorizationParamsWithParams:@{@"compact": BDKStringFromBOOL(compact)}];
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser beerFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)infoForVenue:(NSNumber *)venueID compact:(BOOL)compact completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!venueID, @"A venue ID must be supplied.");
    
    NSString *url = [NSString stringWithFormat:@"venue/info/%@", venueID];
    NSMutableDictionary *params = [self authorizationParamsWithParams:@{@"compact": BDKStringFromBOOL(compact)}];
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser venueFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)infoForCheckin:(NSNumber *)checkinID completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!checkinID, @"A checkin ID must be supplied.");
    
    NSString *url = [NSString stringWithFormat:@"checkin/view/%@", checkinID];
    NSMutableDictionary *params = [self authorizationParamsWithParams:nil];
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser checkinFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)infoForUser:(NSNumber *)username compact:(BOOL)compact completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!username || !!self.accessToken, @"Either username or a saved access token must be supplied.");
    
    NSString *url = [NSString stringWithFormat:@"user/info%@%@", username ? @"/" : @"", username ?: @""];
    NSMutableDictionary *params = [self authorizationParamsWithParams:nil];
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser userFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}


#pragma mark - User detail calls

- (void)badgesForUser:(NSNumber *)username compact:(BOOL)compact completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!username, @"A username must be supplied.");
    
    NSString *url = [NSString stringWithFormat:@"user/badges/%@", username];
    NSMutableDictionary *params = [self authorizationParamsWithParams:nil];
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser badgesFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)friendsForUser:(NSNumber *)username compact:(BOOL)compact completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!username, @"A username must be supplied.");
    
    NSString *url = [NSString stringWithFormat:@"user/friends/%@", username];
    NSMutableDictionary *params = [self authorizationParamsWithParams:nil];
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser usersFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)wishListForUser:(NSNumber *)username compact:(BOOL)compact completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!username, @"A username must be supplied.");
    
    NSString *url = [NSString stringWithFormat:@"user/wishlist/%@", username];
    NSMutableDictionary *params = [self authorizationParamsWithParams:nil];
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser beersFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)distinctBeersForUser:(NSNumber *)username compact:(BOOL)compact completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!username, @"A username must be supplied.");
    
    NSString *url = [NSString stringWithFormat:@"user/beers/%@", username];
    NSMutableDictionary *params = [self authorizationParamsWithParams:nil];
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser beersFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}


#pragma mark - Search and trending calls

- (void)searchForBrewery:(NSString *)query completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!query, @"A query must be supplied.");
    
    NSString *url = @"search/brewery";
    NSMutableDictionary *params = [self authorizationParamsWithParams:@{@"q": query}];
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser breweriesFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)searchForBeer:(NSString *)query sortBy:(BDKUntappdSortType)sortBy completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!query, @"A query must be supplied.");
    
    NSString *url = @"search/beer";
    NSString *sortByString = sortBy == BDKUntappdSortTypeAlphabetical ? @"name" : @"count";
    NSMutableDictionary *params = [self authorizationParamsWithParams:@{@"q": query, @"sort": sortByString}];
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser beersFromSearchResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)trendingBeers:(BDKUntappdResultBlock)completion {
    NSString *url = @"beer/trending";
    NSMutableDictionary *params = [self authorizationParamsWithParams:nil];
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser beersFromResponseObject:responseObject], nil);
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
