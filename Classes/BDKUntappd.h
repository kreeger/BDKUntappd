//
//  BDKUntappd.h
//

@import Foundation;
#import <AFNetworking/AFHTTPSessionManager.h>
#import "BDKUntappdModels.h"

typedef void (^BDKUntappdResultBlock)(id responseObject, NSError *error);

//sort (string, optional) - Your can sort the results using these values: date - sorts by date (default), checkin - sorted by highest checkin, highest_rated - sorts by global rating descending order, lowest_rated - sorts by global rating ascending order, highest_abv - highest ABV from the wishlist, lowest_abv - lowest ABV from the wishlist

typedef NS_ENUM(NSInteger, BDKUntappdWishListSortType) {
    BDKUntappdWishListSortTypeMostRecent,
    BDKUntappdWishListSortTypeMostCheckins,
    BDKUntappdWishListSortTypeHighestRated,
    BDKUntappdWishListSortTypeLowestRated,
    BDKUntappdWishListSortTypeHighestABV,
    BDKUntappdWishListSortTypeLowestABV
};

// sort (string, optional) - Your can sort the results using these values: date - sorts by date (default), checkin - sorted by highest checkin, highest_rated - sorts by global rating descending order, lowest_rated - sorts by global rating ascending order, highest_rated_you - the user's highest rated beer, lowest_rated_you - the user's lowest rated beer

typedef NS_ENUM(NSInteger, BDKUntappdDistinctBeerSortType) {
    BDKUntappdDistinctBeerSortTypeMostRecent,
    BDKUntappdDistinctBeerSortTypeMostCheckins,
    BDKUntappdDistinctBeerSortTypeHighestRated,
    BDKUntappdDistinctBeerSortTypeLowestRated,
    BDKUntappdDistinctBeerSortTypeHighestRatedByYou,
    BDKUntappdDistinctBeerSortTypeLowestRatedByYou
};

typedef NS_ENUM(NSInteger, BDKUntappdBeerSearchSortType) {
    BDKUntappdBeerSearchSortTypeAlphabetical,
    BDKUntappdBeerSearchSortTypeMostCheckins
};

typedef NS_OPTIONS(NSInteger, BDKUntappdCheckinPostTo) {
    BDKUntappdCheckinPostToFacebook   = (1 << 0),
    BDKUntappdCheckinPostToTwitter    = (1 << 1),
    BDKUntappdCheckinPostToFoursquare = (1 << 2)
};

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


#pragma mark - Object detail calls

/**
 Gets information for a given brewery.
 
 @discussion See https://untappd.com/api/docs#brewery_info
 
 @param breweryID Required; the brewery ID for which to retrieve a information.
 @param compact If `YES`, only basic info is returned; if `NO`, a full object including checkins and a beer list will
                be returned.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)infoForBrewery:(NSNumber *)breweryID compact:(BOOL)compact completion:(BDKUntappdResultBlock)completion;

/**
 Gets information for a given beer.
 
 @discussion See https://untappd.com/api/docs#beer_info
 
 @param beerID Required; the beer ID for which to retrieve a information.
 @param compact If `YES`, only basic info is returned; if `NO`, a full object including checkins and a beer list will
                be returned.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)infoForBeer:(NSNumber *)beerID compact:(BOOL)compact completion:(BDKUntappdResultBlock)completion;

/**
 Gets information for a given venue.
 
 @discussion See https://untappd.com/api/docs#venue_info
 
 @param venueID Required; the venue ID for which to retrieve a information.
 @param compact If `YES`, only basic info is returned; if `NO`, a full object including checkins and a beer list will
                be returned.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)infoForVenue:(NSNumber *)venueID compact:(BOOL)compact completion:(BDKUntappdResultBlock)completion;

/**
 This method will allow you to pass in a Foursquare v2 ID and return a basic Untappd Venue object with identifier.
 
 @param foursquareLocationID The Foursquare MD5 hash ID of the location you'd like to lookup in Untappd's data.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)venueForFoursquareLocationID:(NSString *)foursquareLocationID completion:(BDKUntappdResultBlock)completion;

/**
 Gets information for a given checkin.
 
 @discussion See https://untappd.com/api/docs#details
 
 @param checkinID Required; the checkin ID for which to retrieve a information.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)infoForCheckin:(NSNumber *)checkinID completion:(BDKUntappdResultBlock)completion;

/**
 Gets information for a given user. If username is nil, info for the currently-logged-in user will be retrieved.
 
 @discussion See https://untappd.com/api/docs#user_info
 
 @param username Required; the username for which to retrieve a information.
 @param compact If `YES`, only basic info is returned; if `NO`, a full object including checkins and a beer list will
 be returned.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)infoForUser:(NSString *)username compact:(BOOL)compact completion:(BDKUntappdResultBlock)completion;


#pragma mark - User detail calls

/**
 Gets 50 badges for a given user. If username is nil, info for the currently-logged-in user will be retrieved.
 
 @discussion See https://untappd.com/api/docs#user_info
 
 @param username Required; the username for which to retrieve a information.
 @param offset The numeric offset from which you what results to start.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)badgesForUser:(NSNumber *)username offset:(NSInteger)offset completion:(BDKUntappdResultBlock)completion;

/**
 Gets 25 friends for a given user. If username is nil, info for the currently-logged-in user will be retrieved.
 
 @discussion See https://untappd.com/api/docs#friends
 
 @param username Required; the username for which to retrieve a information.
 @param offset The numeric offset from which you what results to start.
 @param limit Limits the number of results returned; maximum of 25.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)friendsForUser:(NSNumber *)username
                offset:(NSInteger)offset
                 limit:(NSInteger)limit
            completion:(BDKUntappdResultBlock)completion;

/**
 Gets the wish list for a given user.
 
 @discussion See https://untappd.com/api/docs#wish_list
 
 @param username Required; the username for which to retrieve a information.
 @param sortBy The method by which you'd like to sort your results.
 @param offset The numeric offset from which you what results to start.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)wishListForUser:(NSNumber *)username
                 sortBy:(BDKUntappdWishListSortType)sortBy
                 offset:(NSInteger)offset
             completion:(BDKUntappdResultBlock)completion;

/**
 Gets a list of distinct beers for a user.
 
 @discussion See https://untappd.com/api/docs#user_distinct
 
 @param username Required; the username for which to retrieve a information.
 @param compact If `YES`, only basic info is returned; if `NO`, a full object including checkins and a beer list will
 be returned.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)distinctBeersForUser:(NSNumber *)username
                      sortBy:(BDKUntappdDistinctBeerSortType)sortBy
                      offset:(NSInteger)offset
                  completion:(BDKUntappdResultBlock)completion;


#pragma mark - Search and trending calls

/**
 Searches the Untappd database for a brewery (or breweries) matching a provided search term.

 @discussion See https://untappd.com/api/docs#brewery_search
 
 @param query Required; will be matched against Untappd's list of breweries.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)searchForBrewery:(NSString *)query completion:(BDKUntappdResultBlock)completion;

/**
 Searches the Untappd database for a beer (or beers) matching a provided search term. Allows for sorting by name or by
 checkin count.
 
 @discussion See https://untappd.com/api/docs#beer_search
 
 @param query Required; will be matched against Untappd's list of beers.
 @param sortBy Required; either BDKUntappdBeerSearchSortTypeAlphabetical (the default) or
               BDKUntappdBeerSearchSortTypeCheckinCount.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)searchForBeer:(NSString *)query
               sortBy:(BDKUntappdBeerSearchSortType)sortBy
           completion:(BDKUntappdResultBlock)completion;

/**
 Gets a list of trending beers globally.
 
 @discussion See https://untappd.com/api/docs#trending
 
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)trendingBeers:(BDKUntappdResultBlock)completion;


#pragma mark - Checking in, commenting, and toasting

/**
 Use this delightfully-verbose method to check into a beer. The only required parameter is beerID.
 
 @discussion See https://untappd.com/api/docs/v4#checkin
 
 @param beerID The Untappd ID of the beer you'd like to checkin to.
 @param foursquareLocationID The Foursquare MD5 hash ID of the location you'd like to add to your checkin, if any.
 @param latitude The GPS latitude of the checkin's location. Pass 0 if you'd like to omit this.
 @param longitude The GPS longitude of the checkin's location. Pass 0 if you'd like to omit this.
 @param shout An optional message you'd like to add to your checkin; maximum length is 140 characters.
 @param rating A rating you'd like to add to your checkin. If 0, this will be omitted; otherwise, max is 5.
 @param postTo A bitmask of locations where you'd like to cross-post this checkin. Pass in 0 if you're opting out;
               otherwise, pass in any combination of options.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)checkinToBeerID:(NSNumber *)beerID
   foursquareLocationID:(NSString *)foursquareLocationID
               latitude:(float)latitude
              longitude:(float)longitude
                  shout:(NSString *)shout
                 rating:(float)rating
                 postTo:(BDKUntappdCheckinPostTo)postTo
             completion:(BDKUntappdResultBlock)completion;

/**
 Adds a comment on a checkin.
 
 @discussion See https://untappd.com/api/docs/v4#add_comment
 
 @param comment The body of the comment to add. It must be less than 140 characters.
 @param checkinID The Untappd API identifier of the checkin on which to comment.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)addComment:(NSString *)comment toCheckin:(NSNumber *)checkinID completion:(BDKUntappdResultBlock)completion;

/**
 Removes a comment from a checkin.
 
 @discussion See https://untappd.com/api/docs/v4#delete_comment
 
 @param commentID The Untappd API identifier of the comment to delete.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)removeComment:(NSNumber *)commentID completion:(BDKUntappdResultBlock)completion;

/**
 Toasts or untoasts a user's checkin.
 
 @discussion See https://untappd.com/api/docs/v4#toast
 
 @param checkinID The Untappd API identifier of the checkin to toast.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
                   If toast was "un-toasted", the response object will be nil.
 */
- (void)toggleToastForCheckin:(NSNumber *)checkinID completion:(BDKUntappdResultBlock)completion;


#pragma mark - Wish list management

/**
 Adds a beer identified by a beer ID to the current user's wishlist.
 
 @discussion See https://untappd.com/api/docs/v4#add_to_wish
 
 @param beerID The Untappd API identifier for the beer you wish to save.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)addBeerID:(NSNumber *)beerID toWishlistWithCompletion:(BDKUntappdResultBlock)completion;

/**
 Removes a beer identified by a beer ID from the current user's wishlist.
 
 @discussion See https://untappd.com/api/docs/v4#remove_from_wish
 
 @param beerID The Untappd API identifier for the beer you wish to remove from the wishlist.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)removeBeerID:(NSNumber *)beerID fromWishlistWithCompletion:(BDKUntappdResultBlock)completion;


#pragma mark - Friend management

/**
 Gets a list of people pending the current user's friendship.
 
 @discussion See https://untappd.com/api/docs/v4#friend_pending
 
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)pendingFriendRequests:(BDKUntappdResultBlock)completion;

/**
 Approves a pending friend request with a user.
 
 @discussion See https://untappd.com/api/docs/v4#friend_accept
 
 @param userID The API identifier of the user you'd like to approve.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)approvePendingFriendshipForUserID:(NSNumber *)userID completion:(BDKUntappdResultBlock)completion;

/**
 Rejects a pending friend request with a user.
 
 @discussion See https://untappd.com/api/docs/v4#friend_reject
 
 @param userID The API identifier of the user you'd like to reject.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)rejectPendingFriendshipForUserID:(NSNumber *)userID completion:(BDKUntappdResultBlock)completion;

/**
 Revokes friendship status for a given user ID.
 
 @discussion See https://untappd.com/api/docs/v4#friend_revoke
 
 @param userID The API identifier of the user you'd like to revoke friendship from.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)revokeFriendshipForUserID:(NSNumber *)userID completion:(BDKUntappdResultBlock)completion;

/**
 Requests friendship status for a given user ID.
 
 @discussion See https://untappd.com/api/docs/v4#friend_request
 
 @param userID The API identifier of the user you'd like to request friendship with.
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)requestFriendshipForUserID:(NSNumber *)userID completion:(BDKUntappdResultBlock)completion;


#pragma mark - Notifications

/**
 Gets a feed of the 25 most recent notifications for the current user.
 
 @discussion See https://untappd.com/api/docs/v4#activity_on_you
 
 @param completion A block to be called upon completion; will get passed the response body and error if one occurred.
 */
- (void)notificationsForCurrentUser:(BDKUntappdResultBlock)completion;


@end
