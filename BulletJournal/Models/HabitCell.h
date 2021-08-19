//
//  HabitCell.h
//  BulletJournal
//
//  Created by tomisin on 8/5/21.
//

#import <UIKit/UIKit.h>

#import "Habit.h"

#import <Charts/Charts-Swift.h>
#import <Charts/Charts-umbrella.h>

NS_ASSUME_NONNULL_BEGIN

@interface HabitCell : UITableViewCell
@property (strong, nonatomic) Habit *habit;
@property (weak, nonatomic) IBOutlet UILabel *habitName; // name of habit
@property (weak, nonatomic) IBOutlet UILabel *reason; // reason for keeping habit
@property (weak, nonatomic) IBOutlet UILabel *streakNumber;
@property (weak, nonatomic) IBOutlet PieChartView *pieChartView;


@end

NS_ASSUME_NONNULL_END
