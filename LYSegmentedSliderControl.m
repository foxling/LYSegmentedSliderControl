//
//  LYSegmentedSliderControl.m
//  Created by lingye on 5/13/14.
//  i.foxling@gmail.com
//

#import "LYSegmentedSliderControl.h"

static NSInteger badgeTag = 142014;

@interface LYSegmentedSliderControlBadgeView : UIView

@property (strong, nonatomic) UILabel *label;
- (void)setText:(NSString *)text;

@end

@interface LYSegmentedSliderControl() {
    NSMutableArray *_buttons;
}

@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) UIImageView *backgroundView;
@property (strong, nonatomic) UIImageView *selectedView;

@end

@implementation LYSegmentedSliderControl

- (instancetype)initWithItems:(NSArray *)items {
    self = [super initWithFrame:CGRectMake(0, 0, 320, 29)];
    if (self) {
        _buttons = [NSMutableArray array];
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundView.image = [[UIImage imageNamed:@"LYSegmentedSliderControlBackground"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:backgroundView];
        _backgroundView = backgroundView;
        
        UIImageView *selectedView = [[UIImageView alloc] initWithFrame:CGRectZero];
        selectedView.image = [[UIImage imageNamed:@"LYSegmentedSliderControlSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
        [self addSubview:selectedView];
        _selectedView = selectedView;
        
        _items = [NSMutableArray arrayWithArray:items];
        [self createButtons];
        self.selectedSegmentIndex = 0;
    }
    return self;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage selectedImage:(UIImage *)selectedImage {
    if (backgroundImage) {
        self.backgroundView.image = backgroundImage;
    }
    if (selectedImage) {
        self.selectedView.image = selectedImage;
    }
}


- (void)createButtons {
    UIFont *font = [UIFont systemFontOfSize:14];
    [self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = idx;
        button.titleLabel.font = font;
        [button setTitle:obj forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [_buttons addObject:button];
    }];
    
    UIColor *selectedColor = [UIColor colorWithRed:0 green:155/255.0 blue:225/255.0 alpha:1];
    [self setTitleColor:selectedColor forState:UIControlStateSelected];
    [self setTitleColor:selectedColor forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1] forState:UIControlStateNormal];
}

- (UIButton *)buttonAtIndex:(NSUInteger)index {
    if (index < _buttons.count) {
        return _buttons[index];
    }
    return nil;
}

- (void)didClickButton:(UIButton *)button {
    if (self.selectedSegmentIndex != button.tag) {
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.selectedView.center = button.center;
                         }
                         completion:nil];
        
        [self setSelectedSegmentIndex:button.tag];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    if (selectedSegmentIndex < _buttons.count) {
        _selectedSegmentIndex = selectedSegmentIndex;
        [_buttons makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];
        [self buttonAtIndex:selectedSegmentIndex].selected = YES;
    }
}

#pragma mark -

- (void)setTitleColor:(UIColor *)titleColor forState:(UIControlState)state {
    [_buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = obj;
        [button setTitleColor:titleColor forState:state];
    }];
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index {
    if (title != nil && index < self.items.count) {
        self.items[index] = title;
        [[self buttonAtIndex:index] setTitle:title forState:UIControlStateNormal];
        [[self buttonAtIndex:index] setTitle:title forState:UIControlStateSelected];
    }
}

- (void)setBadgeText:(NSString *)text forSegmentAtIndex:(NSUInteger)index {
    UIButton *button = [self buttonAtIndex:index];
    if (button != nil) {
        LYSegmentedSliderControlBadgeView *badgeView = (LYSegmentedSliderControlBadgeView *)[button viewWithTag:badgeTag];
        if (badgeView == nil) {
            badgeView = [[LYSegmentedSliderControlBadgeView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
            badgeView.tag = badgeTag;
            [button addSubview:badgeView];
        }
        
        [badgeView setText:text];

        if (text != nil) {
            badgeView.hidden = NO;
            
            CGRect badgeRect = badgeView.frame;
            CGRect titleRect = [button titleRectForContentRect:button.bounds];
            badgeRect.origin.x = CGRectGetMaxX(titleRect) + 6;
            badgeRect.origin.y = (CGRectGetHeight(self.frame) - CGRectGetHeight(badgeRect)) / 2;
            badgeView.frame = badgeRect;
        }
    }
}

- (NSString *)badgeTextForSegmentAtIndex:(NSUInteger)index {
    UIButton *button = [self buttonAtIndex:index];
    LYSegmentedSliderControlBadgeView *badgeView = (LYSegmentedSliderControlBadgeView *)[button viewWithTag:badgeTag];
    return badgeView.label.text;
}

#pragma mark -

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat itemWidth = width / self.items.count;
    CGFloat itemHeight = CGRectGetHeight(self.frame);
    [_buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = obj;
        button.frame = CGRectMake(idx*itemWidth, 0, itemWidth, itemHeight);
    }];
    
    self.selectedView.frame = CGRectMake(self.selectedSegmentIndex * itemWidth, 0, itemWidth, itemHeight);
}

@end


@implementation LYSegmentedSliderControlBadgeView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:1 green:68/255.0 blue:68/255.0 alpha:1];
        self.clipsToBounds = YES;
        
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:12];
        [self addSubview:_label];
    }
    return self;
}

- (void)setText:(NSString *)text {
    self.label.text = text;
    if (text == nil || text.length == 0) {
        self.hidden = YES;
    } else {
        [self.label sizeToFit];
        self.label.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.layer.cornerRadius = frame.size.height / 2;
}

@end
