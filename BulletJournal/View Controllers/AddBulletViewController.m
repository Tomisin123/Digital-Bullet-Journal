//
//  AddBulletViewController.m
//  BulletJournal
//
//  Created by tomisin on 7/19/21.
//

#import "AddBulletViewController.h"

#import "Parse/Parse.h"

@interface AddBulletViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *typePicker;
@property (strong, nonatomic) NSArray *bulletTypePickerArray;
@property (weak, nonatomic) IBOutlet UITextField *desc;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation AddBulletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.typePicker.dataSource = self;
    self.typePicker.delegate = self;

    self.bulletTypePickerArray = [NSArray arrayWithObjects:@"Task", @"Event", @"Note", nil];
    
}

- (IBAction)didCreateBullet:(id)sender {
    
    PFObject *bullet = [PFObject objectWithClassName:@"Bullet"];
    bullet[@"User"] = PFUser.currentUser;
    NSInteger row = [self.typePicker selectedRowInComponent:0];
    bullet[@"Type"] = [self.bulletTypePickerArray objectAtIndex:row];
    bullet[@"Relevant"] = @YES;
    bullet[@"Completed"] = @NO;
    bullet[@"Description"] = self.desc.text;
    NSDate *dateSelected = [self.datePicker date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:dateSelected];
    bullet[@"Date"] = dateString;
    
    [bullet saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Object saved!");
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView
numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString * title = [self.bulletTypePickerArray objectAtIndex:row];;
    
    return title;
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
