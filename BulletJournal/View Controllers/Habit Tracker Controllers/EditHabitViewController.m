//
//  EditHabitViewController.m
//  BulletJournal
//
//  Created by tomisin on 8/5/21.
//

#import "EditHabitViewController.h"

@interface EditHabitViewController ()
@property (weak, nonatomic) IBOutlet UITextField *habitName;
@property (weak, nonatomic) IBOutlet UITextView *reason;
@property (strong, nonatomic) NSArray *datesCompleted;

@end

@implementation EditHabitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.habitName.text = self.habit[@"Name"];
    self.reason.text = self.habit[@"Reason"];
    self.datesCompleted = self.habit[@"DatesCompleted"];
    
}

- (IBAction)didEditHabit:(id)sender {
    PFObject *habitObj = [PFObject objectWithClassName:@"Habit"];
    
    [self didDeleteHabit:nil];
    
    //TODO: potentially repetitive code
    habitObj[@"User"] = PFUser.currentUser;
    habitObj[@"Name"] = self.habitName.text;
    habitObj[@"Reason"] = self.reason.text;
    habitObj[@"DatesCompleted"] = self.datesCompleted;
    
    [habitObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Object saved!");
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
    
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
