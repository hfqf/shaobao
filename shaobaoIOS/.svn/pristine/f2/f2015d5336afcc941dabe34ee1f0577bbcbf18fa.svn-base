//
//  PDFListTableViewController.m
//  PDF签批
//
//  Created by 百润百成 on 2017/1/4.
//  Copyright © 2017年 百润百成. All rights reserved.
//

#import "PDFListTableViewController.h"
#import "SVProgressHUD.h"
#import "SignPDFViewController.h"

#define HEIGHTFORROW 50.0
//保存pdf文件名的plist文件
#define PDFNAME_PATH_PLIST @"pdfNamePath.plist"

@interface PDFListTableViewController ()

@property(nonatomic,strong)SignPDFViewController *signPDFViewController;
@property(nonatomic,strong)UILabel *promptLabel;
@property(nonatomic,strong) NSMutableArray *pdfNameArray;
@property(nonatomic,strong) NSString *pdfPath;
@property(nonatomic,strong)NSString *filename;
@property(nonatomic,strong)NSString *pdfName;
//@property(nonatomic,strong)UIBarButtonItem *rightButton;
//@property(nonatomic,strong)UIBarButtonItem *leftButton;
@property(nonatomic,assign)NSInteger deleteIndex;

@end

//alert view tag
enum{
    tagOfAlertViewForDeletePDFile = 1000,
};

@implementation PDFListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"PDF签批", nil);
    //设置导航栏按钮
    //[self setNavigationBar];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    
    //解档plist文件中的pdf文件名
    [self unarchiveFile];

}

#pragma mark  -- 设置导航栏按钮
//-(void)setNavigationBar{
//    self.rightButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"管理", nil) style:UIBarButtonItemStylePlain target:self action:@selector(editPDFList)];
//    self.navigationItem.rightBarButtonItem = self.rightButton;
//    self.leftButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"", nil) style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    self.navigationItem.leftBarButtonItem = self.leftButton;
//}


//#pragma mark -- 导航栏右侧按钮
//-(void)editPDFList{
//    
//}
//
//#pragma mark -- 导航左侧按钮，返回到主界面或是结束预览到列表
//-(void)back{
//    
//}


-(void)unarchiveFile{
    
    NSString *privatePDF = PDFNAME_PATH_PLIST;
    // 获取文件路径,获得pdf文件名的数组
    NSString *pdfNameFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:privatePDF];
    //解档pdf文件名数组
    self.pdfNameArray = [NSKeyedUnarchiver unarchiveObjectWithFile:pdfNameFilePath];
    //归档
    [NSKeyedArchiver archiveRootObject:self.pdfNameArray toFile:pdfNameFilePath];
    if (self.pdfNameArray.count == 0 ) {
        //没有pdf，则提示用户
        [self addPromptLabel];
    }
    [self.tableView reloadData];
}

#pragma mark --把第三方的pdf文件保存到沙河document文件夹中
-(void)preservePDF:(NSURL *)url withFilename:(NSString*)filename
{
    [SVProgressHUD showWithStatus:@"正在拷贝,请稍等..."];
    //新建document路径
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    url = nil;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString* filePath = [documentPath stringByAppendingPathComponent:response.suggestedFilename];
        NSError *fileError = nil;
        //将tmp下面的文件移动到document文件下
        [manager moveItemAtPath:location.path toPath:filePath error:&fileError];
        
        if(fileError) {
            [SVProgressHUD showErrorWithStatus:@"拷贝失败"];
        }else {
            // 获得文件名（带后缀）
            NSString *pdfName = [filePath lastPathComponent];
            //解档数组
            self.pdfNameArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
            //把pdf路径保存到数组
            [self.pdfNameArray insertObject:pdfName atIndex:0];
            //归档
            [NSKeyedArchiver archiveRootObject:self.pdfNameArray toFile:filename];
            [SVProgressHUD showSuccessWithStatus:@"拷贝成功,请下拉刷新！"];
            if (self.promptLabel != nil) {
                [self.promptLabel removeFromSuperview];
                self.promptLabel = nil;
            }
            [self.tableView reloadData];
        }
    }];
    //发送请求(执行数据任务)
    [task resume];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.pdfNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDFNameCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PDFNameCell"];
    }
    cell.textLabel.text = self.pdfNameArray[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHTFORROW;
}

#pragma mark -- table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.signPDFViewController = [[SignPDFViewController alloc]init];
    //获取数组中文件名对应的文件路径
    self.pdfName = [self.pdfNameArray objectAtIndex:indexPath.row];
    self.pdfPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:self.pdfName];
    self.signPDFViewController.PDFFilePath = self.pdfPath;
    [self.navigationController pushViewController:self.signPDFViewController animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    self.deleteIndex = indexPath.row;
    [self deletePDFFile];
}

#pragma mark -- 删除PDF文件
-(void)deletePDFFile{
    
    NSString *privatePDF = PDFNAME_PATH_PLIST;
    NSFileManager* fileManager=[NSFileManager defaultManager];
    //获取数组中文件名对应的文件路径
    NSString *pdfName = [self.pdfNameArray objectAtIndex:self.deleteIndex];
    self.pdfPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0] stringByAppendingPathComponent:pdfName];
    if (self.pdfPath && self.pdfNameArray.count>1) {
        //删除文件
        [fileManager removeItemAtPath:self.pdfPath error:nil];
        // 获取文件路径,获得pdf文件名的数组
        NSString *pdfNameFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:privatePDF];
        //解档pdf文件名数组
        self.pdfNameArray = [NSKeyedUnarchiver unarchiveObjectWithFile:pdfNameFilePath];
        //删除归档中的文件名
        [self.pdfNameArray removeObjectAtIndex:self.deleteIndex];
        //归档
        [NSKeyedArchiver archiveRootObject:self.pdfNameArray toFile:pdfNameFilePath];
    }else if (self.pdfPath && self.pdfNameArray.count == 1){
        //删除文件
        [fileManager removeItemAtPath:self.pdfPath error:nil];
        // 获取文件路径,获得pdf文件名的数组
        NSString *pdfNameFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:privatePDF];
        //解档pdf文件名数组
        self.pdfNameArray = [NSKeyedUnarchiver unarchiveObjectWithFile:pdfNameFilePath];
        //删除归档中的文件名
        [self.pdfNameArray removeAllObjects];
        //归档
        [NSKeyedArchiver archiveRootObject:self.pdfNameArray toFile:pdfNameFilePath];
    }

    [self.tableView reloadData];
    
    if (self.pdfNameArray.count == 0) {
        [self addPromptLabel];
    }
}

-(void)addPromptLabel{
    self.promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 107, self.view.bounds.size.width - 100, 50)];
    self.promptLabel.text = NSLocalizedString(@"没有PDF，可从其它APP分享PDF到当前APP", nil);
    self.promptLabel.numberOfLines = 2;
    self.promptLabel.font = [UIFont systemFontOfSize:20];
    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    self.promptLabel.textColor = [UIColor blackColor];
    [self.promptLabel sizeToFit];
    [self.view addSubview:self.promptLabel];
}

#pragma mark -- 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark -- 懒加载
- (NSString *)pdfPath {
    if(_pdfPath == nil) {
        _pdfPath = [[NSString alloc] init];
    }
    return _pdfPath;
}

- (NSMutableArray *)pdfNameArray {
    if(_pdfNameArray == nil) {
        _pdfNameArray = [[NSMutableArray alloc] init];
    }
    return _pdfNameArray;
}

- (NSString *)filename {
    if(_filename == nil) {
        _filename = [[NSString alloc] init];
    }
    return _filename;
}

- (NSString *)pdfName {
    if(_pdfName == nil) {
        _pdfName = [[NSString alloc] init];
    }
    return _pdfName;
}
@end
