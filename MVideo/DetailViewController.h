//
//  DetailViewController.h
//  MVideo
//
//  Created by LHL on 2017/4/24.
//  Copyright © 2017年 lihongli. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MMovieModel.h"
#import "Masonry.h"

@interface DetailViewController : NSViewController

@property (nonatomic, strong)  MMovieModel *model;

@end
