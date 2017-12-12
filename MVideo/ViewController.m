//
//  ViewController.m
//  MVideo
//
//  Created by LHL on 2017/4/24.
//  Copyright © 2017年 lihongli. All rights reserved.
//

#import "ViewController.h"
#import "MMovieModel.h"
#import "DetailViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "NameCellView.h"

@interface ViewController() <NSTextFieldDelegate>
{
    DetailViewController *viewController;
}

// 原始数据
@property (nonatomic, strong) NSMutableArray    *originalSource;
// 显示用的数据
@property (nonatomic, strong) NSMutableArray    *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error = nil;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://iodefog.github.io/text/live.txt"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [[NSUserDefaults standardUserDefaults] setObject:text forKey:@"MVideoLiveListKey"];
            [self.originalSource removeAllObjects];
            [self.dataSource removeAllObjects];
            [self transformVideoUrlFromString:text error:error];
            [self.tableView reloadData];

            NSLog(@"error = %@", error);
            
        }];
    });

}


/**
 *  转换字符串变成视频url+name
 *
 *  @param videosText 视频播放的url
 *  @param error      是否有错误
 */
- (void)transformVideoUrlFromString:(NSString *)videosText error:(NSError *)error
{
    // 过滤掉特殊字符 "\r"。有些url带有"\r",导致转换失败
    videosText = [videosText stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    if (!error && (videosText.length > 0)) {
        NSMutableArray *itemArray = [NSMutableArray array];
        // 依据换行符截取一行字符串
        NSArray *videosArray = [videosText componentsSeparatedByString:@"\n"];
        
        for (NSString *subStr in videosArray) {
            // 根据"," 和" " 分割一行的字符串
            NSArray *subStrArray = [subStr componentsSeparatedByString:@","];
            NSArray *sub2StrArray = [subStr componentsSeparatedByString:@" "];
            
            if(subStrArray.count == 2 || (sub2StrArray.count == 2)){
                NSArray *tempArray = (subStrArray.count == 2)? subStrArray : sub2StrArray;
                itemArray = [self checkMultipleUrlInOneUrlWithUrl:[tempArray lastObject] videoName:[tempArray firstObject] itemArray:itemArray];
            }
            else if ([subStr stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0){
                // nothing
            }
            else if (subStrArray.count >= 3 || (sub2StrArray.count >= 3)){
                NSArray *tempArray = (subStrArray.count >= 3)? subStrArray : sub2StrArray;
                NSString *tempUrl = [tempArray objectAtIndex:1];
                itemArray = [self checkMultipleUrlInOneUrlWithUrl:tempUrl.length>5?tempUrl:[tempArray objectAtIndex:2] videoName:[tempArray firstObject] itemArray:itemArray];
            }
            else {
                subStrArray = [subStr componentsSeparatedByString:@" "];
                itemArray = [self checkMultipleUrlInOneUrlWithUrl:[subStrArray lastObject] videoName:[subStrArray firstObject] itemArray:itemArray];
            }
        }
        [self.originalSource addObjectsFromArray:itemArray];
        [self.dataSource addObjectsFromArray:itemArray];
    }else {
        NSLog(@"error %@", error);
    }
}

- (NSMutableArray *)checkMultipleUrlInOneUrlWithUrl:(NSString *)url
                                          videoName:(NSString *)videoName
                                          itemArray:(NSMutableArray *)itemArray
{
    NSArray *multipleArray = [url componentsSeparatedByString:@"#"];
    for (NSString *itemUrl in multipleArray) {
        MMovieModel *model = [MMovieModel getMovieModelWithTitle:videoName ?: @"" url:itemUrl ?: @""];
        [itemArray addObject:model];
        /*
         if (![self isContainObject:itemUrl] && itemUrl && videoName) {
         [self writeNotRepeatURL:itemUrl name:videoName fileName:@"NotRepeat"];
         }
         else {
         [self writeNotRepeatURL:itemUrl name:videoName fileName:@"Repeat"];
         }
         */
    }
    return itemArray;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (NSMutableArray *)originalSource{
    if (!_originalSource) {
        _originalSource = [NSMutableArray array];
    }
    return _originalSource;
}


#pragma mark --


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.dataSource.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSTableCellView *cell = (id)[tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    MMovieModel *model = self.dataSource[row];
    if ([tableColumn.identifier isEqualToString:@"nameCellId"]) {
        // 名称
        [(NameCellView *)cell setObject:model];
    }
    else if ([tableColumn.identifier isEqualToString:@"urlCellId"]) {
        // url
        cell.textField.cell.title = model.url;
    }
    return (id)cell;
}


- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 44;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    return YES;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    
    NSInteger selectedRow = [(NSTableView *)notification.object selectedRow];
    
    if ((selectedRow < 0) && (selectedRow > self.dataSource.count)) {
        return;
    }
    
    MMovieModel *model = self.dataSource[selectedRow];

    NSLog(@"选中");
    
    if (!model.url) {
        return;
    }
    
    viewController = [[DetailViewController alloc] initWithNibName:nil bundle:nil];
    viewController.model = model;
    viewController.title = model.title;
    viewController.view.frame = self.view.bounds;
    [self presentViewControllerAsModalWindow:viewController];
   
}


#pragma mark - textField Delete

- (void)controlTextDidChange:(NSNotification *)obj{
    NSString *text = [obj.object stringValue];
    if ([[text stringByReplacingOccurrencesOfString:@" " withString:@""] length]> 0) {
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.title CONTAINS %@",text];
        NSArray *resultArray = [self.originalSource filteredArrayUsingPredicate:pred];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:resultArray];
    }
    else {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:self.originalSource];
    }
    [self.tableView reloadData];
}

- (void)viewDidLayout{
    [super viewDidLayout];
    viewController.view.frame = self.view.bounds;
}

@end
