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

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.calendar.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization]; //non-blocking call
    
    self.weatherRadar = [[WeatherRadar alloc] init];
    
    
    
    
    
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEEE MM/dd";
    NSString *dateString = [formatter stringFromDate:date];
    NSLog(@"%@", dateString);
    self.dateLabel.text = dateString;
    
    [self updateWeather];
    
    
    //Query to load the bottom half of the days
    //TODO: similar method as fetchPosts in DailyTodoViewController
    //TODO: filter for only the day selected
    self.dayPreview.text = @"";
    PFQuery *query = [PFQuery queryWithClassName:@"Bullet"];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error){
        if (posts != nil) {
            unsigned long i, cnt = [posts count];
            for(i = 0; i < cnt; i++)
            {
                NSString *string = [posts objectAtIndex:i][@"Description"];
                string = [string stringByAppendingString:@"\n"];
                NSString *dayPreviewString = [self.dayPreview.text stringByAppendingString:string];
                self.dayPreview.text = dayPreviewString;
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

    NSLog(@"%@", [self.locationManager location]);
    NSLog(@"Outside getCurrentWeather Completion Block");
    //NSLog(@"%@", self.weatherRadar getCurrentWeather:latFloat longitude:longFloat completionBlock:<#^(Weather * _Nonnull)completionBlock#>
    [self.weatherRadar getCurrentWeather:latFloat longitude:longFloat completionBlock:^(Weather *weather){
        //TODO: won't execute the inside of this completion bloc for some reason
        NSLog(@"Inside getCurrentWeather Completion Block");
        NSLog(@"%@", weather);
    }];
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {

    self.currentUserLocation = [locations lastObject];
    [self.locationManager stopUpdatingLocation];
    
    

}

//
//- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
//    if (!(manager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) &&
//        !(manager.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways)){
//
//        //TODO: can't use weather api
//
//    }
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
