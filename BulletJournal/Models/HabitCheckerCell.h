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
@property (weak, nonatomic) IBOutlet UISwitch *completed; // switch that determines whether a habit was completed for the day
@property (weak, nonatomic) IBOutlet UILabel *habitName; //name of habit

@end

NS_ASSUME_NONNULL_END
