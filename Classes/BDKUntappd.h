//
//  BDKUntappd.h
//
//  Created by Ben Kreeger on 3/4/14.
//  Copyright (c) 2014 Ben Kreeger. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>

typedef void (^BDKUntappdResultBlock)(id responseObject, NSError *error);

extern NSString * const BDKUntappdBaseURL;

/**
 Provides a standardized interface to the Untappd API.
 */
@interface BDKUntappd : AFHTTPSessionManager

@property (readonly, strong, nonatomic) NSString *clientId;
@property (readonly, strong, nonatomic) NSString *clientSecret;
@property (readonly, strong, nonatomic) NSString *redirectUrl;

@property (strong, nonatomic) NSString *accessToken;

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

#pragma mark - User data

/**
 Gets the latest checkins for a particular user. You may omit the username; if so, the current user's checkins will be
 retrieved.
 
 @param username The username of the user for which to retrieve checkins.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)checkinsForUser:(NSString *)username completion:(BDKUntappdResultBlock)completion;

@end
