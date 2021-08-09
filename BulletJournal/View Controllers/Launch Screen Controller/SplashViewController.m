//
//  SplashViewController.m
//  BulletJournal
//
//  Created by tomisin on 8/8/21.
//

#import "SplashViewController.h"

#import <pop/POP.h>
#import "Parse/Parse.h"
#import "SceneDelegate.h"

@interface SplashViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *mainLogo;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    [self showSplash];
    
    
    
    
}

-(void) openHome {
    
    //User Persistence
    if (PFUser.currentUser) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
        [self presentViewController:homeVC animated:YES completion:nil];
    }
    else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

-(void) doAnimation {
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(.8, .8)];
    anim.velocity = [NSValue valueWithCGPoint:CGPointMake(.5, .5)];
    anim.springBounciness = 30.f;
    [self.mainLogo pop_addAnimation:anim forKey:@"myKey"];
    
    [self.mainLogo animationDuration];

}

- (void)showSplash {
    [self doAnimation];
  [self performSelector:@selector(openHome) withObject:nil afterDelay:2];
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
