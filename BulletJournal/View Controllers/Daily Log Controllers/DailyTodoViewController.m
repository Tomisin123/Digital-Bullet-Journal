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
#import "DatabaseUtilities.h"

@interface DailyTodoViewController () <UITableViewDelegate, UITableViewDataSource>

//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *bullets;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation DailyTodoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.activityIndicator startAnimating];
    
    //Setting Date for Bullet Recall
    if (self.date == nil){
        NSLog(@"No Date given, using today");
        self.date = [[NSDate date] dateAtStartOfDay];
    }
    else{
        NSLog(@"Date given: %@", self.date);
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.bullets = [[NSMutableArray alloc] init];
    
    [self fetchBullets];
    
}

- (void) fetchBullets {
    
    NSString *dateString = [DatabaseUtilities getDateString:self.date];
    
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
        
        [self.activityIndicator stopAnimating];
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BulletCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BulletCell"];
    cell.bullet = self.bullets[indexPath.row];
    cell.desc.text = cell.bullet[@"Description"];
    
    if([cell.bullet[@"Completed"]  isEqual: @YES]){
        cell.desc.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    }
    if([cell.bullet[@"Relevant"]  isEqual: @NO]){
        
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    return self.bullets.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *bullet = [self.bullets objectAtIndex:indexPath.row];
        [self deleteBullet:bullet];
        [self.bullets removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}

- (void)deleteBullet:(PFObject*)bullet {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Bullet"];

    //Delete habit that already exists in backend
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable bullets, NSError * _Nullable error) {
        if (bullets != nil) {
            for (PFObject *bulletObj in bullets) {
                PFUser *habitUser = bullet[@"User"];
                if([bulletObj[@"Description"] isEqualToString:bullet[@"Description"]] && [[PFUser.currentUser objectId] isEqual:[habitUser objectId]]){
                    [bulletObj deleteInBackground];
                    
                }
            }
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
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
