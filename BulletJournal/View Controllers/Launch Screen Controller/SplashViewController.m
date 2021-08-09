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
        
    [self doAnimation:@"hi" completionBlock:^(NSDictionary * completion) {
        NSLog(@"hello");
    }];
    
}

-(void) doAnimation:(NSString*)dummy completionBlock:(void (^)(NSDictionary *))completionBlock {
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(.8, .8)];
    anim.velocity = [NSValue valueWithCGPoint:CGPointMake(.5, .5)];
    anim.springBounciness = 30.f;
    [self.mainLogo pop_addAnimation:anim forKey:@"myKey"];
    
    [self.mainLogo animationDuration];
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
