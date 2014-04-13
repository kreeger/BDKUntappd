//
//  BDKUntappd.h
//
//  Created by Ben Kreeger on 3/4/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

@import Foundation;
#import <AFNetworking/AFHTTPSessionManager.h>

typedef void (^BDKUntappdResultBlock)(id responseObject, NSError *error);

extern NSString * const BDKUntappdBaseURL;

@class BDKUntappdParser;

/**
 Provides a standardized interface to the Untappd API.
 */
@interface BDKUntappd : AFHTTPSessionManager

@property (readonly, strong, nonatomic) NSString *clientId;
@property (readonly, strong, nonatomic) NSString *clientSecret;
@property (readonly, strong, nonatomic) NSString *redirectUrl;

@property (strong, nonatomic) NSString *accessToken;

@property (strong, nonatomic) BDKUntappdParser *parser;

/**
 Generates and returns an instance of this API client with OAuth2 credentials.
 
 @param clientID The Untappd API client ID.
 @param clientSecret The Untappd API client secret.
 @param redirectUrl The redirect URL that your application has registered with the Untappd API.
 
 @returns An instance of this adapter.
 */
- (instancetype)initWithClientId:(NSString *)clientId
                    clientSecret:(NSString *)clientSecret
                     redirectUrl:(NSString *)redirectUrl;

#pragma mark - Authentication

/**
 Creates an NSURLRequest that you can pass to a web view to load up the beginning of the OAuth2 flow.
 
 @return A pre-baked NSURLRequest with your client ID and redirect URL in the query string.
 */
- (NSURLRequest *)authenticationURLRequest;

/**
 Uses the OAuth2 dance to swap a temporary access code for a full access token.
 Upon successful response, the access token is stored in this instance for future requests.
 
 @param accessCode The access code to store; will be saved as `self.accessCode`.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)authorizeForAccessCode:(NSString *)accessCode completion:(BDKUntappdResultBlock)completion;

#pragma mark - Checkin feeds

/**
 Gets the latest checkins for the currently-logged-in user's friends.
 
 @discussion See https://untappd.com/api/docs#feed
 
 @param maxID The checkin ID that you want results to start with. Optional.
 @param limit The number of results to return; if set to 0, default value of 25 will be used.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)checkinsForFriendsWithMaxID:(NSNumber *)maxID
                              limit:(NSInteger)limit
                         completion:(BDKUntappdResultBlock)completion;

/**
 Gets the latest checkins for a particular user. You may omit the username; if so, the current user's checkins will be
 retrieved.
 
 @discussion See https://untappd.com/api/docs#user_feed
 
 @param username The username of the user for which to retrieve checkins.
 @param maxID The checkin ID that you want results to start with. Optional.
 @param limit The number of results to return; if set to 0, default value of 25 will be used.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)checkinsForUser:(NSString *)username
                  maxID:(NSNumber *)maxID
                  limit:(NSInteger)limit
             completion:(BDKUntappdResultBlock)completion;

/**
 Retrieves nearby user checkins for a given set of coordinates and radius.
 
 @discussion See https://untappd.com/api/docs#thepublocal
 
 @param latitude The latitude of the coordinate set. Optional (set to 0 if not desired).
 @param longitude The longitude of the coordinate set. Optional (set to 0 if not desired).
 @param radius The search radius to use. Optional (set to 0 if not desired).
 @param minID The minimum checkin ID for which to retrieve checkin data. Optional.
 @param maxID The maximum checkin ID for which to retrieve checkin data. Optional.
 @param limit The number of results to return; if set to 0, default value of 25 will be used.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)publicFeedForLatitude:(float)latitude
                    longitude:(float)longitude
                       radius:(NSInteger)radius
                        minID:(NSNumber *)minID
                        maxID:(NSNumber *)maxID
                        limit:(NSInteger)limit
                   completion:(BDKUntappdResultBlock)completion;

/**
 Retrieves checkins for a given venue.
 
 @discussion See https://untappd.com/api/docs#venue_checkins
 
 @param venueID Required; the venue ID for which to retrieve checkins.
 @param minID The minimum checkin ID for which to retrieve checkin data. Optional.
 @param maxID The maximum checkin ID for which to retrieve checkin data. Optional.
 @param limit The number of results to return; if set to 0, default value of 25 will be used.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)checkinsForVenue:(NSNumber *)venueID
                   minID:(NSNumber *)minID
                   maxID:(NSNumber *)maxID
                   limit:(NSInteger)limit
              completion:(BDKUntappdResultBlock)completion;

/**
 Retrieves checkins for a given beer.
 
 @discussion See https://untappd.com/api/docs#beer_checkins
 
 @param beerID Required; the beer ID for which to retrieve checkins.
 @param minID The minimum checkin ID for which to retrieve checkin data. Optional.
 @param maxID The maximum checkin ID for which to retrieve checkin data.
 @param limit The number of results to return; if set to 0, default value of 25 will be used.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)checkinsForBeer:(NSNumber *)beerID
                  minID:(NSNumber *)minID
                  maxID:(NSNumber *)maxID
                  limit:(NSInteger)limit
             completion:(BDKUntappdResultBlock)completion;

/**
 Retrieves checkins for a given brewery.
 
 @discussion See https://untappd.com/api/docs#brewery_checkins
 
 @param beerID Required; the beer ID for which to retrieve checkins.
 @param minID The minimum checkin ID for which to retrieve checkin data. Optional.
 @param maxID The maximum checkin ID for which to retrieve checkin data.
 @param limit The number of results to return; if set to 0, default value of 25 will be used.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)checkinsForBrewery:(NSNumber *)breweryID
                     minID:(NSNumber *)minID
                     maxID:(NSNumber *)maxID
                     limit:(NSInteger)limit
                completion:(BDKUntappdResultBlock)completion;


@end
