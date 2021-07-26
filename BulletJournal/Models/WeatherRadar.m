//
//  WeatherRadar.m
//  BulletJournal
//
//  Created by tomisin on 7/26/21.
//

#import "WeatherRadar.h"

#import "AFNetworking.h"
#import "Weather.h"

@implementation WeatherRadar

- (void)fetchWeatherFromProvider:(NSString*)URL completionBlock:
(void (^)(NSDictionary *))completionBlock {
    
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    [manager GET:URL parameters:nil success:
     ^(AFHTTPRequestOperation* operation, id responseObject) {
        if (responseObject) {
            completionBlock(responseObject);
        } else {
            // handle no results
        }
    } failure:^(AFHTTPRequestOperation*
                operation, NSError *error) {
        // handle error
    }
     ];
}

- (void)getWeeklyWeather:(float)latitude longitude:(float)longitude completionBlock:(void (^)(NSArray *))completionBlock {
    
    // formulate the url to query the api to get the 7 day
    // forecast. cnt=7 asks the api for 7 days. units = imperial
    // will return temperatures in Farenheit
    NSString* url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?units=imperial&cnt=7&lat=%f&lon=%f", latitude, longitude];
    
    // escape the url to avoid any potential errors
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    // call the fetch function from Listing 4
    [self fetchWeatherFromProvider:url completionBlock:
     ^(NSDictionary * weatherData) {
        // create an array of weather objects (one for each day)
        // initialize them using the function from listing 7
        // and return the results to the calling controller
        NSMutableArray *weeklyWeather = [[NSMutableArray alloc] init];
        
        for(NSDictionary* weather in weatherData[@"list"]) {
            // pass false since the weather is a future forecast
            // this lets the init function know which format of
            // data to parse
            Weather* day = [[Weather alloc] initWithDictionary:weather isCurrentWeather:FALSE];
            [weeklyWeather addObject:day];
        }
        
        completionBlock(weeklyWeather);
    }];
}

- (void)getCurrentWeather:(float)latitude longitude:(float)longitude completionBlock:(void (^)(Weather * _Nonnull))completionBlock{
    // formulate the url to query the api to get current weather
    NSString* url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?units=imperial&cnt=7&lat=%f&lon=%f", latitude, longitude];
    
    // escape the url to avoid any potential errors
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // call the fetch function from Listing 4
    [self fetchWeatherFromProvider:url completionBlock:
     ^(NSDictionary * weatherData) {
        // create an weather object by initializing it with
        // data from the API using the init func from Listing 7
        completionBlock([[Weather alloc] initWithDictionary:weatherData isCurrentWeather:TRUE]);
    }];
}


@end
