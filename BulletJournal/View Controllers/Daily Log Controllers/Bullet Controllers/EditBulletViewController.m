//
//  EditBulletViewController.m
//  BulletJournal
//
//  Created by tomisin on 7/19/21.
//

#import "EditBulletViewController.h"

#import "Parse/Parse.h"
#import "DatabaseUtilities.h"
#import "StyleMethods.h"

@interface EditBulletViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *typePicker;
@property (strong, nonatomic) NSArray *bulletTypePickerArray;
@property (weak, nonatomic) IBOutlet UITextField *desc;
@property (weak, nonatomic) IBOutlet UISwitch *completed;
@property (weak, nonatomic) IBOutlet UISwitch *unnecessary;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *editBulletButton;



@end

@implementation EditBulletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.typePicker.dataSource = self;
    self.typePicker.delegate = self;
    
    self.bulletTypePickerArray = [NSArray arrayWithObjects:@"Task", @"Event", @"Note", nil];
    
    //TODO: Fix inefficient code, maybe Enum
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
    
    [self.unnecessary setOn:!self.bullet[@"Relevant"]];
    [self.completed setOn:!self.bullet[@"Completed"]];
    self.desc.text = self.bullet[@"Description"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [StyleMethods styleBackground:self];
    [StyleMethods styleButtons:self.editBulletButton];
    [StyleMethods styleTextField:self.desc];
    
}

-(void)dismissKeyboard
{
    [self.desc resignFirstResponder];
}

- (IBAction)didEditBullet:(id)sender {
    [self.activityIndicator startAnimating];
    PFQuery *query = [PFQuery queryWithClassName:@"Bullet"];
    
    //Delete bullet that already exists in backend
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable bullets, NSError * _Nullable error) {
        if (bullets != nil) {
            for (PFObject *bullet in bullets) {
                PFUser *bulletUser = bullet[@"User"];
                if([bullet[@"Description"] isEqualToString:self.bullet[@"Description"]] && [[PFUser.currentUser objectId] isEqual:[bulletUser objectId]]){
                    [bullet deleteInBackground];
                    NSLog(@"Deleting Bullet: %@", bullet);
                }
            }
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
        [self.activityIndicator stopAnimating];
    }];
    
    //Create new bullet with updated information
    NSDate *today = [NSDate date];
    NSString *dateString = [DatabaseUtilities getDateString:today]; //TODO: double check that you only want to use today and not self.date
    NSInteger row = [self.typePicker selectedRowInComponent:0];
    NSString *type = [self.bulletTypePickerArray objectAtIndex:row];
    [DatabaseUtilities createBullet:PFUser.user withType:type withRelevancy:[NSNumber numberWithBool:!self.unnecessary.isOn] withCompletion:[NSNumber numberWithBool:self.completed.isOn] withDescription:self.desc.text withDate:dateString];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
    [self presentViewController:homeVC animated:YES completion:nil];
    
    
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


@end
