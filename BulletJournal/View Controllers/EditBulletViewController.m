//
//  EditBulletViewController.m
//  BulletJournal
//
//  Created by tomisin on 7/19/21.
//

#import "EditBulletViewController.h"

@interface EditBulletViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *typePicker;
@property (strong, nonatomic) NSArray *pickerArray;
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
    self.pickerArray = [NSArray arrayWithObjects:@"Task", @"Event", @"Note", nil];
}

- (void) loadData {
    
    //TODO: Load Bullet Data here
    
}

- (IBAction)didEditBullet:(id)sender {
    
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
