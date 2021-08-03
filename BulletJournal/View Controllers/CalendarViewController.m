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

@interface CalendarViewController () <FSCalendarDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *weatherHigh;
@property (weak, nonatomic) IBOutlet UILabel *weatherLow;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayPreview;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) WeatherRadar *weatherRadar;
@property (strong, nonatomic) CLLocation *currentUserLocation;
@property (strong, nonatomic) NSDate *dateSelected;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.calendar.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization]; //non-blocking call
    self.currentUserLocation = [[CLLocation alloc] initWithLatitude:32.7767 longitude:-96.7970]; //TODO: This sets coordinates for Dallas, TX
    self.weatherRadar = [[WeatherRadar alloc] init];
    
    //TODO: self.dateSelected = Today; for before a date is selected
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //formatter.dateFormat = @"EEEE MM/dd";
    formatter.dateFormat = @"dd/MM/yyyy";
    NSString *dateString = [formatter stringFromDate:date];
    NSLog(@"%@", dateString);
    self.dateLabel.text = dateString;
    self.dateSelected = date;
    
    NSLog(@"Date Selected: %@", self.dateSelected);
    
    
    
    [self updateWeather];
    
    //Query to load the bottom half of the days
    self.dayPreview.text = @"";
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
                    NSString *string = [posts objectAtIndex:i][@"Description"];
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
    
    CLLocationCoordinate2D coordinate = [self.currentUserLocation coordinate];
    self.latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    float latFloat = [self.latitude floatValue];
    float longFloat = [self.longitude floatValue];
    
//    NSLog(@"Location Manager: %@", [self.locationManager location]);
//    NSLog(@"Current User Location: %@", self.currentUserLocation);
    
    
    
    //If date selected is today, just use current weather predictor for today
    if ([self.dateSelected isToday]){
        NSLog(@"Selected Today");
        [self.weatherRadar getCurrentWeather:latFloat longitude:longFloat completionBlock:^(Weather *weather){
            //TODO: set image based on weather.condition
            self.weatherHigh.text = [NSString stringWithFormat:@"%i", weather.temperatureMax];
            self.weatherLow.text = [NSString stringWithFormat:@"%i", weather.temperatureMin];
        }];
    }
    
    //If date selected is yesterday or further in the past, use historical weathed data call
    else if ([self.dateSelected isEarlierThanDate:[[NSDate date] dateAtStartOfDay]]){
        NSLog(@"Selected day before today");
    }
    
    //If date selected more than a week in the future, weather data isn't obtainable
    else if ([self.dateSelected isLaterThanDate:[[NSDate date] dateByAddingDays:7]]){
        NSLog(@"Selected day more than a week in a future");
        self.weatherHigh.text = @"N/A";
        self.weatherLow.text = @"N/A";
    }
    
    else { //Need to get weekly forecast
        NSLog(@"Selected day less than or equal to a week in the future");
        
        [self.weatherRadar getWeeklyWeather:latFloat longitude:longFloat completionBlock:^(NSArray *weatherArray) {
            Weather *weather = [weatherArray objectAtIndex:[[NSDate date] distanceInDaysToDate:self.dateSelected]];
            //TODO: set image based on weather.condition
            self.weatherHigh.text = [NSString stringWithFormat:@"%i", weather.temperatureMax];
            self.weatherLow.text = [NSString stringWithFormat:@"%i", weather.temperatureMin];
        }];
    }
    
    
    
    
    
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.currentUserLocation = [locations lastObject];
    [self.locationManager stopUpdatingLocation];
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
