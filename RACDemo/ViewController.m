//
//  ViewController.m
//  RACDemo
//
//  Created by poplar on 2017/6/21.
//  Copyright © 2017年 poplar. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>
#import "Person.h"
//scope 范围
#import <ReactiveObjC/RACEXTScope.h>

#import "NetTool.h"
#import "clickView.h"
#import <NSObject+RACKVOWrapper.h>

@interface ViewController ()
{
    clickView *_view;
}
@property(nonatomic , strong) Person *person;
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *tf1;
@property (weak, nonatomic) IBOutlet UITextField *tf2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.person = [[Person alloc] init];
    self.person.name = @"hello";
    
    
    _view = [[[NSBundle mainBundle] loadNibNamed:@"clickView" owner:self options:nil] lastObject];
    _view.frame = CGRectMake(10, 50, 300, 100);
    _view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_view];

//    [self signal解析];
//    [self racSubject];
//    [self command];
//    [self target];
//    [self selector];
    [self kvo];
}

- (void)command{

    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        NSLog(@"input %@",input);
        NSLog(@"发送网络请求你");
        
        return [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            //发送数据
            [subscriber sendNext:@"发送请求到的数据"];
            return nil;
        }] delay:2.0];
    }];
    
    //获取命令中的信号源
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    } ];
    
    [command.executing subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue] == YES) {
            
            NSLog(@"正在执行...");
        }
    }];
    [command execute:@"xxx"];
}

- (void)racSubject{
    //RACSignal 创建信号
    //RACSubcriber 发送信号
    //RACSubject 既可以创建信号 也可以发送信号
    
    //1创建信号
    RACSubject *subject = [RACSubject subject];
    //2.订阅信号
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收到信号 %@",x);
    }];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收到信号 %@",x);
    }];

    //3.发送数据
    [subject sendNext:@1];
    
}

- (void)signal解析{
    
    //RACSignal 信号类
    //冷信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"send signal");
        //发送信号
        [subscriber sendNext:@"hello signal"];
//        return nil;
        return [RACDisposable disposableWithBlock:^{
            //清空资源用 资源释放 subscriber释放才会调用
            NSLog(@"clear");
        }];
    }];
    //热信号
    //订阅信号
    RACDisposable *dis = [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"subcribe signal");
        //x 信号发送内容
        NSLog(@"%@",x);
    }];

    //取消订阅
    [dis dispose];
}

- (void)block{

    [self.person eatFood:@"apple" complete:^(NSString *feeling) {
        
        NSLog(@"%@",feeling);
    }];
    
    CGFloat kilometers = self.person.run(1000);
    NSLog(@"kilometers %f",kilometers);
    //链式编程示例
    self.person.value(@"透明").value(@"简单").value(@"信任");
}

- (void)kvo3{

//    [[_view rac_valuesForKeyPath:@"frame" observer:nil]subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    
    [[_view rac_valuesAndChangesForKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)kvo2{

    //监听方法
        //函数式编程
    [_view rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        NSLog(@"change = %@",change);
    }];
}

- (void)selector{
    //监听方法
    clickView *view = [[[NSBundle mainBundle] loadNibNamed:@"clickView" owner:self options:nil] lastObject];
    view.frame = CGRectMake(10, 50, 300, 100);
    view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view];

    //方法1.
        [[view rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(RACTuple * _Nullable x) {
            NSLog(@"监听了btn的点击事件");
            NSLog(@"111 %@",x);
        }];
    //方法2
    [[view rac_signalForSelector:@selector(sendMsg:)]subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"%@",x);
    }];

}

- (void)more{

    RAC(self.btn,enabled) = [RACSignal combineLatest:@[_tf1.rac_textSignal,_tf2.rac_textSignal] reduce:^id _Nullable(NSString *name,NSString *pwd){
       
        return @(name.length && pwd.length);
    }];
}

- (void)net{

    NetTool *netTool = [NetTool shareTool];
    //订阅 subscribe
    [[netTool getWithURL:@"https://baidu.com" parameters:nil] subscribeNext:^(id  _Nullable x) {
        NSLog(@"xxx = %@",x);
    }];
}

- (void)notification1{

    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"test" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        
        NSLog(@"aaa%@, %@",x.object,x.userInfo);
        
    }];
}

- (void)notification2{

    //takeUntil 信号的有效期
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"test" object:nil]takeUntil:[RACObserve(self.person, name) filter:^BOOL(id  _Nullable value) {
        NSString *n = (NSString *)value;
        NSLog(@"我是name n = %@",n);
        return n.length > 7;
    }]] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"x = %@",x);
    }];
}

- (void)kvo{
    
    //响应式编程
    @weakify(self)
    [RACObserve(self.person, name) subscribeNext:^(id  _Nullable x) {
        NSLog(@"x = %@",x);
        @strongify(self)
        //注意强引用的内存泄漏问题
        self.lab.text = x;
    }];
    
}

- (void)target{

    //target
    //传统oc中解决循环引用问题的方法
//    __weak typeof(self) weakS = self;
    //在RAC中的解决方法
    //导入头文件 #import <ReactiveObjC/RACEXTScope.h>
    @weakify(self)
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSLog(@"x = %@",x);
            //强引用 注意 没有报警告  RAC的坑 循环引用 原来
//            weakS.lab.text = @"hello";
        //现在
        @strongify(self)
        self.lab.text = @"hello";
        }];
    

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
//    _view.frame = CGRectMake(100, 100, 300, 300);
    
    static  int i = 0;
    i++;
    self.person.name = [self.person.name stringByAppendingString:[NSString stringWithFormat:@"%tu",i]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"test" object:self.person userInfo:@{@"test":@"helloRAC"}];
}

- (void)dealloc{

    NSLog(@"dealloc");
}

@end
