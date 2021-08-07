//
//  TimeSensitiveCache.h
//  BulletJournal
//
//  Created by tomisin on 8/7/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimeSensitiveCache : NSCache

-(void)setObject:(NSObject*)object forKey:(NSString*)key timeout:(NSTimeInterval)timeout;

@end

NS_ASSUME_NONNULL_END
