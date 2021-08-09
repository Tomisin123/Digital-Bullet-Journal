//
//  StyleMethods.m
//  BulletJournal
//
//  Created by tomisin on 8/9/21.
//

#import "StyleMethods.h"

#import "FSCalendar.h"

@implementation StyleMethods



+(void) styleBackground:(UIViewController*)vc {
    UIColor *notebookPaper = [UIColor colorWithRed:224.0/255.0 green:201.0/255.0 blue:166.0/255.0 alpha:1];
    vc.view.backgroundColor = notebookPaper;
}

+(void) styleButtons:(UIButton*)button {
    
    button.layer.cornerRadius = 8.0f;
    button.layer.borderColor = [[UIColor grayColor]CGColor];
    button.layer.borderWidth = 3.0f;
    button.layer.backgroundColor = [[UIColor lightGrayColor]CGColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

+(void) styleLoginTextFields:(UITextField*)textField {
    textField.layer.cornerRadius=8.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=[[UIColor grayColor]CGColor];
    textField.layer.borderWidth= 3.0f;
    textField.layer.cornerRadius = 15;
}

+(void) styleTableView:(UITableView*)tableView{
    UIColor *notebookPaper = [UIColor colorWithRed:224.0/255.0 green:201.0/255.0 blue:166.0/255.0 alpha:1];
    tableView.backgroundColor = notebookPaper;
}

+(void) styleCalendar:(FSCalendar*)calendar{
    UIColor *notebookPaper = [UIColor colorWithRed:224.0/255.0 green:201.0/255.0 blue:166.0/255.0 alpha:1];
    calendar.scope = FSCalendarScopeMonth;
    calendar.appearance.titleFont = [UIFont systemFontOfSize:15];
    calendar.appearance.headerTitleFont = [UIFont boldSystemFontOfSize:20];
    calendar.appearance.weekdayFont = [UIFont boldSystemFontOfSize:15];
    
    calendar.appearance.todayColor = [UIColor lightGrayColor];
    calendar.appearance.titleTodayColor = [UIColor whiteColor];
    calendar.appearance.headerTitleColor = [UIColor grayColor];
    calendar.appearance.weekdayTextColor = [UIColor blackColor];
    [calendar setBackgroundColor:notebookPaper];
}

+(void) styleTextField:(UITextField *)textField {
    textField.layer.cornerRadius=8.0f;
    textField.layer.masksToBounds=YES;
    textField.layer.borderColor=[[UIColor grayColor]CGColor];
    textField.layer.borderWidth= 3.0f;
    textField.layer.cornerRadius = 15;
}

+(void) styleTextView:(UITextView*)textView {
    textView.layer.cornerRadius=8.0f;
    textView.layer.masksToBounds=YES;
    textView.layer.borderColor=[[UIColor grayColor]CGColor];
    textView.layer.borderWidth= 3.0f;
    textView.layer.cornerRadius = 15;
}

@end
