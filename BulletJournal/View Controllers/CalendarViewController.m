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

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    if (manager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse ||
        manager.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways){
        CLLocationCoordinate2D coordinate = [[self.locationManager location] coordinate];
        self.latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
        self.longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
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
