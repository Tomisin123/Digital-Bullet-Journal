//
//  DatabaseUtilities.h
//  BulletJournal
//
//  Created by tomisin on 8/7/21.
//

#import <Parse/Parse.h>

extern NSMutableArray * _Nullable objectList;

NS_ASSUME_NONNULL_BEGIN

@interface DatabaseUtilities : PFObject

+(void) testClassFunction;

+(NSString*) getDateString:(NSDate*)date;
+(void) savePFObject:(PFObject*)object;
+(BOOL) checkUserIsCurrrentUser:(PFUser*)user;
+(void)createHabit:(PFUser*)user withName:(NSString*)name withReason:(NSString*)reason withDatesCompleted:(NSArray*)datesCompleted;
+(void)createBullet:(PFUser*)user withType:(NSString*)type withRelevancy:(NSNumber*)relevant withCompletion:(NSNumber*)completion withDescription:(NSString*)desc withDate:(NSString*)dateString;
+(void)createReview:(PFUser*)user withText:(NSString*)text withDate:(NSString*)dateString withWeather:(NSDictionary*)weatherDictionary;
+(NSMutableArray*) fetchPFObjectList:(NSString*)className;
@end

NS_ASSUME_NONNULL_END
