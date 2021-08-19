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
#import "DatabaseUtilities.h"
#import "Review.h"
#import "StyleMethods.h"

@interface DailyReviewViewController () <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextView *reviewText;
@property (strong, nonatomic) WeatherRadar *weatherRadar;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentUserLocation;
@property (strong, nonatomic) Weather *weather;
@property (weak, nonatomic) IBOutlet UITableView *habitsTableView;
@property (strong, nonatomic) NSMutableArray *habits;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) Review *review;
@property (weak, nonatomic) IBOutlet UIButton *saveReviewButton;

@end

@implementation DailyReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.activityIndicator startAnimating];
    
    if (self.date == nil) {
        self.date = [[NSDate date] dateAtStartOfDay];
    }
    
    [self fetchReview];
    
    self.habits = [[NSMutableArray alloc] init];
    [self fetchHabits];
    
    self.habitsTableView.delegate = self;
    self.habitsTableView.dataSource = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization]; //non-blocking call
    self.currentUserLocation = self.locationManager.location;
    self.weatherRadar = [[WeatherRadar alloc] init];
    [self getWeather];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [StyleMethods styleBackground:self];
    [StyleMethods styleTableView:self.habitsTableView];
    [StyleMethods styleButtons:self.saveReviewButton];
    
}

-(void)dismissKeyboard
{
    [self.reviewText resignFirstResponder];
}

- (void) fetchReview {
    NSString *dateString = [DatabaseUtilities getDateString:self.date];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Review"];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *reviews, NSError *error){
        if (reviews != nil) {
            unsigned long i, cnt = [reviews count];
            for(i = 0; i < cnt; i++)
            {
                NSString *reviewDate = [reviews objectAtIndex:i][@"Date"];
                PFUser *reviewUser = [reviews objectAtIndex:i][@"User"];
                
                if ([reviewDate isEqualToString:dateString] && [[PFUser.currentUser objectId] isEqual:[reviewUser objectId]]){
                    self.reviewText.text = [reviews objectAtIndex:i][@"Text"];
                    
                    //Save Initial review state
                    self.review = [reviews objectAtIndex:i];
                }
            }
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.activityIndicator stopAnimating];
    }];
}

- (IBAction)didSaveReview:(id)sender {
    
    //[self deleteReview];
    
    
    NSString *dateString = [DatabaseUtilities getDateString:self.date];
    [DatabaseUtilities editReview:self.review withClassName:@"Review" withUser:PFUser.currentUser withText:self.reviewText.text withDate:dateString withWeather:[self getWeatherDictionary:self.weather]];
    
    
    //[DatabaseUtilities createReview:PFUser.currentUser withText:self.reviewText.text withDate:dateString withWeather:[self getWeatherDictionary:self.weather]];
    
   
    //For each habit that was completed
    for (HabitCheckerCell *checkerCell in [self.habitsTableView visibleCells]){
        Habit *habit = checkerCell.habit;
                
        if ([checkerCell.completed isOn]){
            if (![habit[@"DatesCompleted"] containsObject:self.date]){
                NSLog(@"Adding Date");
                [self editHabitCompletionDate:checkerCell.habit withDate:self.date adding:YES];
            }
        }
        else{
            if ([habit[@"DatesCompleted"] containsObject:self.date]){
                NSLog(@"Removing Date");
                [self editHabitCompletionDate:checkerCell.habit withDate:self.date adding:NO];
            }
        }
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
    [self presentViewController:homeVC animated:YES completion:nil];
    
}

- (void) deleteReview {

    PFQuery *query = [PFQuery queryWithClassName:@"Review"];

    //Delete review that already exists in backend
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable reviews, NSError * _Nullable error) {
        if (reviews != nil) {
            for (PFObject *review in reviews) {
                if([review[@"Date"] isEqualToString:self.review[@"Date"]] && [DatabaseUtilities checkUserIsCurrrentUser:self.review[@"User"]]){
                    [review deleteInBackground];
                }
            }
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}

- (void) getWeather {
    self.currentUserLocation = self.locationManager.location;
    CLLocationCoordinate2D coordinate = [self.currentUserLocation coordinate];
    float latFloat = [[NSString stringWithFormat:@"%f", coordinate.latitude] floatValue];
    float longFloat = [[NSString stringWithFormat:@"%f", coordinate.longitude] floatValue];
    [self.weatherRadar getCurrentWeather:latFloat longitude:longFloat completionBlock:^(Weather *weather){
        self.weather = weather;
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
                PFUser *habitUser = [habits objectAtIndex:i][@"User"];
                if ([[PFUser.currentUser objectId] isEqual:[habitUser objectId]]){
                    [self.habits addObject:[habits objectAtIndex:i]];
                }
                
            }
            [self.habitsTableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HabitCheckerCell *cell = [self.habitsTableView dequeueReusableCellWithIdentifier:@"HabitCheckerCell"];
    cell.habit = self.habits[indexPath.row];
    cell.habitName.text = cell.habit[@"Name"];
    UIColor *notebookPaper = [UIColor colorWithRed:224.0/255.0 green:201.0/255.0 blue:166.0/255.0 alpha:1];
    cell.backgroundColor = notebookPaper;

    //Set completed switch to On if habit was completed today
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


- (void) editHabitCompletionDate:(PFObject*)habit withDate:(NSDate*)dateOfCompletion adding:(BOOL)adding {
    
    NSMutableArray *datesCompleted = [[NSMutableArray alloc] init];
    for (NSString *date in habit[@"DatesCompleted"]){
        [datesCompleted addObject:date];
    }
    if (adding){
        [datesCompleted addObject:[DatabaseUtilities getDateString:dateOfCompletion]];
    }
    else {
        [datesCompleted removeObject:[DatabaseUtilities getDateString:dateOfCompletion]];
    }
    
    [DatabaseUtilities editHabit:habit withClassName:@"Habit" withUser:PFUser.currentUser withName:habit[@"Name"] withReason:habit[@"Reason"] withDatesCompleted:datesCompleted];
    
}

- (void) deleteHabit: (Habit*)habit {
    PFQuery *query = [PFQuery queryWithClassName:@"Habit"];
    
    //Delete habit that already exists in backend
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable habits, NSError * _Nullable error) {
        if (habits != nil) {
            for (PFObject *habitObj in habits) {
                PFUser *habitUser = habitObj[@"User"];
                if([habitObj[@"Name"] isEqualToString:habit[@"Name"]] && [habitObj[@"Reason"] isEqualToString:habit[@"Reason"]] && [DatabaseUtilities checkUserIsCurrrentUser:habitUser]){
                    [habitObj deleteInBackground];
                }
            }
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

-(NSDictionary *)getWeatherDictionary:(Weather*)weather{
    NSDictionary *dictionary;
    dictionary = @{
        @"weather": @[@{
            @"description": weather.condition,
            @"icon": weather.icon,
            @"main": weather.status,
            @"id": [NSNumber numberWithInt:weather.statusID],
        }],
        @"temp": @{
            @"min": [NSString stringWithFormat:@"%i",
            weather.temperatureMax],
            @"max": [NSString stringWithFormat:@"%i", weather.temperatureMin]
        },
        @"humidity": [NSString stringWithFormat:@"%i", weather.humidity],
        @"speed": [NSString stringWithFormat:@"%f", weather.windSpeed]

    };
    return dictionary;
}

@end
