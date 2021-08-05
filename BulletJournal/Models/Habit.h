//
//  Habit.h
//  BulletJournal
//
//  Created by tomisin on 8/5/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Habit : PFObject

@property (nonatomic, strong) NSString *habit;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSArray *datesCompleted;
@property (nonatomic, strong) PFUser *user;

@end

NS_ASSUME_NONNULL_END
