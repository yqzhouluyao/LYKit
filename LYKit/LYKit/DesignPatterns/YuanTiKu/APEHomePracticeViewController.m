//
//  APEHomePracticeViewController.m
//  LYKit
//
//  Created by zhouluyao on 2022/9/6.
//  Copyright © 2022 zhouluyao. All rights reserved.
//

#import "APEHomePracticeViewController.h"
#import "APEHomePracticeDataController.h"
#import "APEHomePracticeSubjectsView.h"
#import "APEHomePracticeActivityView.h"
#import "APEHomePracticeBannerView.h"
#import "APEHomePracticeSubjectsViewModel.h"

@interface APEHomePracticeViewController () <APEHomePracticeSubjectsViewDelegate>

@property (nonatomic, strong, nullable) UIScrollView *contentView;
@property (nonatomic, strong, nullable) APEHomePracticeBannerView *bannerView;
@property (nonatomic, strong, nullable) APEHomePracticeActivityView *activityView;
@property (nonatomic, strong, nullable) APEHomePracticeSubjectsView *subjectsView;

@property (nonatomic, strong, nullable) APEHomePracticeDataController *dataController;

@end

@implementation APEHomePracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupContentView];
    [self fetchSubjectData];
}

- (void)setupContentView {
    self.contentView = [[UIScrollView alloc] init];
    [self.view addSubview:self.contentView];
    self.bannerView = [[APEHomePracticeBannerView alloc] init];
    self.activityView = [[APEHomePracticeActivityView alloc] init];
    self.subjectsView = [[APEHomePracticeSubjectsView alloc] init];
    self.subjectsView.delegate = self;
    [self.contentView addSubview:self.bannerView];
    [self.contentView addSubview:self.activityView];
    [self.contentView addSubview:self.subjectsView];
    // Layout Views ...
}

- (void)fetchSubjectData {
    [self.dataController requestSubjectDataWithCallback:^(NSError *error) {
        if (error == nil) {
            [self renderSubjectView];
        }
    }];
}

- (void)renderSubjectView {
    APEHomePracticeSubjectsViewModel *viewModel =
        [APEHomePracticeSubjectsViewModel viewModelWithSubjects:self.dataController.openSubjects];
    [self.subjectsView bindDataWithViewModel:viewModel];
}

@end
