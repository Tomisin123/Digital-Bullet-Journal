//
//  EditBulletViewController.m
//  BulletJournal
//
//  Created by tomisin on 7/19/21.
//

#import "EditBulletViewController.h"

#import "Parse/Parse.h"

@interface EditBulletViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *typePicker;
@property (strong, nonatomic) NSArray *bulletTypePickerArray;
@property (weak, nonatomic) IBOutlet UITextField *desc;
@property (weak, nonatomic) IBOutlet UISwitch *completed;
@property (weak, nonatomic) IBOutlet UISwitch *unnecessary;



@end

@implementation EditBulletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.typePicker.dataSource = self;
    self.typePicker.delegate = self;
    
    //TODO: set Picker Array to type already picked
    self.bulletTypePickerArray = [NSArray arrayWithObjects:@"Task", @"Event", @"Note", nil];
    
    //TODO: Fix inefficient code
    NSString *bulletType = self.bullet[@"Type"];
    if([bulletType isEqualToString:@"Task"]){
        [self.typePicker selectRow:0 inComponent:0 animated:NO];
    }
    else if ([bulletType isEqualToString:@"Event"]){
        [self.typePicker selectRow:1 inComponent:0 animated:NO];
    }
    else if ([bulletType isEqualToString:@"Note"]){
        [self.typePicker selectRow:2 inComponent:0 animated:NO];
    }
    else{
        NSLog(@"Invalid Bullet Type");
    }
    
    [self.unnecessary setOn:NO];
    [self.completed setOn:NO];
    
    self.desc.text = self.bullet[@"Description"];
}

- (IBAction)didEditBullet:(id)sender {
    
    PFObject *bullet = [PFObject objectWithClassName:@"Bullet"];
    PFQuery *query = [PFQuery queryWithClassName:@"Bullet"];
    
    //Delete bullet that already exists in backend
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable bullets, NSError * _Nullable error) {
        //TODO: Make deletion criteria more robust
        if (bullets != nil) {
            for (PFObject *bullet in bullets) {
                if([bullet[@"Description"] isEqualToString:self.bullet[@"Description"]]){
                     [bullet deleteInBackground];
                    NSLog(@"Deleting Bullet: %@", bullet);
                }
            }
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    //Create new bullet with updated information
    bullet[@"User"] = PFUser.currentUser;
    NSInteger row = [self.typePicker selectedRowInComponent:0];
    bullet[@"Type"] = [self.bulletTypePickerArray objectAtIndex:row];;
    bullet[@"Relevant"] = [NSNumber numberWithBool:!self.unnecessary.isOn];
    bullet[@"Completed"] = [NSNumber numberWithBool:self.completed.isOn];
    bullet[@"Description"] = self.desc.text;
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
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
