//
//  CalendarViewController.m
//  BulletJournal
//
//  Created by tomisin on 7/19/21.
//

#import "CalendarViewController.h"

#import "FSCalendar.h"
#import "CoreLocation/CoreLocation.h"

@interface CalendarViewController () <FSCalendarDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *weatherHigh;
@property (weak, nonatomic) IBOutlet UILabel *weatherLow;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayPreview;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.calendar.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization]; //non-blocking call
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEEE MM/dd";
    NSString *dateString = [formatter stringFromDate:date];
    NSLog(@"%@", dateString);
    self.dateLabel.text = dateString;
    //TODO: do a query to load the bottom half of the days
}

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    if (manager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse ||
        manager.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways){
        NSLog(@"%@", [self.locationManager location]);
    }
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
