//
//  ChartEditor.h
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/19/15.
//  Copyright (c) 2015 Coffee Time. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddItemSave.h"

@interface ChartEditor : UIViewController <UITableViewDelegate, UITableViewDataSource, NSObject, UITextFieldDelegate>

@property NSString *itemName;
//@property BOOL completed;
@property (readonly) NSDate *creationDate;
@property (strong,nonatomic)  NSMutableArray *tableData;
@property (strong,nonatomic)  NSMutableArray *allChartData;
@property (strong,nonatomic)  NSMutableArray *ChartNamesArray;
@property (strong,nonatomic)  NSMutableArray *WaitTimesArray;
@property (strong,nonatomic)  NSMutableArray *allInfoData;
@property (strong,nonatomic)  NSMutableArray *allPicData;
@property (strong,nonatomic)  NSMutableArray *allWeightData;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property AddItemSave* child;
@property int ChosenWorkout;
@property int saveToChart;

@end
