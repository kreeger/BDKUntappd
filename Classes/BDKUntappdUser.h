//
//  BDKUntappdUser.h
//  Pods
//
//  Created by Ben Kreeger on 3/9/14.
//
//

#import "BDKUntappdModel.h"

@interface BDKUntappdUser : BDKUntappdModel

@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *facebookIdentifier;
@property (strong, nonatomic) NSString *foursquareIdentifier;
@property (strong, nonatomic) NSString *twitterIdentifier;
@property (strong, nonatomic) NSString *firstName;
@property (assign, nonatomic, getter = isPrivateUser) BOOL privateUser;
@property (assign, nonatomic, getter = isSupporter) BOOL supporter;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *relationship;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSURL *userAvatar;
@property (strong, nonatomic) NSString *userName;

@end
