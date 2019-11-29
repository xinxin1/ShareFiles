//
//  ViewController.m
//  PDF
//
//  Created by valiant on 2019/11/8.
//  Copyright © 2019 xin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
// 当前文件夹的配置文件信息
@property (nonatomic, strong) NSMutableArray *fileProfileArray;

@property (nonatomic, strong) UITableView *table;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
//    [self Xin_setupData];
    
    
    
}


#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //分享的url
    //    NSURL *urlToShare = [NSURL URLWithString:@"http://www.baidu.com"];//分享的标题
    //    NSString *textToShare = @"分享的标题。";
    NSArray *activityItems = @[[UIImage imageNamed:@"1"]];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.popoverPresentationController.sourceView = self.view;
    activityVC.popoverPresentationController.sourceRect = CGRectMake(0,0,1.0,1.0);
    [self presentViewController:activityVC animated:YES completion:nil];
    //不出现在活动项目
    //    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    
    // 分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"completed");
            //分享 成功
        } else  {
            NSLog(@"cancled");
            //分享 取消
        }
    };
}





#pragma mark - Data
/// 获取页面相关数据
- (void)Xin_setupData {
    // 1. 查看当前是否有上级传来的文件夹路径
    if (self.currentFilePath == nil) {
        // 1.1 如果没有，则为根目录
        self.currentFilePath = [self Xin_getRootDocumentsPath];
        // 1.1.2 获取根目录下的配置文件，展示对应的文件夹和文件
        self.fileProfileArray = [NSMutableArray arrayWithArray:[self Xin_getDocumentsProfileArrayWithDocumentPath:self.currentFilePath]];
    }
    else {
        // 1.2 如果有，则直接展示
        self.fileProfileArray = [NSMutableArray arrayWithArray:[self Xin_getDocumentsProfileArrayWithDocumentPath:self.currentFilePath]];
    }
}




#pragma mark - View
// 初始化View界面
- (void)Xin_setupView {
    self.table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.table.dataSource = self;
    self.table.delegate = self;
    [self.view addSubview:self.table];
}



#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fileProfileArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.fileProfileArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    
    return cell;
}

#pragma mark - tableview delegate





#pragma mark - File
/// 1. 获取根文件夹
- (NSString *)Xin_getRootDocumentsPath {
    // 1. 获取路径
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/pdf"];
    // 如果文件夹不存在，则直接创建文件夹
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:filePath]) {
        [manager createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return filePath;
}

/// 2.  获取指定文件夹下的文件配置信息：包括哪些文件、文件夹，以及他们的顺序
- (NSMutableArray *)Xin_getDocumentsProfileArrayWithDocumentPath:(NSString *)documentPath {
    // 1. 获取配置文件的路径
    NSString *profilePath = [documentPath stringByAppendingPathComponent:@"/profile.plist"];
    // 2. 如果配置文件不存在，则创建一个空的配置文件
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:profilePath]) {
        // 2.1 创建空的文件
        [manager createFileAtPath:profilePath contents:nil attributes:nil];
        // 2.2 写入空的数组
        [@[] writeToFile:profilePath atomically:YES];
    }
    
    return [NSMutableArray arrayWithContentsOfFile:profilePath];
}


@end
