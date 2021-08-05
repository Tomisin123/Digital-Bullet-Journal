//
//  Weather.h
//  BulletJournal
//
//  Created by tomisin on 7/26/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Weather : NSObject

//MARK: Properties
/// the date this weather is relevant to
@property (nonatomic, strong) NSDate *dateOfForecast;

/// the general weather status:
/// clouds, rain, thunderstorm, snow, etc...
@property (nonatomic, strong) NSString* status;

/// the ID corresponding to general weather status
@property (nonatomic) int statusID;

/// a more descriptive weather condition:
/// light rain, heavy snow, etc...
@property (nonatomic, strong) NSString* condition;

@property (nonatomic, strong) NSString* icon;

/// min/max temp in farenheit
@property (nonatomic) int temperatureMin;
@property (nonatomic) int temperatureMax;

/// current humidity level (perecent)
@property (nonatomic) int humidity;

/// current wind speed in mph
@property (nonatomic) float windSpeed;

//MARK: Methods
- (instancetype)initWithDictionary:(NSDictionary *)dictionary isCurrentWeather:(BOOL)isCurrentWeather;

@end


NS_ASSUME_NONNULL_END
