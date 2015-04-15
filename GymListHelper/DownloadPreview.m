//
//  DownloadPreview.m
//  GymListHelper
//
//  Created by Rodrigo Dias Takase on 13/04/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//

#import "ChartsMenu.h"
#import "GalleryScreen.h"
#import "DownloadPreview.h"
#import "CJSONDeserializer.h"

@interface DownloadPreview()
@property (weak, nonatomic) IBOutlet UILabel *lbChartName;
@property (weak, nonatomic) IBOutlet UILabel *lbObjective;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserPic;
@property (weak, nonatomic) IBOutlet UILabel *lbUsername;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UITextView *txtExercises;

@end

@implementation DownloadPreview

- (void)viewDidLoad {
    [self LoadChartData];
    
//    NSLog(@"%@",self.currentDownloadChart);
    
    self.lbChartName.text = self.currentDownloadChart[4];
    
    self.lbUsername.text = [NSString stringWithFormat:@"by %@",self.currentDownloadChart[0]];
    
    self.txtDescription.text = self.currentDownloadChart[14];
    
    NSError *error = nil;

    NSString *jsonString = self.currentDownloadChart[15];
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];

    NSArray *DownloadedExercisesArray = [[CJSONDeserializer deserializer] deserializeAsArray:jsonData error:&error];

    jsonString = self.currentDownloadChart[17];
    jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *DownloadedChartNamesArray = [[CJSONDeserializer deserializer] deserializeAsArray:jsonData error:&error];

    jsonString = self.currentDownloadChart[10];
    jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *DownloadedChartCategoriesArray = [[CJSONDeserializer deserializer] deserializeAsArray:jsonData error:&error];

    int firstId = -1;
    NSMutableString* objectives = [NSMutableString new];
    for(int i=0;i<[DownloadedChartCategoriesArray count];i++){
        if([DownloadedChartCategoriesArray[i] isEqualToString:@"YES"]){
            if((i > firstId)&&(firstId != -1)){
                [objectives appendString:@", "];
            }
            if(firstId == -1){
                firstId = i;
            }
            switch(i){
                case 0:
                    [objectives appendString:@"Hypertrophy"];
                    break;
                case 1:
                    [objectives appendString:@"Definition"];
                    break;
                case 2:
                    [objectives appendString:@"Tonification"];
                    break;
                case 3:
                    [objectives appendString:@"Fat Loss"];
                    break;
                case 4:
                    [objectives appendString:@"Strength"];
                    break;
            }
            
        }
    }
    self.lbObjective.text = [NSString stringWithFormat:@"Objective: %@",objectives];
    
    
    NSMutableString *strExercises = [NSMutableString new];
    
    int subroutinesWithExercises = 0;
    int i=0;
    for(NSString *str in DownloadedChartNamesArray){
        [strExercises appendString:@"• "];
        [strExercises appendString:str];
        [strExercises appendString:@"\n"];
        
        if([DownloadedExercisesArray count] != 0){
            NSLog(@"%lu",[DownloadedExercisesArray[i] count]);
            NSLog(@"%@",DownloadedExercisesArray[i]);
            
            subroutinesWithExercises++;
            for(NSString* str2 in DownloadedExercisesArray[i]){
                [strExercises appendString:@"       "];
                [strExercises appendString:str2];
                [strExercises appendString:@"\n"];
            }
        }
        i++;
    }
    
    if(subroutinesWithExercises == 0){
        strExercises = [NSMutableString stringWithString:@"No exercises added"];
    }
    self.txtExercises.text = strExercises;
    
    NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?width=100&height=100",self.currentDownloadChart[1]]];
                        
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    self.imgUserPic.image = image;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"GoToCategory"]){
        GalleryScreen *controller = (GalleryScreen *)segue.destinationViewController;
        controller.ChosenCategory = self.currentCategory;
        
        controller.ChosenCategoryName = self.currentCategoryName;
        
        controller.ChosenLanguage = self.currentLanguage;
    }
    
    else if([segue.identifier isEqualToString:@"GoToCharts"]){
        NSLog(@"GoToCharts segue");
        
        ChartsMenu *controller = (ChartsMenu *)segue.destinationViewController;
        
        NSLog(@"controller = %@",controller);
        
        //SAVE CHART
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath;

        //Add downloaded workout, and a subworkouts
        [self.allChartData addObject: [NSMutableArray array]];
        NSInteger newposition=[self.allChartData count]-1;
        [[self.allChartData objectAtIndex:newposition] addObject: [NSMutableArray array]];

        filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
        [self.allChartData writeToFile:filePath atomically:YES];

        //Adding new chart name
        [self.RoutineNamesArray addObject: self.currentDownloadChart[4]];

        //Add Subroutines names
        [self.ChartNamesArray addObject: [NSMutableArray array]];
        NSString *jsonString = self.currentDownloadChart[17];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSArray *DownloadedChartNamesArray = [[CJSONDeserializer deserializer] deserializeAsArray:jsonData error:&error];
        self.ChartNamesArray[newposition] = DownloadedChartNamesArray;

        //Add Subroutines waitTime
        [self.WaitTimesArray addObject: [NSMutableArray array]];
        jsonString = self.currentDownloadChart[12];
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *DownloadedWaitTimesArray = [[CJSONDeserializer deserializer] deserializeAsArray:jsonData error:&error];
        self.WaitTimesArray[newposition] = DownloadedWaitTimesArray;

        //Add Exercises
        jsonString = self.currentDownloadChart[15];
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *DownloadedExercisesArray = [[CJSONDeserializer deserializer] deserializeAsArray:jsonData error:&error];
        self.allChartData[newposition] = DownloadedExercisesArray;
        
        NSLog(@"%@", DownloadedExercisesArray);
        NSLog(@"%@", controller.allChartData[newposition]);
        
        //Add Categories
        
        
        jsonString = self.currentDownloadChart[10];
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *DownloadedCategoriesArray = [[CJSONDeserializer deserializer] deserializeAsArray:jsonData error:&error];
//        controller.ChartCategoriesArray[newposition] = ;

        [self.ChartCategoriesArray addObject: DownloadedCategoriesArray];
        
        NSLog(@"%@", DownloadedCategoriesArray);
        NSLog(@"%@", controller.ChartCategoriesArray[newposition]);
        
        //Adding owner user for this new Chart
        // separation char: § , param1: userid param2:user name, param3:shared = chartid or 0 if not shared
        NSString* str = [NSString stringWithFormat:@"%@§%@§%@", self.currentDownloadChart[1],self.currentDownloadChart[0],@"1"];
        [self.ByUserArray addObject: str];

        filePath = [documentsDirectory
                    stringByAppendingPathComponent:@"chartNamesFile"];
        [self.ChartNamesArray writeToFile:filePath atomically:YES];

        filePath = [documentsDirectory
                    stringByAppendingPathComponent:@"routineNamesFile"];
        [self.RoutineNamesArray writeToFile:filePath atomically:YES];

        filePath = [documentsDirectory
                    stringByAppendingPathComponent:@"waitTimesFile"];
        [self.WaitTimesArray writeToFile:filePath atomically:YES];

        filePath = [documentsDirectory
                    stringByAppendingPathComponent:@"byUserFile"];
        [self.ByUserArray writeToFile:filePath atomically:YES];
        
        filePath = [documentsDirectory
                    stringByAppendingPathComponent:@"chartDataFile"];
        [self.allChartData writeToFile:filePath atomically:YES];
        
        filePath = [documentsDirectory
                    stringByAppendingPathComponent:@"chartCategoriesFile"];
        [self.ChartCategoriesArray writeToFile:filePath atomically:YES];
        
        //SAVE CHART END
        
        //Update Data
        [self.tableData removeAllObjects];
        self.tableData=[NSMutableArray arrayWithArray:controller.allChartData];
//        [self.tableView reloadData];
    }
    
}

- (IBAction)DownloadAction:(id)sender {
    [self performSegueWithIdentifier: @ "GoToCharts" sender: self];
}

- (void)LoadChartData{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
    
    self.allChartData = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"chartNamesFile"];
    
    self.ChartNamesArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"routineNamesFile"];
    self.RoutineNamesArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"waitTimesFile"];
    self.WaitTimesArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"chartCategoriesFile"];
    self.ChartCategoriesArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"byUserFile"];
    self.ByUserArray = [NSMutableArray arrayWithContentsOfFile:filePath];
}

- (void)SaveCharts{
    //SAVE CHARTS
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"chartDataFile"];
    
    [self.allChartData writeToFile:filePath atomically:YES];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"chartNamesFile"];
    [self.ChartNamesArray writeToFile:filePath atomically:YES];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"routineNamesFile"];
    [self.RoutineNamesArray writeToFile:filePath atomically:YES];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"waitTimesFile"];
    [self.WaitTimesArray writeToFile:filePath atomically:YES];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"chartCategoriesFile"];
    [self.ChartCategoriesArray writeToFile:filePath atomically:YES];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:@"byUserFile"];
    [self.ByUserArray writeToFile:filePath atomically:YES];
    
}

@end
