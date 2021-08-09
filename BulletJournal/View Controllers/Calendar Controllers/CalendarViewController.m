//
//  CalendarViewController.m
//  BulletJournal
//
//  Created by tomisin on 7/19/21.
//

#import "CalendarViewController.h"

#import "FSCalendar.h"
#import "CoreLocation/CoreLocation.h"
#import "Parse/Parse.h"
#import "WeatherRadar.h"
#import "NSDate+Utilities.h"
#import "DailyTabBarController.h"
#import "DailyTodoViewController.h"
#import "DailyReviewViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TimeSensitiveCache.h"
#import "DatabaseUtilities.h"
#import "StyleMethods.h"

@interface CalendarViewController () <FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, CLLocationManagerDelegate, NSCacheDelegate>

@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *weatherHigh;
@property (weak, nonatomic) IBOutlet UILabel *weatherLow;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *dayPreview;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) WeatherRadar *weatherRadar;
@property (strong, nonatomic) CLLocation *currentUserLocation;
@property (strong, nonatomic) NSDate *dateSelected;
@property (strong, nonatomic) TimeSensitiveCache *cache;
@property (nonatomic) NSTimeInterval cacheTimeInterval;
@property (weak, nonatomic) IBOutlet UIButton *dayPageSegueButton;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Initializing Calendar information
    self.calendar.delegate = self;
    self.calendar.dataSource = self;
    self.dateSelected = [[NSDate date] dateAtStartOfDay];
    [self.calendar selectDate:self.dateSelected];
    
    //Initializing Location for Weather Information
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization]; //non-blocking call
    self.currentUserLocation = self.locationManager.location;
    self.weatherRadar = [[WeatherRadar alloc] init];
    
    
    //Initializing Cache
    self.cache = [[TimeSensitiveCache alloc] init];
    self.cacheTimeInterval = 3600; //Storing
    
    self.dayPreview.editable = NO;
    
    [StyleMethods styleBackground:self];
    [StyleMethods styleCalendar:self.calendar];
    [StyleMethods styleButtons:self.dayPageSegueButton];
    [StyleMethods styleTextView:self.dayPreview];
}



- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date{
    if ([date isTypicallyWorkday]){
        return [UIColor blackColor];
    }
    return nil;
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date{
    if ([date isToday]){
        return 1;
    }
    return 0;
}

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar {
    return PFUser.currentUser.createdAt;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    
    NSString *dateString = [DatabaseUtilities getDateString:date];
    self.dateLabel.text = dateString;
    self.dateSelected = date;
    
    NSLog(@"Date Selected: %@", self.dateSelected);
    
    [self updateWeather];
        
    //Query to load the bottom half of the days
    //TODO: potentially repetitive code (fetchBullets)
    self.dayPreview.text = @"";
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
                    //Creating Readable Day Preview on Calendar Screen
                    NSString *string = [bullets objectAtIndex:i][@"Description"];
                    string = [string stringByAppendingString:@"\n"];
                    NSString *dayPreviewString = [self.dayPreview.text stringByAppendingString:string];
                    self.dayPreview.text = dayPreviewString;
                }
            }
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
}

- (void) updateWeather {
    
    //Getting Latitude and Longitude
    self.currentUserLocation = self.locationManager.location;
    CLLocationCoordinate2D coordinate = [self.currentUserLocation coordinate];
    self.latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    float latFloat = [self.latitude floatValue];
    float longFloat = [self.longitude floatValue];
        
    //Formatting Weather
    NSString *dateString = [DatabaseUtilities getDateString:self.dateSelected];
    
    //Obtaining Weather Predictions Based on Date chosen from calendar
    //If date selected is today, just use current weather predictor for today
    if ([self.dateSelected isToday]){
        NSLog(@"Selected Today");
        
        if ([self.cache objectForKey:dateString] != nil){
            NSLog(@"Using Cached Weather Object");
            Weather *weather = [self.cache objectForKey:dateString];
            [self setWeatherInformation:weather withKey:dateString];
        }
        else {
            [self.weatherRadar getCurrentWeather:latFloat longitude:longFloat completionBlock:^(Weather *weather){
                [self setWeatherInformation:weather withKey:dateString];
            }];
        }
    }
    
    //If date selected is yesterday or further in the past, use historical weathed data call
    else if ([self.dateSelected isEarlierThanDate:[[NSDate date] dateAtStartOfDay]]){
        //TODO: Create weather database and check if weather from that date is stored
        
        PFQuery *query = [PFQuery queryWithClassName:@"Review"];
        query.limit = 20;
        [query orderByDescending:@"createdAt"];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *reviews, NSError *error){
            if (reviews != nil) {
                unsigned long i, cnt = [reviews count];
                for(i = 0; i < cnt; i++)
                {
                    NSString *dateString = [DatabaseUtilities getDateString:self.dateSelected];
                    if ([[reviews objectAtIndex:i][@"Date"] isEqual:dateString]){
                        Weather *weather = [[Weather alloc] initWithDictionary:[reviews objectAtIndex:i][@"Weather"] isCurrentWeather:NO];
                        NSLog(@"Weather stuff: %@", weather.condition);
                        [self setWeatherInformation:weather withKey:dateString];
                    }
                    
                }
            }
            else {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
        
        NSLog(@"Selected day before today");
        self.weatherHigh.text = @"N/A";
        self.weatherLow.text = @"N/A";
        
    }
    
    //If date selected more than a week in the future, weather data isn't obtainable
    //Currently seven day forecast, could obtain 30-day with paid subscription
    else if ([self.dateSelected isLaterThanDate:[[NSDate date] dateByAddingDays:7]]){
        NSLog(@"Selected day more than a week in a future");
        self.weatherHigh.text = @"N/A";
        self.weatherLow.text = @"N/A";
    }
    
    else { //Need to acquire weekly forecast
        NSLog(@"Selected day less than or equal to a week in the future");
        if ([self.cache objectForKey:dateString] != nil){
            NSLog(@"Using Cached Weather Object");
            Weather *weather = [self.cache objectForKey:dateString];
            [self setWeatherInformation:weather withKey:dateString];
        }
        else {
            [self.weatherRadar getWeeklyWeather:latFloat longitude:longFloat completionBlock:^(NSArray *weatherArray) {
                Weather *weather = [weatherArray objectAtIndex:[[NSDate date] distanceInDaysToDate:self.dateSelected]];
                [self setWeatherInformation:weather withKey:dateString];
            }];
        }
    }
    
}

-(void)setWeatherInformation:(Weather *)weather withKey:(NSString *)dateString{
    NSString *iconURLString = [NSString stringWithFormat:@"https://openweathermap.org/img/wn/%@.png", weather.icon];
    NSURL *iconURL = [NSURL URLWithString:iconURLString];
    [self.weatherImage setImageWithURL:iconURL];
    self.weatherHigh.text = [NSString stringWithFormat:@"%i", weather.temperatureMax];
    self.weatherLow.text = [NSString stringWithFormat:@"%i", weather.temperatureMin];
    
    if ([self.cache objectForKey:dateString] == nil){ //Cache object if it's not in cache
        [self.cache setObject:weather forKey:dateString timeout:self.cacheTimeInterval];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.currentUserLocation = [locations lastObject];
    [self.locationManager stopUpdatingLocation];
}



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqual:@"calendarDaySegue"]){
         NSDate *date = [self.dateSelected dateAtStartOfDay];
         DailyTabBarController *dailyTabBarController = [segue destinationViewController];
         DailyTodoViewController *dailyTodoController = dailyTabBarController.viewControllers[0];
         DailyReviewViewController *dailyReviewController = dailyTabBarController.viewControllers[1];
         dailyTabBarController.date = date;
         dailyTodoController.date = date;
         dailyReviewController.date = date;
         NSLog(@"Segueing with Date: %@", date);
     }
     
 }
 

@end
