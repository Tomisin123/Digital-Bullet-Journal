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

@interface HabitViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *habits;

@end

@implementation HabitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.habits = [[NSMutableArray alloc] init];
    [self fetchHabits];
    
}

//TODO: Get data to reload after adding new habit
//- (void)viewDidAppear:(BOOL)animated {
//    NSLog(@"View Will Appear");
//    self.habits = [[NSMutableArray alloc] init];
//    [self fetchHabits];
//}




- (void) fetchHabits {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Habit"];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *habits, NSError *error){
        if (habits != nil) {
            unsigned long i, cnt = [habits count];
            for(i = 0; i < cnt; i++)
            {
                //TODO: check if this is the correct User
                [self.habits addObject:[habits objectAtIndex:i]];
            }
            [self.tableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
        //[self.refreshControl endRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HabitCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"HabitCell"];
    cell.habit = self.habits[indexPath.row];
    cell.habitName.text = cell.habit[@"Name"];
    cell.reason.text = cell.habit[@"Reason"];
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
