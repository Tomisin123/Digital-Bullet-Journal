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
    [self fetchReview];
    
}

//TODO: weird behaviours for when a review already exists, look at Back4App to know what I'm talking about
- (void) fetchReview {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd/MM/yyyy";
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Review"];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error){
        if (posts != nil) {
            unsigned long i, cnt = [posts count];
            for(i = 0; i < cnt; i++)
            {
                NSString *postDate = [posts objectAtIndex:i][@"Date"];
                if ([postDate isEqualToString:dateString] /*TODO: And User is equal to current user*/){
                    self.reviewText.text = [posts objectAtIndex:i][@"Text"];
                }
            }
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}

- (IBAction)didSaveReview:(id)sender {
    
    PFObject *review = [PFObject objectWithClassName:@"Review"];
    review[@"User"] = PFUser.currentUser;
    review[@"Text"] = self.reviewText.text;
    //TODO: repetitive code with AddBulletViewController
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    review[@"Date"] = dateString;
    
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
