//
//  AddHabitViewController.m
//  BulletJournal
//
//  Created by tomisin on 8/5/21.
//

#import "AddHabitViewController.h"

#import "Parse/Parse.h"

@interface AddHabitViewController ()
@property (weak, nonatomic) IBOutlet UITextField *habitName;
@property (weak, nonatomic) IBOutlet UITextView *reason;

@end

@implementation AddHabitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didCreateHabit:(id)sender {
    
    //TODO: probably change this to use Habit model
    PFObject *habit = [PFObject objectWithClassName:@"Habit"];
    habit[@"User"] = PFUser.currentUser;
    habit[@"Name"] = self.habitName.text;
    habit[@"Reason"] = self.reason.text;
    habit[@"DatesCompleted"] = [[NSArray alloc] init];
    //TODO: figure out dates completed
    
    [habit saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Object saved!");
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
