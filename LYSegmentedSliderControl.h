//
//  LYSegmentedSliderControl.h
//  Created by lingye on 5/13/14.
//  i.foxling@gmail.com
//

#import <UIKit/UIKit.h>

@interface LYSegmentedSliderControl : UIControl

@property (nonatomic) NSInteger selectedSegmentIndex;
@property (strong, nonatomic) UIFont *titleFont;

- (instancetype)initWithItems:(NSArray *)items;

- (void)setTitleColor:(UIColor *)titleColor forState:(UIControlState)state;
- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index;
- (void)setBadgeText:(NSString *)text forSegmentAtIndex:(NSUInteger)index;
- (NSString *)badgeTextForSegmentAtIndex:(NSUInteger)index;

- (void)setBackgroundImage:(UIImage *)backgroundImage selectedImage:(UIImage *)selectedImage;

@end
