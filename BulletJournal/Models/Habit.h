//
//  Habit.h
//  BulletJournal
//
//  Created by tomisin on 8/5/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Habit : PFObject

@property (nonatomic, strong) NSString *habitName; // name of habit
@property (nonatomic, strong) NSString *reason; //reason for keeping habit
@property (nonatomic, strong) NSArray *datesCompleted; // list of dates habit was completed
@property (nonatomic, strong) PFUser *user; // user that created habit

@end

NS_ASSUME_NONNULL_END
