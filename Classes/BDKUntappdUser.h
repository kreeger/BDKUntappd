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
@property (strong, nonatomic) NSDictionary *contact;
@property (strong, nonatomic) NSString *firstName;
@property (assign, nonatomic) BOOL isPrivate;
@property (assign, nonatomic) BOOL isSupporter;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *relationship;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSURL *userAvatar;
@property (strong, nonatomic) NSString *userName;

@end
