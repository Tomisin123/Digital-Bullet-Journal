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
    
    //TODO: potentially repetitive code
    PFObject *habit = [PFObject objectWithClassName:@"Habit"];
    habit[@"User"] = PFUser.currentUser;
    habit[@"Name"] = self.habitName.text;
    habit[@"Reason"] = self.reason.text;
    habit[@"DatesCompleted"] = [[NSArray alloc] init];
    
    [habit saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Object saved!");
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
}

@end
