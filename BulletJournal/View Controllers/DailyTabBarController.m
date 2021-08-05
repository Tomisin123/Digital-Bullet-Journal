//
//  DailyTabBarController.m
//  BulletJournal
//
//  Created by tomisin on 8/4/21.
//

#import "DailyTabBarController.h"

#import "DailyTodoViewController.h"
#import "DailyReviewViewController.h"

@interface DailyTabBarController ()

@end

@implementation DailyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    //TODO: MARK: Question: How do I pass this information from my tab bar controller to both of my tabs below?
    
    DailyTodoViewController *dailyTodoVC = [segue destinationViewController];
    dailyTodoVC.date = self.date;
    NSLog(@"Segueing date from daily tab bar: %@", self.date);
    
    DailyReviewViewController *dailyReviewVC = [segue destinationViewController];
    dailyReviewVC.date = self.date;
        
}


@end
