//
//  DailyTodoViewController.h
//  BulletJournal
//
//  Created by tomisin on 7/14/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DailyTodoViewController : UIViewController

@property (nonatomic, strong) NSDate *date;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
