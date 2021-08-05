//
//  DailyReviewViewController.m
//  BulletJournal
//
//  Created by tomisin on 7/14/21.
//

#import "DailyReviewViewController.h"

#import "Parse/Parse.h"
#import "Weather.h"
#import "WeatherRadar.h"
#import "CalendarViewController.h"
#import "HabitCheckerCell.h"
#import "NSDate+Utilities.h"

@interface DailyReviewViewController () <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextView *reviewText;

@property (strong, nonatomic) WeatherRadar *weatherRadar;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentUserLocation;
@property (strong, nonatomic) Weather *weather;
@property (weak, nonatomic) IBOutlet UITableView *habitsTableView;
@property (strong, nonatomic) NSMutableArray *habits;

@end

@implementation DailyReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //TODO: load review if it exists
    [self fetchReview];
    
    self.habits = [[NSMutableArray alloc] init];
    [self fetchHabits];
    
    self.habitsTableView.delegate = self;
    self.habitsTableView.dataSource = self;
    

    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization]; //non-blocking call
    self.currentUserLocation = [[CLLocation alloc] initWithLatitude:32.7767 longitude:-96.7970]; //TODO: This sets coordinates for Dallas, TX
    self.weatherRadar = [[WeatherRadar alloc] init];
    [self getWeather];
    
    self.date = [[NSDate date] dateAtStartOfDay]; //TODO: make this whatever date was passed in
    
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
    
    
    
    
    
    NSLog(@"User: %@ \n Review: %@ \n Date: %@ \n Weather: %@ \n Weather Condition: %@", PFUser.currentUser, self.reviewText.text, dateString, [self.weather class], self.weather.condition);
    
    //TODO: This doesn't work because I can't store classes
    //review[@"Weather"] = self.weather;//[self getWeather];
    
    [review saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Object saved!");
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
    
    
    
    //TODO: Store completed attribute for habit
    //For each habit that was completed
    for (HabitCheckerCell *checkerCell in [self.habitsTableView visibleCells]){
        Habit *habit = checkerCell.habit;
        NSLog(@"Checker Cell Habit: %@", checkerCell.habit);
        if ([checkerCell.completed isOn]){
            //Add date to datesCompleted for habit
            [self addHabitCompletionDate:habit :self.date];
        }
        else{
            //if date is not in datesCompleted for habit then there's nothing to worry about
            //if date is in datesCompleted, then we need to remove date from datesCompleted
            if ([habit[@"DatesCompleted"] containsObject:self.date]){
                [self deleteHabitCompletionDate:habit :self.date];
            }
        }
    }
    
}

- (void) getWeather {
    CLLocationCoordinate2D coordinate = [self.currentUserLocation coordinate];
    float latFloat = [[NSString stringWithFormat:@"%f", coordinate.latitude] floatValue];
    float longFloat = [[NSString stringWithFormat:@"%f", coordinate.longitude] floatValue];
    
    [self.weatherRadar getCurrentWeather:latFloat longitude:longFloat completionBlock:^(Weather *weather){
        self.weather = weather;
        NSLog(@"Self.weather: %@", self.weather);
    }];
    
}

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
            [self.habitsTableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
        //[self.refreshControl endRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HabitCheckerCell *cell = [self.habitsTableView dequeueReusableCellWithIdentifier:@"HabitCheckerCell"];
    cell.habit = self.habits[indexPath.row];
    
    cell.habitName.text = cell.habit[@"Name"];
    
    //Set on if habit was completed today
    if ([cell.habit[@"DatesCompleted"] containsObject:self.date]){
        [cell.completed setOn:YES];
    }
    else{
        [cell.completed setOn:NO];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.habits.count;
}





//MARK: similar to editHabitViewController
- (void) addHabitCompletionDate:(Habit*)habit :(NSDate*)dateOfCompletion {
    
    NSString *name = habit[@"Name"];
    NSString *reason = habit[@"Name"];
    NSMutableArray *datesCompleted = [[NSMutableArray alloc] init];
    for (NSDate *date in habit[@"DatesCompleted"]){
        [datesCompleted addObject:date];
    }
    [datesCompleted addObject:dateOfCompletion];
    
    [self deleteHabit:habit];
    
    PFObject *habitObj = [PFObject objectWithClassName:@"Habit"];
    habitObj[@"User"] = PFUser.currentUser;
    habitObj[@"Name"] = name;
    habitObj[@"Reason"] = reason;
    habitObj[@"DatesCompleted"] = datesCompleted;
    
    [habitObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Object saved!");
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
    
    
}

- (void) deleteHabitCompletionDate:(Habit*)habit :(NSDate*)dateOfCompletion {
    NSString *name = habit[@"Name"];
    NSString *reason = habit[@"Name"];
    NSMutableArray *datesCompleted = [[NSMutableArray alloc] init];
    for (NSDate *date in habit[@"DatesCompleted"]){
        [datesCompleted addObject:date];
    }
    [datesCompleted removeObject:dateOfCompletion];
    
    [self deleteHabit:habit];
    
    PFObject *habitObj = [PFObject objectWithClassName:@"Habit"];
    habitObj[@"User"] = PFUser.currentUser;
    habitObj[@"Name"] = name;
    habitObj[@"Reason"] = reason;
    habitObj[@"DatesCompleted"] = datesCompleted;
    
    [habitObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Object saved!");
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
}

- (void) deleteHabit: (Habit*)habit {
    PFQuery *query = [PFQuery queryWithClassName:@"Habit"];
    
    //Delete habit that already exists in backend
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable habits, NSError * _Nullable error) {
        if (habits != nil) {
            for (PFObject *habitObj in habits) {
                //TODO: Make deletion criteria more robust
                if([habitObj[@"Reason"] isEqualToString:habit[@"Reason"]]){
                     [habitObj deleteInBackground];
                    NSLog(@"Deleting Habit: %@", habitObj);
                }
            }
        }
        else{
            NSLog(@"%@", error.localizedDescription);
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
