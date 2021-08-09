//
//  DatabaseUtilities.m
//  BulletJournal
//
//  Created by tomisin on 8/7/21.
//

#import "DatabaseUtilities.h"

@implementation DatabaseUtilities

NSMutableArray *objectList;


+(void) testClassFunction {
    NSLog(@"TESTING CLASS FUNCTION");
}

+(NSString*) getDateString:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd/MM/yyyy";
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+(void) savePFObject:(PFObject*)object {
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Object saved!");
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
}

+(BOOL) checkUserIsCurrrentUser:(PFUser*)user {
    return [[PFUser.currentUser objectId] isEqual:[user objectId]];
}

+(void)createHabit:(PFUser*)user withName:(NSString*)name withReason:(NSString*)reason withDatesCompleted:(NSArray*)datesCompleted{
    PFObject *habit = [PFObject objectWithClassName:@"Habit"];
    habit[@"User"] = PFUser.currentUser;
    habit[@"Name"] = name;
    habit[@"Reason"] = reason;
    habit[@"DatesCompleted"] = datesCompleted;
    
    [self savePFObject:habit];
}

+(void)createBullet:(PFUser*)user withType:(NSString*)type withRelevancy:(NSNumber*)relevant withCompletion:(NSNumber*)completion withDescription:(NSString*)desc withDate:(NSString*)dateString{
    PFObject *bullet = [PFObject objectWithClassName:@"Bullet"];
    bullet[@"User"] = PFUser.currentUser;
    bullet[@"Type"] = type;
    bullet[@"Relevant"] = relevant;
    bullet[@"Completed"] = completion;
    bullet[@"Description"] = desc;
    bullet[@"Date"] = dateString;
    
    [self savePFObject:bullet];
}

+(void)createReview:(PFUser*)user withText:(NSString*)text withDate:(NSString*)dateString withWeather:(NSDictionary*)weatherDictionary {
    PFObject *review = [PFObject objectWithClassName:@"Review"];
    review[@"User"] = PFUser.currentUser;
    review[@"Text"] = text;
    review[@"Date"] = dateString;
    review[@"Weather"] = weatherDictionary;
    [self savePFObject:review];
}

+(NSMutableArray*) fetchPFObjectList:(NSString*)className {
    
    NSLog(@"Fetching PFObject List");
    
    
    objectList = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:className];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (objects != nil) {
            unsigned long i, cnt = [objects count];
            for(i = 0; i < cnt; i++)
            {
                [objectList addObject:[objects objectAtIndex:i][@"Name"]];
            }
            NSLog(@"objectList:%@", objectList);
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
        
    }];
    
    return objectList;
    
    
}

@end
