//
//  TimeSensitiveCache.m
//  BulletJournal
//
//  Created by tomisin on 8/7/21.
//

#import "TimeSensitiveCache.h"

@implementation TimeSensitiveCache

NSString *TimeSensitiveCacheKey = @"...";

-(void)setObject:(NSObject*)object forKey:(NSString*)key timeout:(NSTimeInterval)timeout{
    [super setObject:object forKey:key];
    NSDictionary *userInfoDictionary = @{TimeSensitiveCacheKey : key};
    [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(timerExpires:) userInfo:userInfoDictionary repeats:NO];
}

-(void)timerExpires:(NSTimer*)timer {
    [self removeObjectForKey:timer.userInfo[TimeSensitiveCacheKey]];
}

@end

