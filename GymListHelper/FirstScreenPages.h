//
//  FirstScreenPages.h
//  GymListHelper
//
//  Created by Bruno Henrique da Rocha e Silva on 3/30/15.
//  Copyright (c) 2015 Skeleton Apocalypse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstScreenPages : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIButton *GetStarted;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;

@end