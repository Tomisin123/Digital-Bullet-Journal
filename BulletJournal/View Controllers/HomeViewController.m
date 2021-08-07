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

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//TODO: test log out method
- (IBAction)didLogOut:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    //[[APIManager shared] logout];
}

@end
