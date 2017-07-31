//
//  AppDelegate.h
//  JMS_New
//
//  Created by 黄沐 on 2016/11/23.
//  Copyright © 2016年 Hm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong) UIImageView *advImage;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

