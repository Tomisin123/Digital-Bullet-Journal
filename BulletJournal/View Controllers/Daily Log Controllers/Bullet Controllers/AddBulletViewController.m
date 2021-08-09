//
//  AddBulletViewController.m
//  BulletJournal
//
//  Created by tomisin on 7/19/21.
//

#import "AddBulletViewController.h"

#import "Parse/Parse.h"
#import "DatabaseUtilities.h"
#import "DailyTodoViewController.h"

@interface AddBulletViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *typePicker;
@property (strong, nonatomic) NSArray *bulletTypePickerArray;
@property (weak, nonatomic) IBOutlet UITextField *desc;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation AddBulletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.typePicker.dataSource = self;
    self.typePicker.delegate = self;
    
    //TODO: make some type of enum out of this
    self.bulletTypePickerArray = [NSArray arrayWithObjects:@"Task", @"Event", @"Note", nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
}

-(void)dismissKeyboard
{
    [self.desc resignFirstResponder];
}

- (IBAction)didCreateBullet:(id)sender {
    
    //TODO: have to change createBullet if creating enum, also need to change last pickerView method
    
    NSInteger row = [self.typePicker selectedRowInComponent:0];
    NSString *type = [self.bulletTypePickerArray objectAtIndex:row];
    
    NSDate *dateSelected = [self.datePicker date];
    NSString *dateString = [DatabaseUtilities getDateString:dateSelected];
    
//    [DatabaseUtilities createBullet:PFUser.currentUser withType:type withRelevancy:@YES withCompletion:@NO withDescription:self.desc.text withDate:dateString];
    
    PFObject *bullet = [PFObject objectWithClassName:@"Bullet"];
    bullet[@"User"] = PFUser.currentUser;
    bullet[@"Type"] = type;
    bullet[@"Relevant"] = @YES;
    bullet[@"Completed"] = @NO;
    bullet[@"Description"] = self.desc.text;
    bullet[@"Date"] = dateString;
    
    [bullet saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Object saved!");
        } else {
            NSLog(@"Error: %@", error.description);
        }
        [self dismissViewControllerAnimated:TRUE completion:nil];
    }];
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSLog(@"View Will Disappear");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DailyTodoViewController *dailyTodoVC = [storyboard instantiateViewControllerWithIdentifier:@"DailyTodoViewController"];
    [dailyTodoVC.tableView reloadData];


}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView
numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString * title = [self.bulletTypePickerArray objectAtIndex:row];;
    return title;
}

@end
