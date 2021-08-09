//
//  Review.h
//  BulletJournal
//
//  Created by tomisin on 8/9/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Review : PFObject

@property (nonatomic, strong) NSString *text; // text content of review
@property (nonatomic, strong) NSString *date; // string representation of date review corresponds to
@property (nonatomic, strong) NSDictionary *weather; // weather in dictionary form on date of review
@property (nonatomic, strong) PFUser *user; // user that created review

@end

NS_ASSUME_NONNULL_END
