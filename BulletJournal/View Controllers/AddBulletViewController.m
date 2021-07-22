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
@property (strong, nonatomic) NSArray *pickerArray;
@property (weak, nonatomic) IBOutlet UITextField *desc;

@end

@implementation AddBulletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.typePicker.dataSource = self;
    self.typePicker.delegate = self;
    
    self.pickerArray = [NSArray arrayWithObjects:@"Task", @"Event", @"Note", nil];
    
}

- (IBAction)didCreateBullet:(id)sender {
    
    PFObject *bullet = [PFObject objectWithClassName:@"Bullet"];
    bullet[@"User"] = PFUser.currentUser;
    NSInteger row = [self.typePicker selectedRowInComponent:0];
    bullet[@"Type"] = [self.pickerArray objectAtIndex:row];;
    bullet[@"Relevant"] = @YES;
    bullet[@"Completed"] = @NO;
    bullet[@"Description"] = self.desc.text;
    
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
    NSString * title = [self.pickerArray objectAtIndex:row];;
    
    return title;
}

//TODO: Remove this
//- (void)pickerView:(UIPickerView *)thePickerView
//      didSelectRow:(NSInteger)row
//       inComponent:(NSInteger)component {
//
//    //Here, like the table view you can get the each section of each row if you've multiple sections
//     NSLog(@"Selected Color: %@. Index of selected color: %i",
//     [arrayColors objectAtIndex:row], row);
//
//     //Now, if you want to navigate then;
//     // Say, OtherViewController is the controller, where you want to navigate:
//     OtherViewController *objOtherViewController = [OtherViewController new];
//     [self.navigationController pushViewController:objOtherViewController animated:YES];
//
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
