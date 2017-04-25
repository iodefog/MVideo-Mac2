//
//  ViewController.h
//  MVideo
//
//  Created by LHL on 2017/4/24.
//  Copyright © 2017年 lihongli. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *tableView;

@end

