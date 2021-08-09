//
//  StyleMethods.h
//  BulletJournal
//
//  Created by tomisin on 8/9/21.
//

#import <UIKit/UIKit.h>

#import "FSCalendar.h"

NS_ASSUME_NONNULL_BEGIN

@interface StyleMethods : UIApplication

extern UIColor *notebookPaper;

+(void) styleBackground:(UIViewController*)vc;
+(void) styleButtons:(UIButton*)button;
+(void) styleLoginTextFields:(UITextField*)textField;
+(void) styleTableView:(UITableView*)tableView;
+(void) styleCalendar:(FSCalendar*)FSCalendar;

@end

NS_ASSUME_NONNULL_END
