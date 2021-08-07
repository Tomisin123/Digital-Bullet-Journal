//
//  BulletCell.h
//  BulletJournal
//
//  Created by tomisin on 7/15/21.
//

#import <UIKit/UIKit.h>

#import "Bullet.h"

NS_ASSUME_NONNULL_BEGIN

@interface BulletCell : UITableViewCell

//MARK: Properties
@property (strong, nonatomic) Bullet *bullet;
@property (weak, nonatomic) IBOutlet UILabel *desc; // Text content of Bullet
@property (weak, nonatomic) IBOutlet UIImageView *img; //Image denoting type of bullet

@end

NS_ASSUME_NONNULL_END
