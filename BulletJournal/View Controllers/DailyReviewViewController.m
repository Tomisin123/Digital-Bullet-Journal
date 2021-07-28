//
//  DailyReviewViewController.m
//  BulletJournal
//
//  Created by tomisin on 7/14/21.
//

#import "DailyReviewViewController.h"

#import "Parse/Parse.h"

@interface DailyReviewViewController ()
@property (weak, nonatomic) IBOutlet UITextView *reviewText;

@end

@implementation DailyReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //TODO: load review if it exists
    
}



- (IBAction)didSaveReview:(id)sender {
    
    PFObject *review = [PFObject objectWithClassName:@"Review"];
    review[@"User"] = PFUser.currentUser;
    review[@"Text"] = self.reviewText.text;
    
    [review saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Object saved!");
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
    
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
