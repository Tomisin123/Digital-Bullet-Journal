//
//  EditHabitViewController.m
//  BulletJournal
//
//  Created by tomisin on 8/5/21.
//

#import "EditHabitViewController.h"

#import "DatabaseUtilities.h"
#import "FSCalendar.h"
#import "NSDate+Utilities.h"
#import "StyleMethods.h"

@interface EditHabitViewController () <FSCalendarDelegate, FSCalendarDelegateAppearance, FSCalendarDataSource>

@property (weak, nonatomic) IBOutlet UITextField *habitName;
@property (weak, nonatomic) IBOutlet UITextView *reason;
@property (strong, nonatomic) NSArray *datesCompleted;
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIButton *editHabitButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteHabitButton;

@end

@implementation EditHabitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Initializing Calendar information
    self.calendar.delegate = self;
    self.calendar.dataSource = self;
    self.calendar.appearance.todayColor = [UIColor whiteColor];
    
    self.habitName.text = self.habit[@"Name"];
    self.reason.text = self.habit[@"Reason"];
    self.datesCompleted = self.habit[@"DatesCompleted"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [StyleMethods styleBackground:self];
    [StyleMethods styleCalendar:self.calendar];
    [StyleMethods styleButtons:self.editHabitButton];
    [StyleMethods styleButtons:self.deleteHabitButton];
}

-(void)dismissKeyboard
{
    [self.habitName resignFirstResponder];
    [self.reason resignFirstResponder];
}


- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date{
    
    if ([self.datesCompleted containsObject:date]){
        return [UIColor greenColor];
    }
    return [UIColor systemPinkColor];
}

- (IBAction)didEditHabit:(id)sender {
    
    [self didDeleteHabit:nil];
    
    [DatabaseUtilities createHabit:PFUser.currentUser withName:self.habitName.text withReason:self.reason.text withDatesCompleted:self.datesCompleted];

    
}

- (IBAction)didDeleteHabit:(id)sender {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Habit"];

    //Delete habit that already exists in backend
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable habits, NSError * _Nullable error) {
        if (habits != nil) {
            for (PFObject *habit in habits) {
                PFUser *habitUser = habit[@"User"];
                if([habit[@"Reason"] isEqualToString:self.habit[@"Reason"]] && [[PFUser.currentUser objectId] isEqual:[habitUser objectId]]){
                    [habit deleteInBackground];
                    NSLog(@"Deleting Habit: %@", habit);
                }
            }
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}



@end
