//
//  Bullet.h
//  BulletJournal
//
//  Created by tomisin on 7/15/21.
//

#import <Foundation/Foundation.h>

#import "Flair.h"

NS_ASSUME_NONNULL_BEGIN

@interface Bullet : NSObject

//MARK: Properties
//@property (nonatomic, strong) NSString *idStr; // For favoriting, retweeting & replying
@property (nonatomic, strong) NSString *text; // Text content of bullet
@property (nonatomic, strong) Flair *flair; // Flair for a bullet
@property (nonatomic) BOOL *completed; // Marks whether or not a bullet is completed

//MARK: Methods


@end

NS_ASSUME_NONNULL_END
