//
//  LYDanMuViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/11/7.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "LYDanMuViewController.h"
#import "LYDanMuBackGroundView.h"
#import "LYDanMuModel.h"


@interface LYDanMuViewController ()<LYDanMuBackGroundViewDelegate>
@property (nonatomic, weak) LYDanMuBackGroundView *danmuBackGroundView;
@end

@implementation LYDanMuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.danmuBackGroundView];
    
    
    UIButton *pauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 500, 80, 30)];
    [pauseBtn addTarget:self action:@selector(pauseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [pauseBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [self.view addSubview:pauseBtn];
    
    UIButton *resumeBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 500, 80, 30)];
    [resumeBtn addTarget:self action:@selector(resumeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [resumeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [resumeBtn setTitle:@"继续" forState:UIControlStateNormal];
    [self.view addSubview:resumeBtn];
}

- (void)pauseBtnClick {
    [self.danmuBackGroundView pause];
}

- (void)resumeBtnClick {
    [self.danmuBackGroundView resume];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    LYDanMuModel *model1 = [[LYDanMuModel alloc] init];
    model1.title = @"666";
    model1.beginTime = 2.1;
    model1.liveTime = 5;

    LYDanMuModel *model2 = [[LYDanMuModel alloc] init];
    model2.title = @"徐云流浪中国";
    model2.beginTime = 1.2;
    model2.liveTime = 13;

    [self.danmuBackGroundView.danmuModels addObject:model1];
    [self.danmuBackGroundView.danmuModels addObject:model2];
}

#pragma mark -LYDanMuBackGroundViewDelegate
/**
 当前时间
 */
- (NSTimeInterval)currentTime
{
    static NSTimeInterval ct = 0;
    ct += 1;
    return ct;
}


/**
 根据model 获取相应的弹幕视图(又外界来控制)

 @param model 弹幕模型

 @return 弹幕视图
 */
- (UIView *)danmuViewWithModel: (LYDanMuModel *)model {
    UILabel *label = [[UILabel alloc] init];
    label.text = model.title;
    [label sizeToFit];
    return label;
}

#pragma mark - getter
- (LYDanMuBackGroundView *)danmuBackGroundView {
    if (!_danmuBackGroundView) {
        LYDanMuBackGroundView *backView = [[LYDanMuBackGroundView alloc] initWithFrame:CGRectMake(10, 100, 300, 300)];
        backView.backgroundColor = [UIColor brownColor];
        backView.delegate = self;
        [self.view addSubview:backView];
        _danmuBackGroundView = backView;
    }
    return _danmuBackGroundView;
}

@end
