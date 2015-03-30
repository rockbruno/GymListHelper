//
//  ChartsMenu.h
//  GymListHelper
//
//  Created by Danilo S Marshall on 3/26/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartsMenu : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic)  NSMutableArray *allChartData;
@property (strong,nonatomic)  NSMutableArray *ChartNamesArray;
@property (strong,nonatomic)  NSMutableArray *RoutineNamesArray;
@property (strong,nonatomic)  NSMutableArray *WaitTimesArray;
@property (strong,nonatomic)  NSMutableArray *tableData;

@end
