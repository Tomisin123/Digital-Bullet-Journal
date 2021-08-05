//
//  HabitCheckerCell.h
//  BulletJournal
//
//  Created by tomisin on 8/5/21.
//

#import <UIKit/UIKit.h>

#import "Habit.h"

NS_ASSUME_NONNULL_BEGIN

@interface HabitCheckerCell : UITableViewCell

@property (strong, nonatomic) Habit *habit;
@property (weak, nonatomic) IBOutlet UISwitch *completed;
@property (weak, nonatomic) IBOutlet UILabel *habitName;

@end

NS_ASSUME_NONNULL_END
