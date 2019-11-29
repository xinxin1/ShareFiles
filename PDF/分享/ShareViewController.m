//
//  ShareViewController.m
//  PDF
//
//  Created by valiant on 2019/11/14.
//  Copyright © 2019 xin. All rights reserved.
//

#import "ShareViewController.h"
#import <PDFKit/PDFKit.h>

#import <GTLRDrive.h>
#import <GTLRService.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <EvernoteSDK/EvernoteSDK.h>
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>
#import <BOXContentSDK.h>
#import <OneDriveSDK.h>
#import "MyDocument.h"
// Yandex.disk
#import "YDSession.h"
#import "YOAuth2Delegate.h"
#import "YOAuth2ViewController.h"
// Mail
#import <MessageUI/MessageUI.h>
#import <Accounts/Accounts.h>

// iCloud 唯一标识符，跟设置对应
#define UbiquityContainerIdentifier @"iCloud.com.face.magic"

@interface ShareViewController () <UIPrintInteractionControllerDelegate, GIDSignInDelegate, YDSessionDelegate,YOAuth2Delegate, MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) GTLRService *googleDriveService;
@property (nonatomic, strong) GIDGoogleUser *googleUser;

// Yandex.disk
@property (nonatomic, strong) YDSession *ydSession;
@property (nonatomic, strong) UINavigationController *ydLoginVc;
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}





#pragma mark - View
- (void)setupView {
    NSArray *titleArray = @[@"打印机", @"iCloud", @"查看iCloud", @"google Drive 保存", @"Evernote 保存", @"dropbox 保存", @"box 保存", @"oneDrive 保存", @"Yandex.disk 保存", @"邮件保存", @"给自己发邮件"];
    NSArray *actionArray = @[@"printAction", @"iCloudAction", @"presentDocumentPicker", @"googleDriveAction", @"evernoteAction", @"dropboxAction", @"boxAction", @"oneDriveAction", @"yandexAction", @"emailAction", @"emailToSelfAction"];
    for (int i=0; i<titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        button.frame = CGRectMake(10, 40+i*35, 300, 30);
        [button addTarget:self action:NSSelectorFromString(actionArray[i]) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    
    
}



#pragma mark - Action
/// 链接打印机
- (void)printAction {
    UIPrintInteractionController *print = [UIPrintInteractionController sharedPrintController];
    NSMutableArray *tempMarr = [NSMutableArray arrayWithCapacity:0];
    NSData *pdfData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"pdf"]];
    if (!pdfData) {
        NSLog(@"file not exist");
        return;
    }
    [tempMarr addObject:pdfData];

    // ⚠️ 打印图片,与PDF不能同时打印

    if (print) {
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        // 打印输出类型
//        printInfo.outputType = UIPrintInfoOutputPhoto;
        printInfo.outputType = UIPrintInfoOutputGeneral;
        // 默认应用程序名称
        printInfo.jobName = @"PDF";
        // 双面打印信息,NONE为禁止双面
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        // 打印纵向还是横向
        printInfo.orientation = UIPrintInfoOrientationPortrait;
        print.printInfo = printInfo;

        print.delegate = self;
//        print.showsPageRange = YES;
        print.printingItems = tempMarr;

        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            if (completed) {
                NSLog(@"打印完成");
            }else {
                NSLog(@"打印取消");
            }
            if (error) {
                NSLog(@"打印出错");
            }
        };
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [print presentFromRect:self.view.frame inView:self.view animated:YES completionHandler:completionHandler];
        } else {
            self.modalPresentationStyle = UIModalPresentationFullScreen;
            [print presentAnimated:YES completionHandler:completionHandler];
        }
    }
}

/// iCloud
- (void)iCloudAction {
    //默认的icloud Documents容器的Indentifier
    NSString * const ubiquityIndentifier = @"iCloud.com.face.magic";
    NSURL *url = getDocumentUrlWithPath(nil);
    NSArray *documents = @[@"4.pdf"];
    for (NSString *documentName in documents)
    {
        BOOL t = [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:documentName]
                                                toPath:[url.path stringByAppendingPathComponent:documentName]
                                                 error:nil];
        NSLog(@"isSuccess : %d",t);
    }
}

//获取icloud Documents根文件夹或者子文件夹地址
NSURL* getDocumentUrlWithPath(NSString *path)
{
//    NSString * const ubiquityIndentifier = @"iCloud.com.face.magic";
    NSString * const ubiquityIndentifier = @"iCloud.com.face.magic";
    
    NSURL *url = nil;
    url = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:ubiquityIndentifier];
    NSLog(@"------url:%@",url);
    if (url && path) {
        url = [[url URLByAppendingPathComponent:@"Documents"] URLByAppendingPathComponent:path];
        return url;
    }else if(!path) {
        // 如果不存在文件夹，则直接创建一个文件夹
        if (![[NSFileManager defaultManager] fileExistsAtPath:[url URLByAppendingPathComponent:@"Documents"].path]) {
            [[NSFileManager defaultManager] createDirectoryAtURL:[url URLByAppendingPathComponent:@"Documents"] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        return [url URLByAppendingPathComponent:@"Documents"];
    }else {
        NSLog(@"Please check out that iCloud had been signed in");
        return url;
    }
    return url;
}

- (void)presentDocumentPicker {
    NSArray *documentTypes = @[@"public.content", @"public.text", @"public.source-code ", @"public.image", @"public.audiovisual-content", @"com.adobe.pdf", @"com.apple.keynote.key", @"com.microsoft.word.doc", @"com.microsoft.excel.xls", @"com.microsoft.powerpoint.ppt"];
    
    UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes
                                                                                                                          inMode:UIDocumentPickerModeOpen];
//    documentPickerViewController.delegate = self;
    [self presentViewController:documentPickerViewController animated:YES completion:nil];
}


/// iCloud 导入2。-  BUG：文件可能失败
- (void)iCloudImportAction {
    NSLog(@"uploadDoc");
    //文档名字
//    NSString *fileName =@"1.txt";
    NSString *fileName =@"4.pdf";
    NSURL *url = [self getUbiquityContainerUrl:fileName];
//    NSURL *url = getDocumentUrlWithPath(fileName);
    MyDocument *doc = [[MyDocument alloc] initWithFileURL:url];
//    UIDocument *doc = [[UIDocument alloc] initWithFileURL:url];
//    文档内容
//    NSString*str = @"测试文本数据";
//    doc.myData = [str dataUsingEncoding:NSUTF8StringEncoding];
    doc.myData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"4.pdf" ofType:nil]];
    [doc saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"创建成功");
        }
        else{
            NSLog(@"创建失败");
        }
    }];
}
//获取url
-(NSURL*)getUbiquityContainerUrl:(NSString*)fileName{
    NSURL *myUrl = nil;
    if (!myUrl) {
        myUrl = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:UbiquityContainerIdentifier];
        if (!myUrl) {
            NSLog(@"未开启iCloud功能");
            return nil;
        }

    }
    NSURL *url = [myUrl URLByAppendingPathComponent:@"Documents"];
    url = [url URLByAppendingPathComponent:fileName];
    return url;
}


/// iCloud 导入3 - BUG：没有移动权限
- (void)btnStoreTapped {
    // Let's get the root directory for storing the file on iCloud Drive
    [self rootDirectoryForICloud:^(NSURL *ubiquityURL) {
        NSLog(@"1. ubiquityURL = %@", ubiquityURL);
        if (ubiquityURL) {
            // We also need the 'local' URL to the file we want to store
            NSURL *localURL = [self localPathForResource:@"4" ofType:@"pdf"];
            NSLog(@"2. localURL = %@", localURL);

            // Now, append the local filename to the ubiquityURL
            ubiquityURL = [ubiquityURL URLByAppendingPathComponent:localURL.lastPathComponent];
            NSLog(@"3. ubiquityURL = %@", ubiquityURL);

            // And finish up the 'store' action
            NSError *error;
            if (![[NSFileManager defaultManager] setUbiquitous:YES itemAtURL:localURL destinationURL:ubiquityURL error:&error]) {
                NSLog(@"Error occurred: %@", error);
            }
        }
        else {
            NSLog(@"Could not retrieve a ubiquityURL");
        }
    }];
}

- (void)rootDirectoryForICloud:(void (^)(NSURL *))completionHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *rootDirectory = [[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] URLByAppendingPathComponent:@"Documents"];

        if (rootDirectory) {
            if (![[NSFileManager defaultManager] fileExistsAtPath:rootDirectory.path isDirectory:nil]) {
                NSLog(@"Create directory");
                [[NSFileManager defaultManager] createDirectoryAtURL:rootDirectory withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(rootDirectory);
        });
    });
}

- (NSURL *)localPathForResource:(NSString *)resource ofType:(NSString *)type {
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    return [NSURL fileURLWithPath:resourcePath];
}



/// Google Drive
- (void)googleDriveAction {
    // 数据初始化
    self.googleDriveService = [GTLRDriveService new];
    
    [self googleLogin];
}

// 1. 登录
- (void)googleLogin {
    // 如果没有登录，则去登录
    if ([GIDSignIn sharedInstance].currentUser == nil) {
        GIDSignIn.sharedInstance.delegate = self;
        GIDSignIn.sharedInstance.scopes = @[kGTLRAuthScopeDrive];
        // 因为不能正常读取GoogleService文件中的属性，因此手动设置
        GIDSignIn.sharedInstance.clientID = @"19603075583-d8eutqdn957od7veesggt4d1morkpuak.apps.googleusercontent.com";
        GIDSignIn.sharedInstance.presentingViewController = self;
        [GIDSignIn.sharedInstance signIn];
    }else {
        [self uploadFile:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"pdf"] isImage:NO];
    }
}


- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (error == nil) {
        self.googleDriveService.authorizer = user.authentication.fetcherAuthorizer;
        self.googleUser = user;
        
        [self uploadFile:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"pdf"] isImage:NO];
    }else {
        self.googleDriveService.authorizer = nil;
        self.googleUser = nil;
    }
}

- (void)uploadFile:(NSString *)filePath isImage:(BOOL)isImage {
    if (!filePath || ![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"file not exist");
        return;
    }
    // 4M 以内
    NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:filePath];
    GTLRDrive_File *metadata = [GTLRDrive_File object];
    metadata.name = isImage?@"4.jpeg":@"4.pdf";

    GTLRUploadParameters *uploadParameters = [GTLRUploadParameters uploadParametersWithData:fileData MIMEType:isImage?@"image/jpeg":@"application/pdf"];
    uploadParameters.shouldUploadWithSingleRequest = TRUE;
    GTLRDriveQuery_FilesCreate *query = [GTLRDriveQuery_FilesCreate queryWithObject:metadata
                                                                   uploadParameters:uploadParameters];
    query.fields = @"id";
    GTLRService *driveService = [[GTLRService alloc] init];
    driveService.APIKey = @"AIzaSyBbmukUdjQaU-mMf5IvwY7Hjx10q0kqKFU";
    driveService.rootURLString = @"https://www.googleapis.com/upload/drive/v3/";
    driveService.authorizer = self.googleDriveService.authorizer;
    [driveService executeQuery:query completionHandler:^(GTLRServiceTicket *ticket,
                                                         GTLRDrive_File *file,
                                                         NSError *error) {
        if (error == nil) {
            NSLog(@"File ID %@", file.identifier);
        } else {
            NSLog(@"An error occurred: %@", error);
        }
    }];
}



/// Evernote 印象笔记
//Consumer Key: valiant
//Consumer Secret: e4623f526044de60
- (void)evernoteAction {
    if ([ENSession sharedSession].isAuthenticated) {
        [self evernoteUploadWithFilePath:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"pdf"]];
    }else {
        // 测试URL,正式环境需要运营处理
        [[ENSession sharedSession] setValue:@"sandbox.yinxiang.com" forKey:@"sessionHost"];
        [[ENSession sharedSession] authenticateWithViewController:self preferRegistration:YES completion:^(NSError * _Nullable authenticateError) {
            if (authenticateError) {
                // 授权失败
                if (authenticateError.code == ENErrorCodeCancelled) {
                    // 取消授权
                }
            }else {
                // 授权成功
                [self evernoteUploadWithFilePath:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"pdf"]];
            }
        }];
    }
}
- (void)evernoteUploadWithFilePath:(NSString *)filePath {
    ENNote *note = [ENNote new];
    note.content = [ENNoteContent noteContentWithString:@"一个测试"];
    note.title = @"我的PDF";
    NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:filePath];
    ENResource *resource = [[ENResource alloc] initWithData:fileData mimeType:@"application/pdf"];
    [note addResource:resource];
//    [[ENSession sharedSession] setValue:@"sandbox.evernote.com" forKey:@"sessionHost"];
    [[ENSession sharedSession] uploadNote:note notebook:nil completion:^(ENNoteRef * _Nullable noteRef, NSError * _Nullable uploadNoteError) {
        NSLog(@"");
    }];
}




/// Dropbox
//Dropbox
//应用程式金钥 xc9ycmqax1jm4v7
//应用秘密 wxqgadfkv8c2ik1
//https://www.jianshu.com/p/1ad596daf2f6
- (void)dropboxAction {
    [self dropboxAuthor];
}
// 授权
- (void)dropboxAuthor {
    if ([DBClientsManager authorizedClient].isAuthorized) {
        [self dropboxUploadFile:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"pdf"]];
    }else {
        [DBClientsManager authorizeFromController:[UIApplication sharedApplication] controller:self openURL:^(NSURL *url) {
            // 这里发送消息给delegate
            [[UIApplication sharedApplication] openURL:url options:nil completionHandler:^(BOOL success) {
                
            }];
            
            // 这里做处理
            DBOAuthResult *authResult = [DBClientsManager handleRedirectURL:url];
            if (authResult != nil) {
              if ([authResult isSuccess]) {
                NSLog(@"Success! User is logged into Dropbox.");
                [self dropboxUploadFile:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"pdf"]];
              } else if ([authResult isCancel]) {
                NSLog(@"Authorization flow was manually canceled by user!");
              } else if ([authResult isError]) {
                NSLog(@"Error: %@", authResult);
              }
            }
        }];
    }
}
- (void)dropboxUploadFile:(NSString *)filePath {
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];

    // For overriding on upload
    DBFILESWriteMode *mode = [[DBFILESWriteMode alloc] initWithOverwrite];
    
    DBUserClient *client = [DBClientsManager authorizedClient];
    [[[client.filesRoutes uploadData:@"/4.pdf" mode:mode autorename:@(YES) clientModified:nil mute:@(NO) propertyGroups:nil inputData:fileData] setResponseBlock:^(DBFILESFileMetadata * _Nullable result, DBFILESUploadError * _Nullable routeError, DBRequestError * _Nullable networkError) {
        if (result) {
            NSLog(@"%@\n", result);
        } else {
            NSLog(@"%@\n%@\n", routeError, networkError);
        }
    }] setProgressBlock:^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        NSLog(@"\n%lld\n%lld\n%lld\n%.2f%%\n", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite,totalBytesWritten*100.0/totalBytesExpectedToWrite);
    }];
}



/// Box
//客户编号   jvhllgfnp8fdwra0pp1fkavhlah1q2wd
//客户机密  YcmOZ6gMdqnrqEgN736b0Kxndglg8ACm
// 刚创建App需要用命令行跑给出的命令获取文件列表
// 需要设置scheme和回调URI
// 帮助文档：https://raw.githubusercontent.com/box/box-ios-sdk/v1.0.11/doc/Files.md
//  https://developer.box.com/en/sdks-and-tools/
- (void)boxAction {
    [self boxAuthor];
}
// 授权
- (void)boxAuthor {
    BOXContentClient *client = [BOXContentClient defaultClient];
    [client authenticateWithCompletionBlock:^(BOXUser *user, NSError *error) {
        if (error == nil) {
            [self boxFileUploadWithFilePath:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"pdf"]];
        }else {
            NSLog(@"授权失败");
        }
    }];
}
// 上传box的URL：https://upload.box.com/api/2.0/files/content
- (void)boxFileUploadWithFilePath:(NSString *)filePath {
    BOXContentClient *contentClient = [BOXContentClient defaultClient];
    BOXFileUploadRequest *uploadRequest = [contentClient fileUploadRequestToFolderWithID:BOXAPIFolderIDRoot fromLocalFilePath:filePath];

    // Optional: By default the name of the file on the local filesystem will be used as the name on Box. However, you can
    // set a different name for the file by configuring the request:
    uploadRequest.fileName = @"filena.pdf";

    [uploadRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
        NSLog(@"upload -- %.2f",1.0*totalBytesTransferred/totalBytesExpectedToTransfer);
    } completion:^(BOXFile *file, NSError *error) {
        NSLog(@"%@",error);
        NSLog(@"%@",file);
    }];
    
}





/// oneDrive
//Display name: FaceMagic
//Application (client) ID:57e69a64-c944-401f-bc5e-f9b3b6359571
//Object ID:148cfd51-3414-40dd-b92c-e22259746191
// 帮助文档：https://github.com/OneDrive/onedrive-sdk-ios
// 个人网盘：https://onedrive.live.com/?id=root&cid=6EC43E7A244E9DC3
- (void)oneDriveAction {
    [self oneDriveAuthor];
}
// 授权
- (void)oneDriveAuthor {
    [ODClient clientWithCompletion:^(ODClient *client, NSError *error){
       if (!error){
           NSLog(@"oneDrive授权成功");
           // 检索用户驱动
//           [[[client drive] request] getWithCompletion:^(ODDrive *drive, NSError *error){
//               //Returns an ODDrive object or an error if there was one
//               NSLog(@"");
//           }];
           // 获取用户根文件夹驱动
//           [[[[client drive] items:@"root"] request] getWithCompletion:^(ODItem *item, NSError *error){
//               //Returns an ODItem object or an error if there was one
//               NSLog(@"");
//           }];
           
           // 上传文件
           [self oneDriveUploadFile:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"pdf"] client:client];
       }else {
           NSLog(@"oneDrive授权失败");
       }
    }];
}
// 上传
- (void)oneDriveUploadFile:(NSString *)filePath client:(ODClient *)client{
    NSLog(@"file begin upload by oneDrive");
    [[[[[[client drive] items:@"root"] itemByPath:filePath.lastPathComponent] contentRequest] uploadFromFile:[NSURL fileURLWithPath:filePath] completion:^(ODItem *response, NSError *error) {
        if (error) {
            NSLog(@"上传失败");
        }else {
            NSLog(@"");
        }
    }] execute];
}




#pragma mark -  Yandex.Disk 俄罗斯网盘
//ID（标识号）：24aa9da88a8a4b93b4a991f544cdd4cf
//密码：5d480a0d34f740cd8681525a278d6a15
//回调网址：https://yx24aa9da88a8a4b93b4a991f544cdd4cf.oauth.yandex.ru/auth/finish?platform=ios
- (void)yandexAction {
    [self yandexAuthor];
}
// 授权
- (void)yandexAuthor {
    if (self.ydSession == nil) {
        self.ydSession = [[YDSession alloc] initWithDelegate:self];
    }
    // 如果没有认证
    if (!self.ydSession.authenticated) {
        YOAuth2ViewController *vc = [[YOAuth2ViewController alloc] initWithDelegate:self];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        self.ydLoginVc = nav;
        [self presentViewController:nav animated:YES completion:nil];
    }else {
        [self yandexUploadFile:[[NSBundle mainBundle] pathForResource:@"4.pdf" ofType:nil]];
    }
}
// 上传
- (void)yandexUploadFile:(NSString *)filePath {
    [self.ydSession uploadFile:filePath toPath:[NSString stringWithFormat:@"/%@",filePath.lastPathComponent] completion:^(NSError *err) {
        NSLog(@"err");
    }];
    [self.ydSession fetchDirectoryContentsAtPath:@"/" completion:^(NSError *err, NSArray *list) {
        NSLog(@"%@",list);
    }];
}


#pragma mark  YDSessionDelegate

-(NSString *)userAgent
{
    return @"A1B2C3D4E6.com.face.magic";
}


#pragma mark  YOAuth2Delegate

- (NSString *)clientID
{
//#error Replace the following with the data you got when registering your app at: https://oauth.yandex.ru/
//    return @"00112233445566778899aabbccddeeff";
    return @"24aa9da88a8a4b93b4a991f544cdd4cf";
}

-(NSString *)redirectURL
{
//#warning Replace the following with the data you got when registering your app at: https://oauth.yandex.ru/
    return @"https://yx24aa9da88a8a4b93b4a991f544cdd4cf.oauth.yandex.ru/auth/finish?platform=ios";
}

- (void)OAuthLoginSucceededWithToken:(NSString *)token
{
    self.ydSession.OAuthToken = token;
    [self.ydLoginVc dismissViewControllerAnimated:YES completion:^{
        [self yandexUploadFile:[[NSBundle mainBundle] pathForResource:@"4.pdf" ofType:nil]];
    }];
}

- (void)OAuthLoginFailedWithError:(NSError *)error
{
    NSLog(@"It's time to PANIC: %@", error);
    [self.ydLoginVc dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - 邮件发送
- (void)emailAction {
    [self sendMailWithFilePath:[[NSBundle mainBundle] pathForResource:@"4.pdf" ofType:nil]];
}
- (void)sendMailWithFilePath:(NSString *)filePath {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
        mailController.mailComposeDelegate = self;
        // 标题
        [mailController setSubject:[filePath lastPathComponent]];
        // 收件箱
        [mailController setToRecipients:[NSArray arrayWithObjects:@"123456789@qq.com", nil]];
        // 内容
        [mailController setMessageBody:@"This is content" isHTML:NO];

        // 附件
        NSData *Data = [NSData dataWithContentsOfFile:filePath];
        //发送文件的NSData，类型，附件名,根据实际x情况进行修改
        [mailController addAttachmentData:Data mimeType:@"application/pdf" fileName:[filePath lastPathComponent]];

        [self presentViewController:mailController animated:YES completion:nil];
    }else {
        NSLog(@"Your iPhone can't send Mail");
    }
}
#pragma mark MFMailComposeViewControllerDelegate

 - (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    NSString *resultString = nil;
    switch (result){
        case MFMailComposeResultCancelled:
            resultString = [NSString stringWithFormat:@"Mail send canceled…"];
            break;
        case MFMailComposeResultSaved:
            resultString = [NSString stringWithFormat:@"Mail saved…"];
            break;
        case MFMailComposeResultSent:
            resultString = [NSString stringWithFormat:@"Mail sent out…"];
            break;
        case MFMailComposeResultFailed:
            resultString = [NSString stringWithFormat:@"%@", [error localizedDescription]];
            break;
        default:
            break;
    }
    NSLog(@"%@",resultString);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:resultString delegate:self cancelButtonTitle:@"取消"otherButtonTitles:nil];
    [alert show];
    [self dismissViewControllerAnimated:YES completion:nil];
//    mailController = nil;
}


#pragma mark - 邮件发送给自己
- (void)emailToSelfAction {
    [self tttt];
    NSLog(@"");
//    [self sendMailWithFilePath:[[NSBundle mainBundle] pathForResource:@"4.pdf" ofType:nil] Recipients:@[@"self"]];
}

- (void)sendMailWithFilePath:(NSString *)filePath Recipients:(NSArray *)recipients{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
        mailController.mailComposeDelegate = self;
        // 标题
        [mailController setSubject:[filePath lastPathComponent]];
        // 收件箱
//        [mailController setToRecipients:[NSArray arrayWithObjects:@"v20180330@126.com", nil]];
        [mailController setToRecipients:recipients];
        // 内容
        [mailController setMessageBody:@"This is content" isHTML:NO];

        // 附件
        NSData *Data = [NSData dataWithContentsOfFile:filePath];
        //发送文件的NSData，类型，附件名,根据实际x情况进行修改
        [mailController addAttachmentData:Data mimeType:@"application/pdf" fileName:[filePath lastPathComponent]];

        [self presentViewController:mailController animated:YES completion:nil];
    }else {
        NSLog(@"Your iPhone can't send Mail");
    }
}

- (void)tttt {
    //创建操作对象
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    NSArray *accountArray = accountStore.accounts;
    
    NSLog(@"");
}


@end
