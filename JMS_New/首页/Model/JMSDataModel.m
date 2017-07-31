//
//  JMSDataModel.m
//  JMS_New
//
//  Created by 黄沐 on 2016/12/12.
//  Copyright © 2016年 Hm. All rights reserved.
//

#import "JMSDataModel.h"
#import "JMSData.h"
@import CoreData;//倒入框架
@interface JMSDataModel()
@property (nonatomic) NSMutableArray *privateItems;

@property (nonatomic,strong) NSMutableArray *allsetTypes;
@property (nonatomic,strong) NSManagedObjectContext *context;
@property (nonatomic,strong) NSManagedObjectModel *model;

@end
@implementation JMSDataModel


NSString *itemArchivePath()//辅助函数c语言,返回保存地址
{
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [pathList[0] stringByAppendingPathComponent:@"n.data"];//
}

// Insert code here to add functionality to your managed object subclass
+(instancetype)sharedStore
{
    static JMSDataModel *sharedStore = nil;
    /*
     //判断是否需要创建
     if (!sharedStore)
     {
     sharedStore = [[self alloc] initPrivate];//用这个办法可以保证单例（单线程）
     }*/
    static dispatch_once_t onceToken;//安全单例
    dispatch_once(&onceToken,^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}
/*  如果调用[[BNRItemStore alloc]init],就提示应该使用[BNRItemStore sharedStore]  */
-(instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[JMSDataModel sharedStore]"
                                 userInfo:nil];
}
//真正的初始化方式
-(instancetype)initPrivate
{
    self = [super init];
    if (self)
    {
        //读取
        self.model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        
        //设置SQLite路径
        NSURL *storeURL = [NSURL fileURLWithPath:itemArchivePath()];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error])
        {
            @throw [NSException exceptionWithName:@"OpenFailure"
                                           reason:[error localizedDescription]
                                         userInfo:nil];
        }
        
        //创建NSManagedObjectContext对象
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSManagedObjectContextLockingError];
        _context.persistentStoreCoordinator = psc;
        
        [self loadAllItems];
    }
    return self;
}

- (BOOL)saveChanges//保存到Core Data
{
    NSError *error;
    BOOL successful = [self.context save:&error];//向NSManagedObjectContext发送save消息
    if (!successful)
    {
        NSLog(@"Error saving:%@",[error localizedDescription]);
    }
    return successful;//保存到Core Data
}

- (void)loadAllItems
{
    if (!self.privateItems)
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"JMSDatas" inManagedObjectContext:self.context];
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderValue" ascending:YES];
        request.sortDescriptors = @[sd];
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        
        if (!result)
        {
            [NSException raise:@"Fetch failed" format:@"Reason:%@",[error localizedDescription]];
        }
        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

-(NSArray *)allItems
{
    return self.privateItems;
}

-(void)createItem//增加
{
    double order;
    if ([self.allItems count] == 0)
    {
        order = 1.0;
    }else
    {
        JMSData *item = [self.privateItems lastObject];
        order = item.orderValue  +1.0;
    }
    
    JMSData *item = [NSEntityDescription insertNewObjectForEntityForName:@"JMSData" inManagedObjectContext:self.context];
    
    item.orderValue = order;
    
    //插入位置
    [self.privateItems addObject:item];
    //[self.privateItems insertObject:item atIndex:[_privateItems count]-1];
    
}

- (void)removeItem:(JMSData *)item//删除
{
    [self.context deleteObject:item];
    [self.privateItems removeObjectIdenticalTo:item];
}

@end
