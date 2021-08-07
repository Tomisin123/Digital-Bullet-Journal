//
//  Bullet.h
//  BulletJournal
//
//  Created by tomisin on 7/15/21.
//

#import <Foundation/Foundation.h>

#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Bullet : PFObject

//MARK: Properties
@property (nonatomic, strong) NSString *desc; // Text content of bullet
@property (nonatomic) BOOL *completed; // Marks whether or not a bullet is completed
@property (nonatomic, strong) NSString *type; // Marks type of bullet (Task, Event, or Note)
@property (nonatomic, strong) PFUser *user; // User who created bullet



@end

NS_ASSUME_NONNULL_END
