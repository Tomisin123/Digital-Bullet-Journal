//
//  WeatherRadar.h
//  BulletJournal
//
//  Created by tomisin on 7/26/21.
//

#import <Foundation/Foundation.h>

#import "Weather.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherRadar : NSObject

/**
 *  Returns weekly forecasted weather conditions
 *  for the specified lat/long
 *
 *  @param latitude           Location latitude
 *  @param longitude          Location longitude
 *  @param completionBlock    Array of weather results
 */
- (void)getWeeklyWeather:(float)latitude longitude:(float)longitude
         completionBlock:(void (^)(NSArray *))completionBlock;

/**
 *  Returns realtime weather conditions
 *  for the specified lat/long
 *
 *  @param latitude        Location latitude
 *  @param longitude       Location longitude
 *  @param completionBlock Weather object
 */
- (void)getCurrentWeather:(float)latitude longitude:(float)longitude
          completionBlock:(void (^)(Weather *))completionBlock;

@end

NS_ASSUME_NONNULL_END
