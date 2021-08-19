//
//  HomeViewController.m
//  BulletJournal
//
//  Created by tomisin on 7/14/21.
//

#import "HomeViewController.h"

//for logout method
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "StyleMethods.h"

#import "Parse/Parse.h"
#import "NSDate+Utilities.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *dailyLogButton;
@property (weak, nonatomic) IBOutlet UIButton *habitTrackerButton;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [StyleMethods styleBackground:self];
    [StyleMethods styleButtons:self.dailyLogButton];
    [StyleMethods styleButtons:self.habitTrackerButton];
    [StyleMethods styleButtons:self.calendarButton];
}

- (IBAction)didLogOut:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [PFUser logOut];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
    [self presentViewController:loginViewController animated:YES completion:nil];

}

@end
