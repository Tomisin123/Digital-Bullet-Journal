//
//  DailyTodoViewController.m
//  BulletJournal
//
//  Created by tomisin on 7/14/21.
//

#import "DailyTodoViewController.h"

#import "BulletCell.h"
#import "Parse/Parse.h"
#import "EditBulletViewController.h"
#import "DailyTabBarController.h"
#import "NSDate+Utilities.h"

@interface DailyTodoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *bullets;

@end

@implementation DailyTodoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.bullets = [[NSMutableArray alloc] init];
    
    //Setting Date for Bullet Recall
    if (self.date == nil){
        NSLog(@"No Date given, using today");
        self.date = [[NSDate date] dateAtStartOfDay];
    }
    else{
        NSLog(@"Date given: %@", self.date);
    }
    
    [self fetchBullets];
    
    
    
}

- (void) fetchBullets {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd/MM/yyyy";
    NSString *dateString = [formatter stringFromDate:self.date];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Bullet"];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *bullets, NSError *error){
        if (bullets != nil) {
            unsigned long i, cnt = [bullets count];
            for(i = 0; i < cnt; i++)
            {
                NSString *bulletDate = [bullets objectAtIndex:i][@"Date"];
                if ([bulletDate isEqualToString:dateString]){
                    [self.bullets addObject:[bullets objectAtIndex:i]];
                }
            }
            
            [self.tableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BulletCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BulletCell"];
    cell.bullet = self.bullets[indexPath.row];
    cell.desc.text = cell.bullet[@"Description"];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    return self.bullets.count;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual:@"editBulletSegue"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        NSDictionary *bullet = self.bullets[indexPath.row];
        EditBulletViewController *editBulletVC = [segue destinationViewController];
        editBulletVC.bullet = bullet;
        NSLog(@"Tapping on a bullet: %@", bullet[@"Description"]);
    }
    
    
    
}


@end
