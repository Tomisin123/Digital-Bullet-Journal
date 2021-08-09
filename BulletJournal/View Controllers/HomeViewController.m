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
//#import "APIManager.h"

#import "Parse/Parse.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//TODO: test log out method
- (IBAction)didLogOut:(id)sender {
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [PFUser logOut];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
    [self presentViewController:loginViewController animated:YES completion:nil];
//    appDelegate.window.rootViewController = loginViewController;
    
    //[[APIManager shared] logout];
}

@end
