//
//  XZViewController.m
//  KVO原理探索
//
//  Created by Alan on 4/29/20.
//  Copyright © 2020 zhaixingzhi. All rights reserved.
//

#import "XZViewController.h"
#import <objc/runtime.h>
#import "XZPerson.h"


@interface XZViewController ()
@property (nonatomic, strong) XZPerson *person;

@end

@implementation XZViewController
- (void)dealloc{
    [self.person removeObserver:self forKeyPath:@"name"];
    [self.person removeObserver:self forKeyPath:@"nickName"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.person = [[XZPerson alloc]init];
    
    //XZPerson =监听后变为=>NSKVONotifying_XZPerson 是继承关系
    //中件生产的是一个动态类，但是修改的是原对象的isa
    //2.实例变量---属性 区别为，是否有setter方法
    //3.研究动态子类：isa （变化） supperclass（继承） cache_t(缓存) bit 方法
    /**
     KVO原理
     1.动态生成子类:NSKVONotifying_xxx
     2.观察的是setter方法
     3.动态子类重写很多方法setNickName,class,delloc，_isKVOA
     4.移除观察后，isa指回了XZPerson
     5.移除观察后中间动态子类是没有销毁
     */
//    [self printClasses:[XZPerson class]];
//    [self printClassAllMethod:[XZPerson class]];

    [self.person addObserver:self forKeyPath:@"nickName" options:NSKeyValueObservingOptionNew context:NULL];
//    [self printClasses:[XZPerson class]];
//    [self printClassAllMethod:NSClassFromString(@"NSKVONotifying_XZPerson")];


    [self.person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:NULL];
    // Do any additional setup after loading the view.
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    NSLog(@"%@",change);

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"实际情况：%@--%@",self.person.nickName,self.person->name);
    self.person.nickName = @"alan";
    self.person->name = @"星";
}



#pragma mark - 遍历方法-ivar-property
- (void)printClassAllMethod:(Class)cls{
    NSLog(@"*********************");
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(cls, &count);
    for (int i = 0; i<count; i++) {
        Method method = methodList[i];
        SEL sel = method_getName(method);
        IMP imp = class_getMethodImplementation(cls, sel);
        NSLog(@"%@-%p",NSStringFromSelector(sel),imp);
    }
    free(methodList);
}

#pragma mark - 遍历类以及子类
- (void)printClasses:(Class)cls{
    
    // 注册类的总数
    int count = objc_getClassList(NULL, 0);
    // 创建一个数组， 其中包含给定对象
    NSMutableArray *mArray = [NSMutableArray arrayWithObject:cls];
    // 获取所有已注册的类
    Class* classes = (Class*)malloc(sizeof(Class)*count);
    objc_getClassList(classes, count);
    for (int i = 0; i<count; i++) {
        if (cls == class_getSuperclass(classes[i])) {
            [mArray addObject:classes[i]];
        }
    }
    free(classes);
    NSLog(@"classes = %@", mArray);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
