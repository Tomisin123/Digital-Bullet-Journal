//
//  LoginViewController.m
//  BulletJournal
//
//  Created by tomisin on 7/14/21.
//

#import "LoginViewController.h"

#import "Parse/Parse.h"
#import <QuartzCore/QuartzCore.h>
#import "StyleMethods.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) UIAlertController *alert;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.alert = [UIAlertController alertControllerWithTitle:@"Error logging in"
                                                                               message:@"Please recheck credentials"
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle cancel response here. Doing nothing will dismiss the view.
                                                      }];
    // add the cancel action to the alertController
    [self.alert addAction:cancelAction];

    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [self.alert addAction:okAction];
        
    [StyleMethods styleBackground:self];
    [StyleMethods styleLoginTextFields:self.usernameField];
    [StyleMethods styleLoginTextFields:self.passwordField];
    [StyleMethods styleButtons:self.loginButton];
    [StyleMethods styleButtons:self.signUpButton];
    
}


- (IBAction)didSignUp:(id)sender {
    if ([self checkFields]){
        NSLog(@"Signing up...");
        [self registerUser];
    }
}

- (IBAction)didLogin:(id)sender {
    if ([self checkFields]){
        NSLog(@"Logging in...");
        [self loginUser];
    }
}

- (BOOL) checkFields {
    if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]){
        return NO;
    }
    return YES;
}

- (void)registerUser {
    
    NSLog(@"Entered Register User Function");
    
    // initialize a user object
    PFUser *newUser = [PFUser user];
    NSLog(@"Made a new user");
    
    // set user properties
    newUser.username = self.usernameField.text;
    //newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            [self presentViewController:self.alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
        } else {
            NSLog(@"User registered successfully");
            
            // manually segue to logged in view
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (void)loginUser {
    
    NSLog(@"Entered Login User Function");
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [self presentViewController:self.alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
        } else {
            NSLog(@"User logged in successfully");
            
            // display view controller that needs to shown after successful login
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

@end
