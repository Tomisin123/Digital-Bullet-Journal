//
//  AddHabitViewController.m
//  BulletJournal
//
//  Created by tomisin on 8/5/21.
//

#import "AddHabitViewController.h"

#import "Parse/Parse.h"
#import "DatabaseUtilities.h"
#import "StyleMethods.h"

@interface AddHabitViewController ()
@property (weak, nonatomic) IBOutlet UITextField *habitName;
@property (weak, nonatomic) IBOutlet UITextView *reason;
@property (weak, nonatomic) IBOutlet UIButton *addHabitButton;

@end

@implementation AddHabitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [StyleMethods styleBackground:self];
    [StyleMethods styleButtons:self.addHabitButton];
}

-(void)dismissKeyboard
{
    [self.habitName resignFirstResponder];
    [self.reason resignFirstResponder];
}


- (IBAction)didCreateHabit:(id)sender {
        
    [DatabaseUtilities createHabit:PFUser.currentUser withName:self.habitName.text withReason:self.reason.text withDatesCompleted: [[NSArray alloc] init]];
    
}

@end
