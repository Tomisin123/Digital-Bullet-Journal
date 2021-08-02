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

@interface DailyTodoViewController () <UITableViewDelegate, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *posts;

@end

@implementation DailyTodoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.posts = [[NSMutableArray alloc] init];
    
    [self fetchPosts];
    
}

- (void) fetchPosts {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd/MM/yyyy";
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Bullet"];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error){
        if (posts != nil) {
            unsigned long i, cnt = [posts count];
            for(i = 0; i < cnt; i++)
            {
                NSString *postDate = [posts objectAtIndex:i][@"Date"];
                if ([postDate isEqualToString:dateString]){
                    [self.posts addObject:[posts objectAtIndex:i]];
                }
            }

            [self.tableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
        //[self.refreshControl endRefreshing];
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BulletCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BulletCell"];
    cell.bullet = self.posts[indexPath.row];
    cell.desc.text = cell.bullet[@"Description"];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    return self.posts.count;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([segue.identifier isEqual:@"editBulletSegue"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        NSDictionary *bullet = self.posts[indexPath.row];
        EditBulletViewController *editBulletVC = [segue destinationViewController];
        editBulletVC.bullet = bullet;
        NSLog(@"Tapping on a bullet: %@", bullet[@"Description"]);
    }
    
    
    
}


@end
