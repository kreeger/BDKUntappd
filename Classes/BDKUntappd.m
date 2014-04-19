//
//  BDKUntappd.m
//

#import "BDKUntappd.h"

#import "BDKUntappdModels.h"
#import "BDKUntappdParser.h"

#import <tgmath.h>

#define BDKStringFromBOOL(val) [NSString stringWithFormat:@"%@", val ? @"true" : @"false"]

NSString * const BDKUntappdBaseURL = @"http://api.untappd.com/v4";
NSString * const BDKUntappdAuthenticateURL = @"https://untappd.com/oauth/authenticate";
NSString * const BDKUntappdAuthorizeURL = @"https://untappd.com/oauth/authorize";

@interface BDKUntappd ()

- (NSDictionary *)authorizationParams;
- (NSMutableDictionary *)authorizationParamsWithParams:(NSDictionary *)params;
- (NSMutableDictionary *)requestParamsWithMinID:(NSNumber *)minID maxID:(NSNumber *)maxID limit:(NSInteger)limit;
- (void)handleError:(NSError *)error forTask:(NSURLSessionDataTask *)task completion:(BDKUntappdResultBlock)completion;

- (NSString *)parameterValueForWishListSortType:(BDKUntappdWishListSortType)sortType;
- (NSString *)parameterValueForDistinctBeerSortType:(BDKUntappdDistinctBeerSortType)sortType;
- (NSString *)parameterValueForBeerSearchSortType:(BDKUntappdBeerSearchSortType)sortType;

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

- (void)venueForFoursquareLocationID:(NSString *)foursquareLocationID completion:(BDKUntappdResultBlock)completion {
    
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

- (void)badgesForUser:(NSNumber *)username offset:(NSInteger)offset completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!username || !!self.accessToken, @"Either username or a saved access token must be supplied.");
    
    NSString *url = [NSString stringWithFormat:@"user/badges/%@", username];
    NSMutableDictionary *params = [self authorizationParamsWithParams:nil];
    if (offset > 0) params[@"offset"] = @(offset);
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser badgesFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)friendsForUser:(NSNumber *)username
                offset:(NSInteger)offset
                 limit:(NSInteger)limit
            completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!username || !!self.accessToken, @"Either username or a saved access token must be supplied.");
    
    NSString *url = [NSString stringWithFormat:@"user/friends/%@", username];
    NSMutableDictionary *params = [self authorizationParamsWithParams:nil];
    if (offset > 0) params[@"offset"] = @(offset);
    if (limit > 0 && limit <= 50) params[@"limit"] = @(limit);
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser usersFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)wishListForUser:(NSNumber *)username
                 sortBy:(BDKUntappdWishListSortType)sortBy
                 offset:(NSInteger)offset
             completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!username, @"A username must be supplied.");
    
    NSString *url = [NSString stringWithFormat:@"user/wishlist/%@", username];
    NSString *sortValue = [self parameterValueForWishListSortType:sortBy];
    NSMutableDictionary *params = [self authorizationParamsWithParams:@{@"sort": sortValue}];
    if (offset > 0) params[@"offset"] = @(offset);
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // Todo: account for things like created_at, friends?
        completion([self.parser beersAndBreweriesFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)distinctBeersForUser:(NSNumber *)username
                      sortBy:(BDKUntappdDistinctBeerSortType)sortBy
                      offset:(NSInteger)offset
                  completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!username, @"A username must be supplied.");
    
    NSString *url = [NSString stringWithFormat:@"user/beers/%@", username];
    NSString *sortValue = [self parameterValueForDistinctBeerSortType:sortBy];
    NSMutableDictionary *params = [self authorizationParamsWithParams:@{@"sort": sortValue}];
    if (offset > 0) params[@"offset"] = @(offset);
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // Todo: account for things like recent_created_at, first_had, count
        completion([self.parser beersAndBreweriesFromResponseObject:responseObject], nil);
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

- (void)searchForBeer:(NSString *)query
               sortBy:(BDKUntappdBeerSearchSortType)sortBy
           completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!query, @"A query must be supplied.");
    
    NSString *url = @"search/beer";
    NSString *sortValue = [self parameterValueForBeerSearchSortType:sortBy];
    NSMutableDictionary *params = [self authorizationParamsWithParams:@{@"q": query, @"sort": sortValue}];
    
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // Note: account for things like your_count, have_had, checkin_count
        completion([self.parser beersAndBreweriesFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)trendingBeers:(BDKUntappdResultBlock)completion {
    NSString *url = @"beer/trending";
    NSMutableDictionary *params = [self authorizationParamsWithParams:nil];
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser beersFromTrendingResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}


#pragma mark - Checking in, commenting, and toasting

- (void)checkinToBeerID:(NSNumber *)beerID
   foursquareLocationID:(NSString *)foursquareLocationID
               latitude:(float)latitude
              longitude:(float)longitude
                  shout:(NSString *)shout
                 rating:(float)rating
                 postTo:(BDKUntappdCheckinPostTo)postTo
             completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!self.accessToken, @"This call requires an access token to use.");
    NSAssert(!!beerID, @"A beer ID must be supplied.");
    if (shout) NSAssert([shout length] <= 140, @"A supplied shout message must not exceed 140 characters.");
    if (rating > 0) {
        NSAssert(1.0 <= rating && rating <= 5.0, @"Rating must be between 1.0 & 5.0.");
        NSAssert(fmod(rating, 0.5) == 0, @"Rating must be whollydivisible by 0.5.");
    }
    
    float gmtOffset = [[NSTimeZone systemTimeZone] secondsFromGMT] / 3600.0;
    NSString *timezone = [[NSTimeZone systemTimeZone] abbreviation];
    
    NSString *url = [NSString stringWithFormat:@"checkin/add?access_token=%@", self.accessToken];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"bid": beerID,
                                                                                  @"gmt_offset": @(gmtOffset),
                                                                                  @"timezone": timezone}];
    if (shout && ![shout isEqualToString:@""]) params[@"shout"] = shout;
    if (latitude > 0) params[@"geolat"] = @(latitude);
    if (longitude > 0) params[@"geolng"] = @(longitude);
    if (rating > 0) params[@"rating"] = @(rating);
    if ((postTo & BDKUntappdCheckinPostToFacebook) != 0) params[@"facebook"] = @"on";
    if ((postTo & BDKUntappdCheckinPostToTwitter) != 0) params[@"twitter"] = @"on";
    if ((postTo & BDKUntappdCheckinPostToFoursquare) != 0) params[@"foursquare"] = @"on";
    
    [self POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser checkinResultFromCheckinCreationResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)addComment:(NSString *)comment toCheckin:(NSNumber *)checkinID completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!comment, @"A comment must be supplied.");
    NSAssert([comment length] <= 140, @"A comment cannot exceed 140 characters in length.");
    NSAssert(!!checkinID, @"A checkinID must be supplied.");
    
    NSString *url = [NSString stringWithFormat:@"checkin/addcomment/%@", checkinID];
    NSMutableDictionary *params = [self authorizationParamsWithParams:nil];
    [self POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser toastsFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)removeComment:(NSNumber *)commentID completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!commentID, @"A commentID must be supplied.");
    
    NSString *url = [NSString stringWithFormat:@"checkin/deletecomment/%@", commentID];
    NSMutableDictionary *params = [self authorizationParamsWithParams:nil];
    [self POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser toastsFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)toggleToastForCheckin:(NSNumber *)checkinID completion:(BDKUntappdResultBlock)completion {
    NSAssert(!!checkinID, @"A checkinID must be supplied.");
    
    NSString *url = [NSString stringWithFormat:@"checkin/toast/%@", checkinID];
    NSMutableDictionary *params = [self authorizationParamsWithParams:nil];
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion([self.parser toastsFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}


#pragma mark - Wish list management

- (void)addBeerID:(NSNumber *)beerID toWishlistWithCompletion:(BDKUntappdResultBlock)completion {
    NSAssert(!!beerID, @"A beerID must be supplied.");
    
    NSString *url = @"user/wishlist/add";
    NSMutableDictionary *params = [self authorizationParamsWithParams:@{@"bid": beerID}];
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // TODO: figure out a better way to parse this stuff :(
        completion([self.parser beerFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)removeBeerID:(NSNumber *)beerID fromWishlistWithCompletion:(BDKUntappdResultBlock)completion {
    NSAssert(!!beerID, @"A beerID must be supplied.");
    
    NSString *url = @"user/wishlist/delete";
    NSMutableDictionary *params = [self authorizationParamsWithParams:@{@"bid": beerID}];
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // TODO: figure out a better way to parse this stuff :(
        completion([self.parser beerFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}


#pragma mark - Friend management

- (void)pendingFriendRequests:(BDKUntappdResultBlock)completion {
    NSString *url = @"user/pending";
    NSMutableDictionary *params = [self authorizationParamsWithParams:nil];
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // TODO: figure out a better way to parse this stuff :(
        completion([self.parser usersFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)approvePendingFriendshipForUserID:(NSNumber *)userID completion:(BDKUntappdResultBlock)completion {
    NSString *url = [NSString stringWithFormat:@"friend/accept/%@", userID];
    NSMutableDictionary *params = [self authorizationParamsWithParams:nil];
    [self POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // TODO: figure out a better way to parse this stuff :(
        completion([self.parser userFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)rejectPendingFriendshipForUserID:(NSNumber *)userID completion:(BDKUntappdResultBlock)completion {
    NSString *url = [NSString stringWithFormat:@"friend/reject/%@", userID];
    NSMutableDictionary *params = [self authorizationParamsWithParams:nil];
    [self POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // TODO: figure out a better way to parse this stuff :(
        completion([self.parser userFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)revokeFriendshipForUserID:(NSNumber *)userID completion:(BDKUntappdResultBlock)completion {
    NSString *url = [NSString stringWithFormat:@"/v3/friend/remove/%@", userID];
    NSMutableDictionary *params = [self authorizationParamsWithParams:nil];
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}

- (void)requestFriendshipForUserID:(NSNumber *)userID completion:(BDKUntappdResultBlock)completion {
    NSString *url = [NSString stringWithFormat:@"friend/request/%@", userID];
    NSMutableDictionary *params = [self authorizationParamsWithParams:nil];
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // TODO: figure out a better way to parse this stuff :(
        completion([self.parser userFromResponseObject:responseObject], nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self handleError:error forTask:task completion:completion];
    }];
}


#pragma mark - Notifications

- (void)notificationsForCurrentUser:(BDKUntappdResultBlock)completion {
    NSString *url = @"notifications";
    NSMutableDictionary *params = [self authorizationParamsWithParams:nil];
    [self GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // TODO: figure out a better way to parse this stuff :(
        completion(responseObject, nil);
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

- (NSString *)parameterValueForWishListSortType:(BDKUntappdWishListSortType)sortType {
    switch (sortType) {
        case BDKUntappdWishListSortTypeMostRecent: return @"date";
        case BDKUntappdWishListSortTypeMostCheckins: return @"checkin";
        case BDKUntappdWishListSortTypeHighestRated: return @"highest_rated";
        case BDKUntappdWishListSortTypeLowestRated: return @"lowest_rated";
        case BDKUntappdWishListSortTypeHighestABV: return @"highest_abv";
        case BDKUntappdWishListSortTypeLowestABV: return @"lowest_abv";
    }
}

- (NSString *)parameterValueForDistinctBeerSortType:(BDKUntappdDistinctBeerSortType)sortType {
    switch (sortType) {
        case BDKUntappdDistinctBeerSortTypeMostRecent: return @"date";
        case BDKUntappdDistinctBeerSortTypeMostCheckins: return @"checkin";
        case BDKUntappdDistinctBeerSortTypeHighestRated: return @"highest_rated";
        case BDKUntappdDistinctBeerSortTypeLowestRated: return @"lowest_rated";
        case BDKUntappdDistinctBeerSortTypeHighestRatedByYou: return @"highest_rated_you";
        case BDKUntappdDistinctBeerSortTypeLowestRatedByYou: return @"lowest_rated_you";
    }
}

- (NSString *)parameterValueForBeerSearchSortType:(BDKUntappdBeerSearchSortType)sortType {
    switch (sortType) {
        case BDKUntappdBeerSearchSortTypeAlphabetical: return @"name";
        case BDKUntappdBeerSearchSortTypeMostCheckins: return @"count";
    }
}

@end
