//
//  JMSCountDownButton.h
//  JMS_New
//
//  Created by 黄沐 on 08/06/2017.
//  Copyright © 2017 Hm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JMSCountDownButton;
typedef NSString* (^CountDownChanging)(JMSCountDownButton *countDownButton,NSUInteger second);
typedef NSString* (^CountDownFinished)(JMSCountDownButton *countDownButton,NSUInteger second);

typedef void (^TouchedCountDownButtonHandler)(JMSCountDownButton *countDownButton,NSInteger tag);
@interface JMSCountDownButton : UIButton
{
    NSInteger _second;
    NSUInteger _totalSecond;
    
    NSTimer *_timer;
    NSDate *_startDate;
    
    CountDownChanging _countDownChanging;
    CountDownFinished _countDownFinished;
    TouchedCountDownButtonHandler _touchedCountDownButtonHandler;
}
@property(nonatomic,strong) id userInfo;

-(void)countDownButtonHandler:(TouchedCountDownButtonHandler)touchedCountDownButtonHandler;
-(void)countDownChanging:(CountDownChanging)countDownChanging;
-(void)countDownFinished:(CountDownFinished)countDownFinished;

-(void)startCountDownWithSecond:(NSUInteger)second;

@end
