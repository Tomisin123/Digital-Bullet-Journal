//
//  HabitViewController.m
//  BulletJournal
//
//  Created by tomisin on 8/5/21.
//

#import "HabitViewController.h"

#import "Parse/Parse.h"
#import "HabitCell.h"
#import "EditHabitViewController.h"
#import "AddHabitViewController.h"
#import "DatabaseUtilities.h"
#import "StyleMethods.h"

@interface HabitViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *habits;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *addNewHabitButton;

@end

@implementation HabitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.habits = [[NSMutableArray alloc] init];
    [self fetchHabits];
    
    [StyleMethods styleTableView:self.tableView];
    [StyleMethods styleButtons:self.addNewHabitButton];
}

- (void) fetchHabits {
    [self.activityIndicator startAnimating];

    PFQuery *query = [PFQuery queryWithClassName:@"Habit"];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *habits, NSError *error){
        if (habits != nil) {
            unsigned long i, cnt = [habits count];
            for(i = 0; i < cnt; i++)
            {
                PFUser *habitUser = [habits objectAtIndex:i][@"User"];
                if ([[PFUser.currentUser objectId] isEqual:[habitUser objectId]]){
                    [self.habits addObject:[habits objectAtIndex:i]];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HabitCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HabitCell"];
    cell.habit = self.habits[indexPath.row];
    cell.habitName.text = cell.habit[@"Name"];
    cell.reason.text = cell.habit[@"Reason"];
    UIColor *notebookPaper = [UIColor colorWithRed:224.0/255.0 green:201.0/255.0 blue:166.0/255.0 alpha:1];
    cell.backgroundColor = notebookPaper;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.habits.count;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual:@"editHabitSegue"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Habit *habit = self.habits[indexPath.row];
        EditHabitViewController *editHabitVC = [segue destinationViewController];
        editHabitVC.habit = habit;
        NSLog(@"Tapping on a habit: %@", habit[@"Name"]);
    }
    
    
}


@end
