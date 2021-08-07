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

@property (nonatomic, strong) NSDate *dateOfForecast; // the date this weather is relevant to
@property (nonatomic, strong) NSString* status; // the general weather status: (clouds, rain, thunderstorm, snow, etc...)
@property (nonatomic) int statusID; // the ID corresponding to general weather status
@property (nonatomic, strong) NSString* condition; // descriptive weather condition: (light rain, heavy snow, etc...)
@property (nonatomic, strong) NSString* icon; // OpenWeather weather condition icon code
@property (nonatomic) int temperatureMin; // min temp in farenheit
@property (nonatomic) int temperatureMax; // max temp in farenheit
@property (nonatomic) int humidity; // current humidity level (perecent)
@property (nonatomic) float windSpeed; // current wind speed in mph

//MARK: Methods
- (instancetype)initWithDictionary:(NSDictionary *)dictionary isCurrentWeather:(BOOL)isCurrentWeather;

@end


NS_ASSUME_NONNULL_END
