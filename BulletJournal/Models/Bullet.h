//
//  Bullet.h
//  BulletJournal
//
//  Created by tomisin on 7/15/21.
//

#import <Foundation/Foundation.h>

#import "Flair.h"
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Bullet : PFObject//NSObject

//MARK: Properties
//@property (nonatomic, strong) NSString *idStr; // For favoriting, retweeting & replying
@property (nonatomic, strong) NSString *desc; // Text content of bullet
@property (nonatomic) BOOL *completed; // Marks whether or not a bullet is completed
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) PFUser *user;


//MARK: Methods


@end

NS_ASSUME_NONNULL_END
