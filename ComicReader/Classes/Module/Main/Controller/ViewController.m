//
//  ViewController.m
//  ComicReader
//
//  Created by Jiang on 14-12-2.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITabBarDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17],
                                                                    NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.tabBar.tintColor = [UIColor colorWithRed:1.000 green:0.749 blue:0.000 alpha:1.000];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    NSArray *array = self.tabBar.items;
    for (int i = 0; i < array.count; i++) {
        UITabBarItem *item = array[i];
        NSString *string = [NSString stringWithFormat:@"tab%d_sel.png", i+1];
        if (i == 1) {
            string = @"tab4_sel.png";
        }
        [item setSelectedImage:[UIImage imageNamed:string]];
    }
    [self setSelectedIndex:0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
