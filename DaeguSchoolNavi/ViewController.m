//
//  ViewController.m
//  DaeguSchoolNavi
//
//  Created by SKOINFO_MACBOOK on 2015. 11. 27..
//  Copyright (c) 2015년 SKOINFO. All rights reserved.
//

#import "ViewController.h"
#import "NSData+AES.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import <CommonCrypto/CommonHMAC.h>
#import <commoncrypto/commoncryptor.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"
#import "StoreParser.h"
#import "Sub_Cell_1.h"
#import "Sub_Cell_2.h"
#import "TFHpple.h"
#import <CommonCrypto/CommonDigest.h>

//#import "DESEncryptor.h"


#define ENCRYPT_KEY                 @"ab_booktv_abcd10"
#define kUseLoginEncrypt            1                   //로그인할때 비밀번호 암호화 할지여부


@interface UIWebView (Javascript)
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id *)frame;
@end

@implementation UIWebView (Javascript)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id *)frame
{
    ViewController *mainViewControllerPtr = (ViewController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                    message:message
                                                   delegate:mainViewControllerPtr
                                          cancelButtonTitle:@"확인"
                                          otherButtonTitles:nil];
    alert.tag = 9999;
    [alert show];
}

@end

@interface ViewController () <UITextFieldDelegate>
{
    UIWebView *reHome_webView;
    
    NSString *nowTagStr_code;
    NSString *nowTagStr_startDate;
    NSString *nowTagStr_endDate;
    NSString *nowTagStr_popupContent;
    
    NSString *errorXMLcodeStr;
    NSString *errorXMLstartStr;
    NSString *errorXMLendStr;
    NSString *errorXMLdataStr;
    
    NSURLConnection *mainCheck_connection3_1;
    int mainCheck3_1_intVal;
    
    NSIndexPath *settingView_selectIndexPath;
    
    UIAlertView *loginSuccessAlertView;
    
    UIAlertView *eventCloseAlert;
    
    UIAlertView *schoolAdd_noClubAlert;
    NSString *schoolAdd_noClubDomainIDStr;
    
    BOOL noValue_mySchool_YN;
    NSString *noValue_mySchool_idxStr;
    
    NSString *setting_domainId;
    
    NSMutableArray *CS_detailArray;
    BOOL CS_YorN;
    BOOL CSchangeYN;
    NSIndexPath *CS_indexPath;
    
    BOOL isOpen;
    BOOL isOpen_subTL;
    
    NSIndexPath *selectIndex;
    NSIndexPath *selectIndex_subTL;
    
    NSIndexPath *custom_settingIndexPath;
    
    UIAlertView *versionAlertView;
    
    BOOL push_login_ingYN;
    NSURL *push_login_urlStr;
    NSString* push_loginDomainIDstr;
    
    BOOL tab2btn_selectYN;
    BOOL tab2btn_login_selectYN;
    
    NSString *guestArrayStr;
    
    UIAlertView *pushAlertView;
    NSArray *pushObjectArray_main;
    
    NSString *main_WebViewURLStr;
    NSString *now_WebViewURLStr;
    
    BOOL webviewLogoutYN;
    
    BOOL isPic;
    BOOL isVideo;
    
    NSString *mainDomID;
    
    NSString *aes_key;
    
    NSData *aesData;
    NSString *aes_idStr, *aes_pwStr;
    
    BOOL schoolClub_addYchangeN;
    
    NSString *changeIdxStr;
    NSString *changeMainHomeURLStr;
    NSString *changeDomStr;
    
    BOOL settingAction_webViewYN;
    NSString *settingAction_webView_domainIDstr;
    
    BOOL autoLoginYN;
    
    NSData *vData;
    NSString *video_url;
    UIImageView *picView;
    
    NSString *ssoKey;
    
    NSString *domainNm;
    NSString *domain;
    NSString *boardId;
    NSString *menuCd;
    NSString *domainId;
    NSString *userNick;
    
    NSString *test_ssoKey;
    
    //send
    NSURLConnection *sendConnection;
    NSMutableData *sendData;
    //send_video
    NSURLConnection *videoConnection;
    NSMutableData *videoData;
    
    NSURLConnection *getConnection;
    NSMutableData *getData;
    
    NSURLConnection *logoutConnection;
    NSMutableData *logoutData;
    
    NSURLConnection *logoutAlert_Connection;
    NSMutableData *logoutAlert_Data;
    
    NSString *mobileUrlPath;
    NSString *mobileMovFile;
    NSString *mobileThumbFile;
    NSString *key;
    
    
    NSMutableData *fileDownload_data;
    NSURLConnection *fileDownload_connection;
    NSString *fileDownload_request;
    NSString *fileDownload_nameStr;
    
    NSMutableData *alramSetting_data;
    NSMutableDictionary *alramSetting_news;
    NSURLConnection *alramSetting_connection;
    
    NSMutableData *event_data;
    NSMutableDictionary *event_news;
    NSURLConnection *event_connection;
    
    NSMutableData *error_data;
    NSMutableDictionary *error_news;
    NSURLConnection *error_connection;
    
    NSMutableData *clubList_data;
    NSMutableDictionary *clubList_news;
    NSMutableDictionary *clubList_news_re;
    NSURLConnection *clubList_connection;
    
    NSMutableData *clubChange_data;
    NSMutableDictionary *clubChange_news;
    NSURLConnection *clubChange_connection;
    
    NSMutableData *mainCheck_data;
    NSMutableDictionary *mainCheck_news;
    NSURLConnection *mainCheck_connection;
    
    NSMutableData *mainCheck_data2;
    NSMutableDictionary *mainCheck_news2;
    NSURLConnection *mainCheck_connection2;
    
    
    NSMutableData *pushCheck_data;
    NSMutableDictionary *pushCheck_news;
    NSURLConnection *pushCheck_connection;
    
    NSMutableData *deleteList_data;
    NSMutableDictionary *deleteList_news;
    NSURLConnection *deleteList_connection;
    
    NSMutableData *skin_data;
    NSMutableDictionary *skin_news;
    NSURLConnection *skin_connection;
    
    NSMutableData *mySchoolList_data;
    NSMutableDictionary *mySchoolList_news;
    NSMutableDictionary *mySchoolList_news_re;
    NSURLConnection *mySchoolList_connection;
    
    NSMutableData *schoolAdd_data;
    NSMutableDictionary *schoolAdd_news;
    NSURLConnection *schoolAdd_connection;
    
    NSMutableData *schoolSearch_data;
    NSMutableDictionary *schoolSearch_news;
    NSURLConnection *schoolSearch_connection;
    
    NSMutableData *login_data;
    NSMutableDictionary *login_news;
    NSURLConnection *connection_login;
    
    NSMutableArray *in_schoolChangeArray;

    
    UIAlertView *change_mainSchool_AlertView;
    NSString *change_mainSchool_AlertInt;
    
    BOOL didNewInputPwd;
}

@property (weak, nonatomic) IBOutlet UILabel *tostAlertLabel_new;

@property (weak, nonatomic) IBOutlet UITextView *test_textView;

@property (weak, nonatomic) IBOutlet UIView *push_showView;
@property (weak, nonatomic) IBOutlet UIWebView *push_webView;

@property (weak, nonatomic) IBOutlet UIButton *indicator_bgBtnOutlet;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator_view;
@property (weak, nonatomic) IBOutlet UILabel *fileNumberLabel;

- (IBAction)main_tabBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *main_tabOutlet_1;
@property (weak, nonatomic) IBOutlet UIButton *main_tabOutlet_2;
@property (weak, nonatomic) IBOutlet UIButton *main_tabOutlet_3;
@property (weak, nonatomic) IBOutlet UIButton *main_tabOutlet_4;

@property (weak, nonatomic) IBOutlet UIButton *main_tabBackBtnOutlet;
@property (weak, nonatomic) IBOutlet UIButton *main_tabForwardBtnOutlet;


@property (weak, nonatomic) IBOutlet UIButton *textView_downBtnOutlet;
- (IBAction)textView_downBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *textView_downView;

// 홈
@property (weak, nonatomic) IBOutlet UIView *main_homeView;
@property (weak, nonatomic) IBOutlet UIImageView *home_topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *home_topImageView2;

@property (weak, nonatomic) IBOutlet UIView *home_onView;
@property (weak, nonatomic) IBOutlet UILabel *home_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *home_titleClubLabel;
- (IBAction)home_schoolChangeBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *home_schoolChangeBtnOutlet;

@property (weak, nonatomic) IBOutlet UIWebView *home_webView;

@property (weak, nonatomic) IBOutlet UIView *home_offView;
- (IBAction)home_schoolAddBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *mainClubNoView;
@property (weak, nonatomic) IBOutlet UIButton *mainClubNo_btnOutlet;
- (IBAction)mainClubNoBtn:(id)sender;

// 학교폭력

@property (weak, nonatomic) IBOutlet UILabel *sos_viewTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *login_viewTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *main_sosView;
@property (weak, nonatomic) IBOutlet UIImageView *sos_topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sos_topImageView2;

@property (weak, nonatomic) IBOutlet UIView *sos_sosView;
- (IBAction)sos_signOutBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *sos_signOutLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sos_signOutBgImageView;
@property (weak, nonatomic) IBOutlet UITextField *sos_titleTextField;
- (IBAction)sos_fileAddBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *sos_fileNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *sos_contentsTextView;
- (IBAction)sos_sendBtn:(id)sender;
- (IBAction)sos_reWriteBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *sos_loginView;
@property (weak, nonatomic) IBOutlet UITextField *sos_loginIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *sos_loginPwTextField;
- (IBAction)sos_autoLoginBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *sos_autoLoginCheckImageView;
- (IBAction)sos_loginBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *id_textField_imageView;
@property (weak, nonatomic) IBOutlet UIImageView *pw_textField_imageView;

// 학급정보
@property (weak, nonatomic) IBOutlet UIView *main_schoolSettingView;
@property (weak, nonatomic) IBOutlet UIImageView *setting_topImageView;

- (IBAction)setting_schoolAddBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *setting_tableView;

// 이용안내
@property (weak, nonatomic) IBOutlet UIView *main_guideView;
@property (weak, nonatomic) IBOutlet UIImageView *guide_topImageView;

@property (weak, nonatomic) IBOutlet UIScrollView *guide_scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *guide_pageCtr;

// 학교검색
@property (weak, nonatomic) IBOutlet UIView *main_searchView;
@property (weak, nonatomic) IBOutlet UIImageView *search_topImageView;

@property (weak, nonatomic) IBOutlet UISearchBar *search_searchBar;
- (IBAction)search_searchBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *search_tableView;

- (IBAction)search_backBtn:(id)sender;

// 학반선택
@property (weak, nonatomic) IBOutlet UIView *main_changeView;
@property (weak, nonatomic) IBOutlet UIImageView *change_topImageView;

@property (weak, nonatomic) IBOutlet UITableView *change_tableView;

- (IBAction)change_backBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *change_passClubOutletImageView;
- (IBAction)change_passClubBtn:(id)sender;


// 이벤트
@property (weak, nonatomic) IBOutlet UIView *event_View;
@property (weak, nonatomic) IBOutlet UIWebView *event_webView;
- (IBAction)event_closeView:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *event_closeBtnOutlet;

@property (weak, nonatomic) IBOutlet UIWebView *errorWebView;
@property (weak, nonatomic) IBOutlet UIWebView *errorWebView_xml;

//uuid 저장
@property (strong, nonatomic) NSString *userUUID;

//로그인시 비밀번호 암호화 저장
@property (strong, nonatomic) NSString *sha256Pwd;

@property (strong, nonatomic) NSString *lastLoadedAlrimJangUrl;

//로그인
@property (weak, nonatomic) IBOutlet UITextView *loginViewNoticeTextView;

//학교설정 하단 라벨
@property (weak, nonatomic) IBOutlet UILabel *bottomAddSchoolNoticeLabel;

@end

@implementation ViewController

- (NSString *)createSHA256:(NSString *)source
{
    const char *s = [source cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];

    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}

NSData *hmacForKeyAndData(NSString *key, NSString *data)
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    return [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
}

- (void)webViewForwardBackBtnOutletSetEnabled:(BOOL)boolValue selectBtn:(UIButton *)selectBtnOutlet imageNameStr:(NSString *)imageNameStr
{
    [selectBtnOutlet setEnabled:boolValue];
    [selectBtnOutlet setBackgroundImage:[UIImage imageNamed:imageNameStr] forState:UIControlStateNormal];
}

- (void)webViewResetView {
    [reHome_webView removeFromSuperview];
    reHome_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 75, 320, 443)];
    reHome_webView.delegate = self;
    [_home_onView addSubview:reHome_webView];
}

- (IBAction)homeWebViewBackBtnPress:(id)sender {
//    [self.home_webView goBack];
    [self.sos_loginView setHidden:YES];
    [reHome_webView goBack];
}

- (IBAction)homeWebViewForwardBtnPress:(id)sender {
    //    [self.home_webView goBack];
    [reHome_webView goForward];
}

//- 암호화
//1. 문자열 입력
//2. DES 암호화
//3. 암호화된 문자열을 base64로 인코딩
- (NSString *)encryptTest:(NSString *)str
{
    //NSLog(@"encrypt input string : %@", str);
    //NSLog(@"input length : %d", [str length]);
    NSData *data = [str dataUsingEncoding: NSUTF8StringEncoding];
    //NSLog(@"data : %@", data);
    unsigned char *input = (unsigned char*)[data bytes];
    NSUInteger inLength = [data length];
    NSInteger outLength = ((inLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1));
    unsigned char *output =(unsigned char *)calloc(outLength, sizeof(unsigned char));
    bzero(output, outLength*sizeof(unsigned char));
    size_t additionalNeeded = 0;
    unsigned char *iv = (unsigned char *)calloc(kCCBlockSizeDES, sizeof(unsigned char));
    bzero(iv, kCCBlockSizeDES * sizeof(unsigned char));
    NSString *key = ENCRYPT_KEY;
    const void *vkey = (const void *) [key UTF8String];
    
    CCCryptorStatus err = CCCrypt(kCCEncrypt,
                                  kCCAlgorithmDES,
                                  kCCOptionPKCS7Padding | kCCOptionECBMode,
                                  vkey,
                                  kCCKeySizeDES,
                                  iv,
                                  input,
                                  inLength,
                                  output,
                                  outLength,
                                  &additionalNeeded);
    //NSLog(@"encrypt err: %d", err);
    if(0);
    else if (err == kCCParamError) NSLog(@"PARAM ERROR");
    else if (err == kCCBufferTooSmall) NSLog(@"BUFFER TOO SMALL");
    else if (err == kCCMemoryFailure) NSLog(@"MEMORY FAILURE");
    else if (err == kCCAlignmentError) NSLog(@"ALIGNMENT");
    else if (err == kCCDecodeError) NSLog(@"DECODE ERROR");
    else if (err == kCCUnimplemented) NSLog(@"UNIMPLEMENTED");
    free(iv);
    
    NSString *result;
    //NSData *myData = [NSData dataWithBytesNoCopy:output length:outLength freeWhenDone:YES];
    NSData *myData = [NSData dataWithBytesNoCopy:output length:(NSUInteger)additionalNeeded freeWhenDone:YES];
    //NSLog(@"data : %@", myData);
    //NSLog(@"encrypted string : %s", [myData bytes]);
    //NSLog(@"encrypted length : %d", [myData length]);
    result = [myData base64Encoding];
    
    //NSLog(@"base64encoded : %@", result);
    return result;
}

//- 복호화
//1. 암호화되고 base64로 된 문자열 입력
//2. base64를 UTF8로 암호화만 되어있는 문자열로 디코딩
//3. 복호화
- (NSString *)decryptTest:(NSString *)str
{
    //NSLog(@"decrypt input string : %@", str);
    NSData *decodedData = [NSData dataWithBase64EncodedString:str];
    //NSLog(@"data : %@", decodedData);
    //NSLog(@"base64decoded : %s", [decodedData bytes]);
    unsigned char *input = (unsigned char*)[decodedData bytes];
    NSUInteger inLength = [decodedData length];
    NSInteger outLength = ((inLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1));
    unsigned char *output =(unsigned char *)calloc(outLength, sizeof(unsigned char));
    bzero(output, outLength*sizeof(unsigned char));
    size_t additionalNeeded = 0;
    unsigned char *iv = (unsigned char *)calloc(kCCBlockSizeDES, sizeof(unsigned char));
    bzero(iv, kCCBlockSizeDES * sizeof(unsigned char));
    NSString *key = ENCRYPT_KEY;
    const void *vkey = (const void *) [key UTF8String];
    
    CCCryptorStatus err = CCCrypt(kCCDecrypt,
                                  kCCAlgorithmDES,
                                  kCCOptionPKCS7Padding | kCCOptionECBMode,
                                  vkey,
                                  kCCKeySizeDES,
                                  iv,
                                  input,
                                  inLength,
                                  output,
                                  outLength,
                                  &additionalNeeded);
    //NSLog(@"encrypt err: %d", err);
    
    if(0);
    else if (err == kCCParamError) NSLog(@"PARAM ERROR");
    else if (err == kCCBufferTooSmall) NSLog(@"BUFFER TOO SMALL");
    else if (err == kCCMemoryFailure) NSLog(@"MEMORY FAILURE");
    else if (err == kCCAlignmentError) NSLog(@"ALIGNMENT");
    else if (err == kCCDecodeError) NSLog(@"DECODE ERROR");
    else if (err == kCCUnimplemented) NSLog(@"UNIMPLEMENTED");
    free(iv);
    
    NSString *result;
    //NSData *myData = [NSData dataWithBytes:(const void *)output length:(NSUInteger)additionalNeeded];
    //NSData *myData = [NSData dataWithBytesNoCopy:output length:outLength freeWhenDone:YES];
    NSData *myData = [NSData dataWithBytesNoCopy:output length:(NSUInteger)additionalNeeded freeWhenDone:YES];
    //NSLog(@"data : %@", myData);
    //NSLog(@"decrypted string : %s", [myData bytes]);
    //NSLog(@"decrypted length : %d", [myData length]);
    
    result = [NSString stringWithFormat:@"%.*s",[myData length], [myData bytes]];
    //result = [NSString stringWithUTF8String:[myData bytes]];
    //NSLog(@"output length : %d", [result length]);
    //NSLog(@"result : %@", result);
    
    return result;
}

//#pragma mark StoreParser
//-(void)setStoreVersion:(NSString *)version
//{
//    NSString *storeVersionStr = version;
//    NSString *localVersionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    storeVersionStr = [storeVersionStr stringByReplacingOccurrencesOfString:@"." withString:@""];
//    localVersionStr = [localVersionStr stringByReplacingOccurrencesOfString:@"." withString:@""];
//
//    NSLog(@"storeVersionStr : %@",storeVersionStr);
//    NSLog(@"localVersionStr : %@",localVersionStr);
//
//    //버전 자리수가 다르면 글자길이가 작은애한테 0을 붙여준다.
//    if([storeVersionStr length] != [localVersionStr length])
//    {
//        int gapLength = 0;
//
//        if([storeVersionStr length] < [localVersionStr length])
//        {
//            gapLength = (int)([localVersionStr length] - [storeVersionStr length]);
//
//            for(int j = 0; j < gapLength; j++)
//            {
//                storeVersionStr = [storeVersionStr stringByAppendingString:@"0"];
//            }
//        }
//        else
//        {
//            gapLength = (int)([storeVersionStr length] - [localVersionStr length]);
//
//            for(int j = 0; j < gapLength; j++)
//            {
//                localVersionStr = [localVersionStr stringByAppendingString:@"0"];
//            }
//        }
//    }
//
//    int storeVersion = [storeVersionStr intValue];
//    int localVersion = [localVersionStr intValue];
//
//    //업데이트 필요
//    if(storeVersion > localVersion)
//    {
//        versionAlertView = [[UIAlertView alloc] initWithTitle:@"스쿨나비" message:@"이전 버전을 사용하고 계십니다.\n업데이트 하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
//        [versionAlertView show];
//    }
//}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    // 개시 태그가 "sweets"이면
    if([elementName isEqualToString:@"code"]){
        nowTagStr_code = [NSString stringWithString:elementName];
    }
    else if([elementName isEqualToString:@"startDate"]){
        nowTagStr_startDate = [NSString stringWithString:elementName];
    }
    else if([elementName isEqualToString:@"endDate"]){
        nowTagStr_endDate = [NSString stringWithString:elementName];
    }
    else if([elementName isEqualToString:@"popupContent"]){
        nowTagStr_popupContent = [NSString stringWithString:elementName];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    // 해석중인 태그가 "sweets" 이면
    if ([nowTagStr_code isEqualToString:@"code"]) {
        NSLog(@"xml parser test code : %@",string);
        
        errorXMLcodeStr = string;
    }
    else if([nowTagStr_startDate isEqualToString:@"startDate"]){
        NSLog(@"xml parser test start : %@",string);
        
        errorXMLstartStr = string;
    }
    else if([nowTagStr_endDate isEqualToString:@"endDate"]){
        NSLog(@"xml parser test end : %@",string);
        
        errorXMLendStr = string;
    }
    else if([nowTagStr_popupContent isEqualToString:@"popupContent"]){
        NSLog(@"xml parser test popup : %@",string);
        
        errorXMLdataStr = [errorXMLdataStr stringByAppendingString:string];
    }
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    // 종료태그가 "sweets"이면
    if([elementName isEqualToString:@"code"]){
        nowTagStr_code = nil;
    }
    else if([elementName isEqualToString:@"startDate"]){
        nowTagStr_startDate = nil;
    }
    else if([elementName isEqualToString:@"endDate"]){
        nowTagStr_endDate = nil;
    }
    else if([elementName isEqualToString:@"popupContent"]){
        nowTagStr_popupContent = nil;
        
        NSLog(@"xml parser test popup All data Str : %@",errorXMLdataStr);
    }
    
}
-(void)parserDidEndDocument:(NSXMLParser *)parser {
    
    if ([errorXMLcodeStr isEqualToString:@"000"]) {
        [self.errorWebView_xml setHidden:NO];
        
        [self.errorWebView_xml loadHTMLString:errorXMLdataStr baseURL:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sos_loginPwTextField.delegate = self;
    
    
    // Do any additional setup after loading the view, typically from a nib.
//    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"파일명" ofType:@"html"];
//    NSData *htmlData = [NSData dataWithContentsOfFile:htmlFile];
//    [webView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@""]];
//    [self.view addSubview:webView];
//    
//    NSString *path = @"http://sch.dge.go.kr/upload_data/not_fai.jsp";
//    //URL리퀘스트를 생성하고 웹 뷰에 표시하기
//    NSURL *urlFile = [ NSURL fileURLWithPath : path];
//    NSURLRequest *urlReq = [ NSURLRequest requestWithURL : urlFile ];
//    
//    // webView (아웃렛으로 UIWebView에 연결된 것) 으로 읽어 들임
//    [self.errorWebView loadRequest : urlReq ];
//
//    NSURL *myURL = [[NSURL alloc] initWithString:@"http://sch.dge.go.kr/upload_data/not_fai1.jsp"];
//    NSURLRequest *myURLReq = [NSURLRequest requestWithURL: myURL];
//    [self.errorWebView loadRequest:myURLReq];
    
    
//    NSURL *url = [[NSURL alloc] initWithString:@"http://sites.google.com/site/iphonesdktutorials/xml/Books.xml"];
//    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
//    
//    XMLParser *parser = [[XMLParser alloc] initXMLParser];
//    
//    [xmlParser setDelegate:parser];
//    [xmlParser parse];
    
//    NSString *digest0 = [self createSHA256:@"12345678"];
//    NSLog(@"sha256encoding : \n12345678 : %@", digest0);

    errorXMLcodeStr = @"";
    errorXMLstartStr = @"";
    errorXMLendStr = @"";
    errorXMLdataStr = @"";
    
    NSURL *myURL = [NSURL URLWithString:@"https://sch.dge.go.kr/popup/openapi/mobilePopup.do"];
    NSXMLParser *myParser = [[NSXMLParser alloc] initWithContentsOfURL:myURL];
    myParser.delegate = self;
    // 해석을 개시한다.
    [myParser parse];
    
//    NSString *myHTML = @"<html><body><h1>Hello, world!</h1></body></html>";
//    [self.errorWebView loadHTMLString:myHTML baseURL:nil];
    
//    NSLog(@"test291221 암호화 -- %@",[self encryptTest:@"develop03"]);
//    NSLog(@"test291221 암호화 -- %@",[self decryptTest:@"f346Ngl5vpIX6XAfdZYeLw=="]);
//    NSLog(@"test291221 암호화 -- %@",[self encryptTest:@"12345678"]);
//    NSLog(@"test291221 암호화 -- %@",[self decryptTest:@"YOZgLLWwCAyFcV8dDNkZqA=="]);
//    NSLog(@"test291221 암호화 -- %@",[self encryptTest:@"김효진"]);
//    NSLog(@"test291221 암호화 -- %@",[self encryptTest:@"이재엽 바보"]);
//    NSLog(@"test291221 암호화 -- %@",[self encryptTest:@"테스트입니다요!!!!"]);
    
    aes_key = @"skoinfocokrdhksq";
    
    [self.home_topImageView     setImage:[UIImage imageNamed:@"login_top_bg"]];
    [self.home_topImageView2    setImage:[UIImage imageNamed:@"login_top_bg"]];
    [self.sos_topImageView      setImage:[UIImage imageNamed:@"login_top_bg"]];
    [self.sos_topImageView2     setImage:[UIImage imageNamed:@"login_top_bg"]];
    [self.setting_topImageView  setImage:[UIImage imageNamed:@"login_top_bg"]];
    [self.guide_topImageView    setImage:[UIImage imageNamed:@"login_top_bg"]];
    [self.search_topImageView   setImage:[UIImage imageNamed:@"login_top_bg"]];
    [self.change_topImageView   setImage:[UIImage imageNamed:@"login_top_bg"]];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.viewController = self;
    self.userUUID = [appDelegate getUUID];
    
    CS_detailArray = [[NSMutableArray alloc] init];
    
    isOpen = NO;
    isOpen_subTL = NO;
    selectIndex = nil;
    selectIndex_subTL = nil;
    
    push_login_ingYN = NO;
    tab2btn_selectYN = NO;
    tab2btn_login_selectYN = NO;
    
    webviewLogoutYN = NO;
    
    settingAction_webViewYN = NO;
    autoLoginYN = YES;
    
    self.event_closeBtnOutlet.layer.cornerRadius = 5;
    
    self.mainClubNo_btnOutlet.layer.cornerRadius = 8;
    self.sos_signOutBgImageView.layer.cornerRadius = 10;
    self.sos_signOutBgImageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.sos_signOutBgImageView.layer.borderWidth = 0.5;
    
    self.change_passClubOutletImageView.layer.cornerRadius = 10;
    self.change_passClubOutletImageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.change_passClubOutletImageView.layer.borderWidth = 0.5;
    
    self.tostAlertLabel_new.layer.cornerRadius = 10;
    
    [self.main_homeView setHidden:NO];
    [self.main_sosView setHidden:YES];
    [self.main_schoolSettingView setHidden:YES];
    [self.main_guideView setHidden:YES];
    
    [self.main_searchView setHidden:YES];
    [self.main_changeView setHidden:YES];
 
    [self.guide_scrollView setContentSize:CGSizeMake(self.guide_scrollView.frame.size.width * 9, self.guide_scrollView.frame.size.height)];
    
    for (int i=0 ; i<9; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"useGuide_%d",i+1]];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        imgView.frame = CGRectMake(self.guide_scrollView.frame.size.width*i, 0, self.guide_scrollView.frame.size.width, self.guide_scrollView.frame.size.height);
        
        [self.guide_scrollView addSubview:imgView];
    }
    
    //pageControl에 필요한 옵션을 적용한다.
    self.guide_pageCtr.currentPage =0;               //현재 페이지 index는 0
    //    self.useGuidePageControl.numberOfPages=3;          //페이지 갯수는 3개
    [self.guide_pageCtr addTarget:self action:@selector(pageChangeValue:) forControlEvents:UIControlEventValueChanged]; //페이지 컨트롤 값변경시 이벤트 처리 등록
    
//    NSString *finalURLStr = [NSString stringWithFormat:@"%@/mobile2014/loginAct.jsp?id=%@&passwd=%@&actionType=alim&schoolUrl=%@&clubCd=%@&uuid=%@",schoolUrlStr,useridStr,userpwStr,schoolUrlStr,schoolClubCdStr ,deviceUUID];
//    
//    NSURL *myURL = [[NSURL alloc] initWithString:finalURLStr];
//    NSURLRequest *myURLReq = [NSURLRequest requestWithURL: myURL];
//    [self.home_webView loadRequest:myURLReq];
    
    
    reHome_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 75, 320, 443)];
    reHome_webView.delegate = self;
    [_home_onView addSubview:reHome_webView];
    
    
    NSData *cipherData;
    NSString *base64Text, *plainText;
    
    // encrypt
    plainText  = @"develop03";
    cipherData = [[plainText dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:key];
    base64Text = [cipherData base64EncodedString];
    NSLog(@"test encoding AES1 : %@", base64Text);
    
//    plainText  = @"develop03";
//    cipherData = [[plainText dataUsingEncoding:NSUTF8StringEncoding] AES128Encrypt:key];
//    base64Text = [cipherData base64EncodedString];
//    NSLog(@"test1 encoding AES : %@", base64Text);
//
//    plainText  = @"12345678";
//    cipherData = [[plainText dataUsingEncoding:NSUTF8StringEncoding] AES128Encrypt:key];
//    base64Text = [cipherData base64EncodedString];
//    NSLog(@"test2 encoding AES : %@", base64Text);
    
    // decrypt
//    base64Text = @"qTEyaO8wodj/sAFhzipZdw==";
    base64Text = @"P8UTktAySi53/I62QWeWMg==";
    cipherData = [base64Text base64DecodedData];
    plainText  = [[NSString alloc] initWithData:[cipherData AES256DecryptWithKey:key] encoding:NSUTF8StringEncoding];
    NSLog(@"test encoding AES : %@", plainText);
    
//    base64Text = @"Qr9qTSH4Awow8TaxOnW5JQ==";
//    cipherData = [base64Text base64DecodedData];
//    plainText  = [[NSString alloc] initWithData:[cipherData AES128Decrypt:key] encoding:NSUTF8StringEncoding];
//    NSLog(@"test encoding AES : %@", plainText);
//
//    base64Text = @"pFO25koB22pASF1MUIisRQ==";
//    cipherData = [base64Text base64DecodedData];
//    plainText  = [[NSString alloc] initWithData:[cipherData AES128Decrypt:key] encoding:NSUTF8StringEncoding];
//    NSLog(@"test encoding AES : %@", plainText);
    
//    [self connectToServer_skin];
    [self connectToServer_mySchoolList];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *eventShowDateStr = [defaults objectForKey:@"eventShowDate"];
    
    NSLog(@"eventShowDateStr -- : %@",eventShowDateStr);
    
    if(eventShowDateStr != nil)
    {
        NSDateFormatter *eventShow_dateFormat = [[NSDateFormatter alloc] init];
        [eventShow_dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *eventShowDate = [eventShow_dateFormat dateFromString:eventShowDateStr];
        
        NSDateComponents *eventShow_dateComp = [[NSCalendar currentCalendar]
                                                components :NSCalendarUnitDay //<- minute, hour, day...
                                                fromDate : eventShowDate
                                                toDate : [NSDate date]
                                                options:0];
        
        NSLog(@"event Sday, %ld", (long)[eventShow_dateComp day]);
        
        if (eventShowDateStr) {
            if ([eventShow_dateComp day] != 0) {
                [self connectToServer_event];
            }
        }else {
            [self connectToServer_event];
        }
    }

    
    [self connectToServer_error];
    
//    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//    StoreParser *storeParser = [[StoreParser alloc] init];
//    [storeParser setDelegate:self];
//    [storeParser connect];
//
//    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //로그인화면 하단 텍스트
    NSString *loginNoticeText1 = @"* 회원가입은 pc에서만 가능합니다.";
    NSString *loginNoticeText2 = @"* 학부모의 경우 앱 하단 「학교설정」메뉴에 자녀의 학교정보를 추가하여 이용할 수 있습니다.\n(다자녀인 경우 한 개의 ID로 이용 가능)";
    
    NSString *completText = [NSString stringWithFormat:@"%@\n\n%@",loginNoticeText1, loginNoticeText2];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:completText];
    
    NSDictionary *attrs = @{NSForegroundColorAttributeName : [UIColor redColor]};
    NSDictionary *attrs2 = @{NSForegroundColorAttributeName : [UIColor darkGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:12.f]};
    
    [attString addAttributes:attrs2 range:NSMakeRange(0, [completText length])];
    [attString addAttributes:attrs range:NSMakeRange(8, 8)];
    
    _loginViewNoticeTextView.attributedText = attString;
    
    //학교설정 하단 텍스트 설정
    NSString *bottomAddSchoolNoticeText = @"「좌우 밀기」를 통해 등록된 학교 삭제 가능";
    NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc] initWithString:bottomAddSchoolNoticeText];
    
    [attString2 addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11.f]}
                       range:NSMakeRange(0, [bottomAddSchoolNoticeText length])];
    [attString2 addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}
                        range:NSMakeRange(0, 7)];
    
    _bottomAddSchoolNoticeLabel.attributedText = attString2;
}

//페이지 컨트롤 값이 변경될때, 스크롤뷰 위치 설정
- (void) pageChangeValue:(id)sender {
    UIPageControl *pControl = (UIPageControl *) sender;
    [self.guide_scrollView setContentOffset:CGPointMake(pControl.currentPage*320, 0) animated:YES];
}

//스크롤이 변경될때 page의 currentPage 설정
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.guide_scrollView) {
        CGFloat pageWidth = self.guide_scrollView.frame.size.width;
        self.guide_pageCtr.currentPage = floor((self.guide_scrollView.contentOffset.x - pageWidth / 3) / pageWidth) + 1;
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////
// connecttoServer

- (void)connectToServer_alramSetting:(NSString *)domainStr bbsData:(NSString *)bbsStr valData:(NSString *)valStr infoIdData:(NSString *)infoIdStr groupData:(NSString *)groupStr
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self.indicator_view startAnimating];
    
    [self.indicator_view setHidden:NO];
    [self.indicator_bgBtnOutlet setHidden:NO];
//    http://118.219.7.120/push/setBbsPush.jsp?
//    uuid=9D0CCB82-AC59-4046-98FD-7FB7FA6D8DE3&
//    domain=DOM_0000180&
//    bbs=b_report&
//    val=N
//    http://118.219.7.120/push/setBbsPush2.jsp?
//    uuid=ffffffff-90a4-6b92-1f81-e59e0033c587&
//    bbs=g_classAlbm&
//    val=N&
//    infoid=CFCD_00000000000045202
    
    NSString *url;
//    NSString *url = @"http://118.219.7.120/push/setBbsPush.jsp";

    if ([groupStr isEqualToString:@"S"]) {
        url = @"http://118.219.7.120/push/setBbsPush.jsp";
    }else {
        url = @"http://118.219.7.120/push/setBbsPush2.jsp";
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    NSString *deviceUUID = self.userUUID;
    
    NSString *post = [NSString stringWithFormat:@"uuid=%@&domain=%@&bbs=%@&val=%@&infoid=%@",deviceUUID,domainStr,bbsStr,valStr,infoIdStr];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSLog(@"test8000000 alram -- %@",post);
    alramSetting_connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connectToServer_error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self.indicator_view startAnimating];
    
    [self.indicator_view setHidden:NO];
    [self.indicator_bgBtnOutlet setHidden:NO];
    
//    NSString *url = @"https://sch.dge.go.kr/popup/openapi/mobilePopup.do";
    NSString *url = @"http://sch.dge.go.kr/upload_data/not_fai.jsp";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    NSString *post = [NSString stringWithFormat:@""];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSLog(@"test80000001 -- %@",request.HTTPBody);
    error_connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connectToServer_event
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self.indicator_view startAnimating];
    
    [self.indicator_view setHidden:NO];
    [self.indicator_bgBtnOutlet setHidden:NO];
    
    NSString *url = @"http://sch.dge.go.kr/upload_data/mobile_event.json";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    NSString *post = [NSString stringWithFormat:@""];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSLog(@"test80000002 -- %@",request.HTTPBody);
    event_connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connectToServer_clubChange:(NSString *)idxStr sidData:(NSString *)sidStr infoData:(NSString *)infoStr
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //    [self.search_indicator startAnimating];
    //
    //    [self.search_indicator setHidden:NO];
    //    [self.search_indicatorBG setHidden:NO];
    
    [self.indicator_view startAnimating];
    
    [self.indicator_view setHidden:NO];
    [self.indicator_bgBtnOutlet setHidden:NO];
    
    NSLog(@"test99949994922222222233344 -- %@,,%@,,%@",idxStr,sidStr,infoStr);
    
    NSString *url = @"http://118.219.7.120/push/modSchool.jsp";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    NSString *deviceUUID = self.userUUID;
    
    NSString *post = [NSString stringWithFormat:@"uuid=%@&idx=%@&sid=%@&info_id=%@",deviceUUID,idxStr,sidStr,infoStr];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSLog(@"test80000003 -- %@",request.HTTPBody);
    clubChange_connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connectToServer_clubList:(NSString *)domStr
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //    [self.search_indicator startAnimating];
    //
    //    [self.search_indicator setHidden:NO];
    //    [self.search_indicatorBG setHidden:NO];
    
    [self.indicator_view startAnimating];
    
    [self.indicator_view setHidden:NO];
    [self.indicator_bgBtnOutlet setHidden:NO];
    
    NSLog(@"test999499949222222222333 -- %@",domStr);
    
    NSString *url = @"http://118.219.7.120/push/getClass.jsp";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    NSString *deviceUUID = self.userUUID;
    
    NSString *post = [NSString stringWithFormat:@"d=%@",domStr];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSLog(@"test80000004 -- %@",request.HTTPBody);
    clubList_connection = [NSURLConnection connectionWithRequest:request delegate:self];
}


- (void)connectToServer_mainCheck:(NSString *)idxStr
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //    [self.search_indicator startAnimating];
    //
    //    [self.search_indicator setHidden:NO];
    //    [self.search_indicatorBG setHidden:NO];
    
    [self.indicator_view startAnimating];
    
    [self.indicator_view setHidden:NO];
    [self.indicator_bgBtnOutlet setHidden:NO];
    
    NSLog(@"test999499949222222222333 -- %@",idxStr);
    
    NSString *url = @"http://118.219.7.120/push/setMain2.jsp";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    NSString *deviceUUID = self.userUUID;
    
    NSString *post = [NSString stringWithFormat:@"uuid=%@&idx=%@",deviceUUID,idxStr];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSLog(@"test80000005 -- %@",request.HTTPBody);
    mainCheck_connection2 = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connectToServer_mainCheck2:(NSString *)idxStr
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //    [self.search_indicator startAnimating];
    //
    //    [self.search_indicator setHidden:NO];
    //    [self.search_indicatorBG setHidden:NO];
    
    [self.indicator_view startAnimating];
    
    [self.indicator_view setHidden:NO];
    [self.indicator_bgBtnOutlet setHidden:NO];
    
    NSLog(@"test999499949222222222333 -- %@",idxStr);
    
    NSString *url = @"http://118.219.7.120/push/setMain3.jsp";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    NSString *deviceUUID = self.userUUID;
    
    NSString *post = [NSString stringWithFormat:@"uuid=%@&idx=%@",deviceUUID,idxStr];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSLog(@"test80000006 -- %@",post);
    mainCheck_connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connectToServer_mainCheck3:(NSString *)idxStr
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //    [self.search_indicator startAnimating];
    //
    //    [self.search_indicator setHidden:NO];
    //    [self.search_indicatorBG setHidden:NO];
    
    [self.indicator_view startAnimating];
    
    [self.indicator_view setHidden:NO];
    [self.indicator_bgBtnOutlet setHidden:NO];
    
    NSLog(@"test999499949222222222333 -- %@",idxStr);
    
    NSString *url = @"http://118.219.7.120/push/setMain2.jsp";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    NSString *deviceUUID = self.userUUID;
    
    NSString *post = [NSString stringWithFormat:@"uuid=%@&idx=%@",deviceUUID,idxStr];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSLog(@"test8000000 main check -- %@",post);
    NSURLConnection *mainCheck = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connectToServer_mainCheck3_1:(NSString *)idxStr
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //    [self.search_indicator startAnimating];
    //
    //    [self.search_indicator setHidden:NO];
    //    [self.search_indicatorBG setHidden:NO];
    
    [self.indicator_view startAnimating];
    
    [self.indicator_view setHidden:NO];
    [self.indicator_bgBtnOutlet setHidden:NO];
    
    NSLog(@"test999499949222222222333 -- %@",idxStr);
    
    NSString *url = @"http://118.219.7.120/push/setMain2.jsp";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    NSString *deviceUUID = self.userUUID;
    
    NSString *post = [NSString stringWithFormat:@"uuid=%@&idx=%@",deviceUUID,idxStr];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSLog(@"test8000000 main check -- %@",post);
    mainCheck_connection3_1 = [NSURLConnection connectionWithRequest:request delegate:self];
}


- (void)connectToServer_mainCheck4:(NSString *)idxStr
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //    [self.search_indicator startAnimating];
    //
    //    [self.search_indicator setHidden:NO];
    //    [self.search_indicatorBG setHidden:NO];
    
    [self.indicator_view startAnimating];
    
    [self.indicator_view setHidden:NO];
    [self.indicator_bgBtnOutlet setHidden:NO];
    
    NSLog(@"test999499949222222222333 -- %@",idxStr);
    
    NSString *url = @"http://118.219.7.120/push/setMain3.jsp";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    NSString *deviceUUID = self.userUUID;
    
    NSString *post = [NSString stringWithFormat:@"uuid=%@&idx=%@",deviceUUID,idxStr];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSLog(@"test8000000 main check -- %@",post);
    NSURLConnection *mainCheck = [NSURLConnection connectionWithRequest:request delegate:self];
}


- (void)connectToServer_pushCheck:(NSString *)pushCheckStr idxData:(NSString *)idxStr
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //    [self.search_indicator startAnimating];
    //
    //    [self.search_indicator setHidden:NO];
    //    [self.search_indicatorBG setHidden:NO];
    
    [self.indicator_view startAnimating];
    
    [self.indicator_view setHidden:NO];
    [self.indicator_bgBtnOutlet setHidden:NO];
    
    NSLog(@"test999499949222222222 -- %@",pushCheckStr);
    
    NSString *url = @"http://118.219.7.120/push/setPush.jsp";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    NSString *deviceUUID = self.userUUID;
    
    NSString *post = [NSString stringWithFormat:@"uuid=%@&idx=%@&push=%@",deviceUUID,idxStr,pushCheckStr];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSLog(@"test80000007 -- %@",request.HTTPBody);
    NSLog(@"test8000000 222022 -- %@",post);
    
    pushCheck_connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connectToServer_deleteList:(NSString *)idxStr
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //    [self.search_indicator startAnimating];
    //
    //    [self.search_indicator setHidden:NO];
    //    [self.search_indicatorBG setHidden:NO];
    
    [self.indicator_view startAnimating];
    
    [self.indicator_view setHidden:NO];
    [self.indicator_bgBtnOutlet setHidden:NO];
    
    NSLog(@"test999499949 -- %@",idxStr);
    
    NSString *url = @"http://118.219.7.120/push/delSchool.jsp";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    NSString *deviceUUID = self.userUUID;
    
    NSString *post = [NSString stringWithFormat:@"uuid=%@&idx=%@",deviceUUID,idxStr];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    NSLog(@"test80000008 -- %@",request.HTTPBody);
    deleteList_connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connectToServer_skin
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //    [self.search_indicator startAnimating];
    //
    //    [self.search_indicator setHidden:NO];
    //    [self.search_indicatorBG setHidden:NO];
    
    [self.indicator_view startAnimating];
    
    [self.indicator_view setHidden:NO];
    [self.indicator_bgBtnOutlet setHidden:NO];
    
    NSString *url = @"http://118.219.7.120/push/siteConfig.jsp";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    NSString *post = [NSString stringWithFormat:@""];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    NSLog(@"test80000009 -- %@",request.HTTPBody);
    skin_connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connectToServer_mySchoolList
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //    [self.search_indicator startAnimating];
    //
    //    [self.search_indicator setHidden:NO];
    //    [self.search_indicatorBG setHidden:NO];
    
    [self.indicator_view startAnimating];
    
    [self.indicator_view setHidden:NO];
    [self.indicator_bgBtnOutlet setHidden:NO];
    
    NSString *url = @"http://118.219.7.120/push/mySchool.jsp";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    NSString *deviceUUID = self.userUUID;
    
    NSString *post = [NSString stringWithFormat:@"uuid=%@",deviceUUID];
//    NSString *post = [NSString stringWithFormat:@"uuid=23213123123"];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSLog(@"test800000010 -- %@",post);
    mySchoolList_connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connectToServer_schoolAdd:(NSString *)domainStr sidData:(NSString *)sidStr infoData:(NSString *)infoStr
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //    [self.search_indicator startAnimating];
    //
    //    [self.search_indicator setHidden:NO];
    //    [self.search_indicatorBG setHidden:NO];
    
    [self.indicator_view startAnimating];
    
    [self.indicator_view setHidden:NO];
    [self.indicator_bgBtnOutlet setHidden:NO];
    
    NSString *url = @"http://118.219.7.120/push/setSchool.jsp";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *deviceUUID = self.userUUID;

    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    NSString *post = [NSString stringWithFormat:@"uuid=%@&domain=%@&sid=%@&info_id=%@",deviceUUID, domainStr, sidStr, infoStr];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSLog(@"test800000011 -- %@",post);
    schoolAdd_connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connectToServer_schoolSearch
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //    [self.search_indicator startAnimating];
    //
    //    [self.search_indicator setHidden:NO];
    //    [self.search_indicatorBG setHidden:NO];
    
    [self.indicator_view startAnimating];
    
    [self.indicator_view setHidden:NO];
    [self.indicator_bgBtnOutlet setHidden:NO];
    
    NSString *url = @"http://118.219.7.120/push/getSchool.jsp";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
//    NSString* teststrUrl = [self.search_searchBar.text stringByAddingPercentEscapesUsingEncoding:-2147481280];
//    NSLog(@"test22220202222 -- %@",teststrUrl);
//    NSString* teststrUrl = [self.search_searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"test22220202222 -- %@",teststrUrl);
    NSString* teststrUrl = self.search_searchBar.text;
                            
    NSString *post = [NSString stringWithFormat:@"nm=%@",teststrUrl];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    
    ///////////////////////////    ///////////////////////////    ///////////////////////////    ///////////////////////////
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSLog(@"test800000012 -- %@",request.HTTPBody);
    NSLog(@"test8000000 search school -- %@",teststrUrl);
    schoolSearch_connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
}

- (void)connectToServer_login:(NSString *)idStr pwDataStr:(NSString *)pwStr
{
    
    [self.indicator_view startAnimating];
    [self.indicator_view setHidden:NO];
    [self.indicator_bgBtnOutlet setHidden:NO];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
//    NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
//    NSString *url = @"http://talktalk.wanju.go.kr/index.wanju";
//    NSString *url = @"http://118.219.7.120/user/openapi/login.do";
    NSString *url = [NSString stringWithFormat:@"%@/user/openapi/login.do",changeMainHomeURLStr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //    NSString *post = [NSString stringWithFormat:@"contentsSid=199&id=%@&pwd=%@&uuid=%@",idStr,pwStr,deviceUUID];
    //    NSString *post = [NSString stringWithFormat:@"restMode=json&id=%@&password=%@&domainId=%@",idStr,pwStr,changeDomStr];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *domIDstr;
    if (push_login_ingYN) {
        domIDstr = push_loginDomainIDstr;
    }else {
        domIDstr = [defaults objectForKey:@"sq_mainDOMID"];
    }
//    NSString *domIDstr = [defaults objectForKey:@"sq_mainDOMID"];
    //    NSString *domIDstr = @"DOM_0000118";
    
    //pwd replace("|", "+")
//    pwStr = [pwStr stringByReplacingOccurrencesOfString:@"|" withString:@"+"];
    
    NSString                        *encTypeStr = @"n";
    if(kUseLoginEncrypt != 0)        encTypeStr = @"y";
    
    NSString *post = [NSString stringWithFormat:@"restMode=json&id=%@&password=%@&domainId=%@&encType=%@",idStr,pwStr,domIDstr,encTypeStr];
    NSLog(@"test222202220222 로그인 URL -- %@?%@",url,post);

    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];

    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    connection_login = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connectToServer_logout
{
    [self.indicator_view startAnimating];
    
    [self.indicator_view setHidden:NO];
    [self.indicator_bgBtnOutlet setHidden:NO];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
//    NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    //    NSString *url = @"http://talktalk.wanju.go.kr/index.wanju";
    NSString *url = @"http://118.219.7.120/user/openapi/logout.do";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //    NSString *post = [NSString stringWithFormat:@"contentsSid=199&id=%@&pwd=%@&uuid=%@",idStr,pwStr,deviceUUID];
    //    NSString *post = [NSString stringWithFormat:@"restMode=json&id=%@&password=%@&domainId=%@",idStr,pwStr,changeDomStr];
    
    NSString *post = [NSString stringWithFormat:@"restMode=json&ssoKey=%@",ssoKey];
    NSLog(@"test222202220222 -- %@",post);
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    logoutConnection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connectToServer_logout_alert
{
    //    [self.webView_indicatorView startAnimating];
    //
    //    [self.webView_indicatorView setHidden:NO];
    //    [self.webView_indicatorView setHidden:NO];
    
    [self.indicator_view startAnimating];
    
    [self.indicator_view setHidden:NO];
    [self.indicator_bgBtnOutlet setHidden:NO];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
//    NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    //    NSString *url = @"http://talktalk.wanju.go.kr/index.wanju";
    NSString *url = @"http://118.219.7.120/user/openapi/logout.do";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //    NSString *post = [NSString stringWithFormat:@"contentsSid=199&id=%@&pwd=%@&uuid=%@",idStr,pwStr,deviceUUID];
    //    NSString *post = [NSString stringWithFormat:@"restMode=json&id=%@&password=%@&domainId=%@",idStr,pwStr,changeDomStr];
    
    NSString *post = [NSString stringWithFormat:@"restMode=json&ssoKey=%@",ssoKey];
    NSLog(@"test222202220222 -- %@",post);
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    logoutAlert_Connection = [NSURLConnection connectionWithRequest:request delegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
//    [self.indicator_view startAnimating];
//
//    [self.indicator_view setHidden:NO];
//    [self.indicator_bgBtnOutlet setHidden:NO];

    
    if (connection == schoolSearch_connection) {
        schoolSearch_data = [[NSMutableData alloc] init];
    }else if (connection == connection_login) {
        login_data = [[NSMutableData alloc] init];
    }else if (connection == schoolAdd_connection) {
        schoolAdd_data = [[NSMutableData alloc] init];
    }else if (connection == mySchoolList_connection) {
        mySchoolList_data = [[NSMutableData alloc] init];
    }else if (connection == skin_connection) {
        skin_data = [[NSMutableData alloc] init];
    }else if (connection == deleteList_connection) {
        deleteList_data = [[NSMutableData alloc] init];
    }else if (connection == pushCheck_connection) {
        pushCheck_data = [[NSMutableData alloc] init];
    }else if (connection == mainCheck_connection) {
        mainCheck_data = [[NSMutableData alloc] init];
    }else if (connection == clubList_connection) {
        clubList_data = [[NSMutableData alloc] init];
    }else if (connection == clubChange_connection) {
        clubChange_data = [[NSMutableData alloc] init];
    }else if (connection == sendConnection) {
        sendData = [[NSMutableData alloc] init];
    }else if (connection == videoConnection) {
        videoData = [[NSMutableData alloc] init];
    }else if (connection == getConnection) {
        getData = [[NSMutableData alloc] init];
    }else if (connection == logoutConnection) {
        logoutData = [[NSMutableData alloc] init];
    }else if (connection == logoutAlert_Connection) {
        logoutAlert_Data = [[NSMutableData alloc] init];
    }else if (connection == event_connection) {
        event_data = [[NSMutableData alloc] init];
    }else if (connection == error_connection) {
        error_data = [[NSMutableData alloc] init];
        
        if ([response respondsToSelector:@selector(statusCode)])
        {
            int statusCode = [((NSHTTPURLResponse *)response) statusCode];
            NSLog(@"test http connection error code : %d",statusCode);
            if (statusCode == 200)
            {
                
                NSURL *myURL = [[NSURL alloc] initWithString:@"http://sch.dge.go.kr/upload_data/not_fai.jsp"];
                NSURLRequest *myURLReq = [NSURLRequest requestWithURL: myURL];
                [self.errorWebView loadRequest:myURLReq];

                [self.errorWebView setHidden:NO];
                
                  // stop connecting; no more delegate messages
                NSLog(@"didReceiveResponse statusCode with %i", statusCode);
            }else {
                [self.errorWebView setHidden:YES];
            }
            
            [connection cancel];
        }
        
    }else if (connection == alramSetting_connection) {
        alramSetting_data = [[NSMutableData alloc] init];
    }

    else if (connection == fileDownload_connection) {
        NSLog(@"test00233333 -- %@",response.suggestedFilename);
        NSLog(@"test00233333 -- %@",[response.suggestedFilename stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        
        fileDownload_nameStr = [NSString stringWithFormat:@"%@",[response.suggestedFilename stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
//    else if (connection == schoolJoin_connection) {
//        schoolJoin_data = [[NSMutableData alloc] init];
//    }
    //    data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    if (connection == schoolSearch_connection) {
        [schoolSearch_data appendData:theData];
    }else if (connection == connection_login) {
        [login_data appendData:theData];
    }else if (connection == schoolAdd_connection) {
        [schoolAdd_data appendData:theData];
    }else if (connection == mySchoolList_connection) {
        [mySchoolList_data appendData:theData];
    }else if (connection == skin_connection) {
        [skin_data appendData:theData];
    }else if (connection == deleteList_connection) {
        [deleteList_data appendData:theData];
    }else if (connection == pushCheck_connection) {
        [pushCheck_data appendData:theData];
    }else if (connection == mainCheck_connection) {
        [mainCheck_data appendData:theData];
    }else if (connection == clubList_connection) {
        [clubList_data appendData:theData];
    }else if (connection == clubChange_connection) {
        [clubChange_data appendData:theData];
    }else if ([connection isEqual:sendConnection]) {
        [sendData appendData:theData];
    }else if ([connection isEqual:videoConnection]) {
        [videoData appendData:theData];
    }else if ([connection isEqual:getConnection]) {
        [getData appendData:theData];
    }else if ([connection isEqual:logoutConnection]) {
        [logoutData appendData:theData];
    }else if ([connection isEqual:logoutAlert_Connection]) {
        [logoutAlert_Data appendData:theData];
    }else if (connection == event_connection) {
        [event_data appendData:theData];
    }else if (connection == error_connection) {
        [error_data appendData:theData];
    }else if (connection == alramSetting_connection) {
        [alramSetting_data appendData:theData];
    }
//    else if (connection == schoolJoin_connection) {
//        [schoolJoin_data appendData:theData];
//    }
    //    [data appendData:theData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    [self.search_indicator stopAnimating];
//    
//    [self.search_indicator setHidden:YES];
//    [self.search_indicatorBG setHidden:YES];
    
    [self.indicator_view stopAnimating];
    
    [self.indicator_view setHidden:YES];
    [self.indicator_bgBtnOutlet setHidden:YES];
    
    if (connection == fileDownload_connection) {
//        NSLog(@"test00233333 -- %@",response.suggestedFilename);
        
        [self fileDown_inWebView:fileDownload_nameStr webviewURL:fileDownload_request];
    }
    else if (connection == schoolSearch_connection) {
        
        schoolSearch_news = [NSJSONSerialization JSONObjectWithData:schoolSearch_data options:kNilOptions error:nil];
        
//        NSString *myString = [[NSString alloc] initWithData:schoolSearch_data encoding:NSUTF8StringEncoding];
        
        NSLog(@"test200111 학교정보 -- %@",schoolSearch_news);
//        NSLog(@"test200222 -- %@\n\n",[schoolSearch_news objectForKey:@"schoolName"]);
        
        [self.search_tableView reloadData];
    
    }else if (connection == mainCheck_connection3_1) {
    
        NSString *homeWebView_URLstr = [NSString stringWithFormat:@"http://%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:mainCheck3_1_intVal] objectForKey:@"DOMAIN"]];
        NSString *homeSchool_Titlestr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:mainCheck3_1_intVal] objectForKey:@"DOMAIN_NM"]];
        NSString *homeClub_Titlestr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:mainCheck3_1_intVal] objectForKey:@"CLASSNM"]];
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *guestDomainStr = [NSString stringWithFormat:@"%@||",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:mainCheck3_1_intVal] objectForKey:@"DOMAIN_ID"]];
        guestArrayStr = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"guestAddStr"]];
        NSRange strRange_searchDomain = [guestArrayStr rangeOfString:guestDomainStr];
        if (strRange_searchDomain.location != NSNotFound){
            //                                homeClub_Titlestr = @"일반사용자";
            homeClub_Titlestr = @"";
        }else {
            homeClub_Titlestr = [[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:mainCheck3_1_intVal] objectForKey:@"CLASSNM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        
        changeMainHomeURLStr = homeWebView_URLstr;
        changeIdxStr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:mainCheck3_1_intVal] objectForKey:@"IDX"]];
        changeDomStr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:mainCheck3_1_intVal] objectForKey:@"DOMAIN_ID"]];
        
        
        NSLog(@"teset9129321399  -- dom :  %@",homeWebView_URLstr);
        NSLog(@"teset9129321399  -- dom :  %@",changeDomStr);
        
        [self.home_titleLabel setText:homeSchool_Titlestr];
        [self.home_titleClubLabel setText:homeClub_Titlestr];
        
        
        NSLog(@"teset9129321399  -- ssokey :  %@",ssoKey);
        
        
        NSString *homeWebView_URLstr_push;
        if (!ssoKey || [ssoKey isEqualToString:@""]) {
            homeWebView_URLstr = [NSString stringWithFormat:@"%@/user/mobile/index.do?loginPos=app&v=1.0",homeWebView_URLstr];
            homeWebView_URLstr_push = [NSString stringWithFormat:@"%@/user/mobile/index.do?v=1.0",homeWebView_URLstr];
            //                                [self.home_titleClubLabel setHidden:YES];
        }else {
            NSLog(@"teset9129321399  -- 돔 비교 :  \n%@\n%@",changeDomStr,settingAction_webView_domainIDstr);
            
            if (settingAction_webViewYN) {
            if (![changeDomStr isEqualToString:settingAction_webView_domainIDstr]) {
                NSString *url = @"http://118.219.7.120/user/openapi/logout.do";
                
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                
                //    NSString *post = [NSString stringWithFormat:@"contentsSid=199&id=%@&pwd=%@&uuid=%@",idStr,pwStr,deviceUUID];
                //    NSString *post = [NSString stringWithFormat:@"restMode=json&id=%@&password=%@&domainId=%@",idStr,pwStr,changeDomStr];
                
                NSString *post = [NSString stringWithFormat:@"restMode=json&ssoKey=%@",ssoKey];
                NSLog(@"test222202220222 -- %@",post);
                
                NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
                NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
                
                [request setURL:[NSURL URLWithString:url]];
                [request setHTTPMethod:@"POST"];
                [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
                [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
                [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:postData];
                
                [NSURLConnection connectionWithRequest:request delegate:self];
                
                //                                    if (![setting_domainId isEqualToString:settingAction_webView_domainIDstr]) {
                //                                        UIAlertView *error_alertView = [[UIAlertView alloc] initWithTitle:@"알림"
                //                                                                                                  message:@"다른 학교로 접속하여 로그아웃 됩니다."
                //                                                                                                 delegate:self
                //                                                                                        cancelButtonTitle:@"확인"
                //                                                                                        otherButtonTitles:nil , nil];
                //                                        [error_alertView show];
                //                                    }
                
                ssoKey = @"";
                
                homeWebView_URLstr = [NSString stringWithFormat:@"%@/user/mobile/index.do?loginPos=app&v=1.0",homeWebView_URLstr];
                homeWebView_URLstr_push = [NSString stringWithFormat:@"%@/user/mobile/index.do?v=1.0",homeWebView_URLstr];
                
            }else {
                homeWebView_URLstr = [NSString stringWithFormat:@"%@/user/mobile/index.do?loginPos=app&ssoKey=%@&v=1.0",homeWebView_URLstr,ssoKey];
                homeWebView_URLstr_push = [NSString stringWithFormat:@"%@/user/mobile/index.do?ssoKey=%@&v=1.0",homeWebView_URLstr,ssoKey];
                //                                [self.home_titleClubLabel setHidden:NO];
            }
            }else {
                homeWebView_URLstr = [NSString stringWithFormat:@"%@/user/mobile/index.do?loginPos=app&ssoKey=%@&v=1.0",homeWebView_URLstr,ssoKey];
                homeWebView_URLstr_push = [NSString stringWithFormat:@"%@/user/mobile/index.do?ssoKey=%@&v=1.0",homeWebView_URLstr,ssoKey];
                //                                [self.home_titleClubLabel setHidden:NO];
            }
        }
        
        // 임시 home URL
        //                            if (!ssoKey) {
        //                                homeWebView_URLstr = [NSString stringWithFormat:@"http://118.219.7.120/user/mobile/index.do?loginPos=app"];
        //                            }else {
        //                                homeWebView_URLstr = [NSString stringWithFormat:@"http://118.219.7.120/user/mobile/index.do?loginPos=app&ssoKey=%@",ssoKey];
        //                            }
        
        NSString *deviceUUID = self.userUUID;
        
        if (!self.push_showView.hidden) {
            NSLog(@"test push URL : %@",homeWebView_URLstr_push);
            homeWebView_URLstr_push = [homeWebView_URLstr_push stringByReplacingOccurrencesOfString:@"loginPos=app&" withString:@""];
            
            homeWebView_URLstr_push = [NSString stringWithFormat:@"%@&uuid=%@",homeWebView_URLstr_push,deviceUUID];
            
            NSURL *myURL = [[NSURL alloc] initWithString:homeWebView_URLstr_push];
            NSURLRequest *myURLReq = [NSURLRequest requestWithURL: myURL];
            [self.push_webView loadRequest:myURLReq];
        }else {
            
            homeWebView_URLstr = [NSString stringWithFormat:@"%@&uuid=%@",homeWebView_URLstr,deviceUUID];
            
            NSURL *myURL = [[NSURL alloc] initWithString:homeWebView_URLstr];
            NSURLRequest *myURLReq = [NSURLRequest requestWithURL: myURL];
//            [self.home_webView loadRequest:myURLReq];
            [self webViewResetView];
            [reHome_webView loadRequest:myURLReq];
        }
        
        [defaults setObject:changeDomStr forKey:@"sq_mainDOMID"];
        [defaults synchronize];
        
        [self.home_schoolChangeBtnOutlet setHidden:NO];
        [self.mainClubNoView setHidden:YES];
//        mainWebYN = YES;
        
        [self.login_viewTitleLabel setText:[NSString stringWithFormat:@"%@ 로그인 정보를 입력해 주세요.",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:mainCheck3_1_intVal] objectForKey:@"DOMAIN_NM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [self.sos_viewTitleLabel setText:[NSString stringWithFormat:@"%@ 신고내용을 입력해 주세요.",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:mainCheck3_1_intVal] objectForKey:@"DOMAIN_NM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
    }else if (connection == mainCheck_connection2) {
    
        settingAction_webViewYN = YES;
        
        settingAction_webView_domainIDstr = [[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:settingView_selectIndexPath.section] objectForKey:@"DOMAIN_ID"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        changeMainHomeURLStr = [NSString stringWithFormat:@"http://%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:settingView_selectIndexPath.section] objectForKey:@"DOMAIN"]];
        
        if ([ssoKey isEqualToString:@""] || !ssoKey) {
            
        }else {
            
            if (![setting_domainId isEqualToString:settingAction_webView_domainIDstr]) {
                
            //                [self connectToServer_logout];
            NSString *url = @"http://118.219.7.120/user/openapi/logout.do";
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            
            //    NSString *post = [NSString stringWithFormat:@"contentsSid=199&id=%@&pwd=%@&uuid=%@",idStr,pwStr,deviceUUID];
            //    NSString *post = [NSString stringWithFormat:@"restMode=json&id=%@&password=%@&domainId=%@",idStr,pwStr,changeDomStr];
            
            NSString *post = [NSString stringWithFormat:@"restMode=json&ssoKey=%@",ssoKey];
            NSLog(@"test222202220222 -- %@",post);
            
            NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
            
            [request setURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"Mozilla/4.0 (compatible;)" forHTTPHeaderField:@"User-Agent"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            [NSURLConnection connectionWithRequest:request delegate:self];
            
            if (![setting_domainId isEqualToString:settingAction_webView_domainIDstr]) {
                UIAlertView *error_alertView = [[UIAlertView alloc] initWithTitle:@"알림"
                                                                          message:@"다른 학교로 접속하여 로그아웃 됩니다."
                                                                         delegate:self
                                                                cancelButtonTitle:@"확인"
                                                                otherButtonTitles:nil , nil];
                [error_alertView show];
            }
            
            ssoKey = @"";
            }
        }
        
        
        NSString *skinStr = [[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:settingView_selectIndexPath.section] objectForKey:@"SKIN"];
        NSLog(@"test 스킨 정보 값 = %@",skinStr);
        //        skinStr = @"3";
        
        if ([skinStr isEqualToString:@"spring"]) {
            [self.home_topImageView     setImage:[UIImage imageNamed:@"top_bg01"]];
            [self.home_topImageView2    setImage:[UIImage imageNamed:@"top_bg01"]];
            [self.sos_topImageView      setImage:[UIImage imageNamed:@"top_bg01"]];
            [self.sos_topImageView2     setImage:[UIImage imageNamed:@"top_bg01"]];
            [self.setting_topImageView  setImage:[UIImage imageNamed:@"top_bg01"]];
            [self.guide_topImageView    setImage:[UIImage imageNamed:@"top_bg01"]];
            [self.search_topImageView   setImage:[UIImage imageNamed:@"top_bg01"]];
            [self.change_topImageView   setImage:[UIImage imageNamed:@"top_bg01"]];
        }else if ([skinStr isEqualToString:@"summer"]) {
            [self.home_topImageView     setImage:[UIImage imageNamed:@"top_bg02"]];
            [self.home_topImageView2    setImage:[UIImage imageNamed:@"top_bg02"]];
            [self.sos_topImageView      setImage:[UIImage imageNamed:@"top_bg02"]];
            [self.sos_topImageView2     setImage:[UIImage imageNamed:@"top_bg02"]];
            [self.setting_topImageView  setImage:[UIImage imageNamed:@"top_bg02"]];
            [self.guide_topImageView    setImage:[UIImage imageNamed:@"top_bg02"]];
            [self.search_topImageView   setImage:[UIImage imageNamed:@"top_bg02"]];
            [self.change_topImageView   setImage:[UIImage imageNamed:@"top_bg02"]];
        }else if ([skinStr isEqualToString:@"fall"]) {
            [self.home_topImageView     setImage:[UIImage imageNamed:@"top_bg03"]];
            [self.home_topImageView2    setImage:[UIImage imageNamed:@"top_bg03"]];
            [self.sos_topImageView      setImage:[UIImage imageNamed:@"top_bg03"]];
            [self.sos_topImageView2     setImage:[UIImage imageNamed:@"top_bg03"]];
            [self.setting_topImageView  setImage:[UIImage imageNamed:@"top_bg03"]];
            [self.guide_topImageView    setImage:[UIImage imageNamed:@"top_bg03"]];
            [self.search_topImageView   setImage:[UIImage imageNamed:@"top_bg03"]];
            [self.change_topImageView   setImage:[UIImage imageNamed:@"top_bg03"]];
        }else if ([skinStr isEqualToString:@"winter"]) {
            [self.home_topImageView     setImage:[UIImage imageNamed:@"top_bg04"]];
            [self.home_topImageView2    setImage:[UIImage imageNamed:@"top_bg04"]];
            [self.sos_topImageView      setImage:[UIImage imageNamed:@"top_bg04"]];
            [self.sos_topImageView2     setImage:[UIImage imageNamed:@"top_bg04"]];
            [self.setting_topImageView  setImage:[UIImage imageNamed:@"top_bg04"]];
            [self.guide_topImageView    setImage:[UIImage imageNamed:@"top_bg04"]];
            [self.search_topImageView   setImage:[UIImage imageNamed:@"top_bg04"]];
            [self.change_topImageView   setImage:[UIImage imageNamed:@"top_bg04"]];
        }else {
            [self.home_topImageView     setImage:[UIImage imageNamed:@"login_top_bg"]];
            [self.home_topImageView2    setImage:[UIImage imageNamed:@"login_top_bg"]];
            [self.sos_topImageView      setImage:[UIImage imageNamed:@"login_top_bg"]];
            [self.sos_topImageView2     setImage:[UIImage imageNamed:@"login_top_bg"]];
            [self.setting_topImageView  setImage:[UIImage imageNamed:@"login_top_bg"]];
            [self.guide_topImageView    setImage:[UIImage imageNamed:@"login_top_bg"]];
            [self.search_topImageView   setImage:[UIImage imageNamed:@"login_top_bg"]];
            [self.change_topImageView   setImage:[UIImage imageNamed:@"login_top_bg"]];
        }
        
        
        [self.main_homeView setHidden:NO];
        [self.main_sosView setHidden:YES];
        [self.main_schoolSettingView setHidden:YES];
        [self.main_guideView setHidden:YES];
        
        [self.main_searchView setHidden:YES];
        [self.main_changeView setHidden:YES];
        
        
//        [self webViewForwardBackBtnOutletSetEnabled:YES selectBtn:self.main_tabBackBtnOutlet imageNameStr:@"bt_menuBack_on"];
//        [self webViewForwardBackBtnOutletSetEnabled:YES selectBtn:self.main_tabForwardBtnOutlet imageNameStr:@"bt_menuForward_on"];
        
        [self.main_tabOutlet_1 setBackgroundImage:[UIImage imageNamed:@"bt_menu01_on"] forState:UIControlStateNormal];
        [self.main_tabOutlet_2 setBackgroundImage:[UIImage imageNamed:@"bt_menu02"] forState:UIControlStateNormal];
        [self.main_tabOutlet_3 setBackgroundImage:[UIImage imageNamed:@"bt_menu03"] forState:UIControlStateNormal];
        [self.main_tabOutlet_4 setBackgroundImage:[UIImage imageNamed:@"bt_menu04"] forState:UIControlStateNormal];
        
        NSLog(@"test 도메인 주소가 뭐냐 ? %@",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:settingView_selectIndexPath.section] objectForKey:@"DOMAIN"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        
        now_WebViewURLStr = [NSString stringWithFormat:@"%@",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:settingView_selectIndexPath.section] objectForKey:@"DOMAIN"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *homeWebView_URLstr;
        if (!ssoKey || [ssoKey isEqualToString:@""]) {
            homeWebView_URLstr = [NSString stringWithFormat:@"http://%@/user/mobile/index.do?loginPos=app&v=1.0",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:settingView_selectIndexPath.section] objectForKey:@"DOMAIN"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }else {
            homeWebView_URLstr = [NSString stringWithFormat:@"http://%@/user/mobile/index.do?loginPos=app&ssoKey=%@&v=1.0",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:settingView_selectIndexPath.section] objectForKey:@"DOMAIN"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],ssoKey];
        }
        //        NSString *homeWebView_URLstr = [NSString stringWithFormat:@"http://%@/user/mobile/index.do?loginPos=app",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:indexPath.row] objectForKey:@"DOMAIN"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSString *homeSchool_Titlestr = [NSString stringWithFormat:@"%@",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:settingView_selectIndexPath.section] objectForKey:@"DOMAIN_NM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSString *homeClub_Titlestr = [NSString stringWithFormat:@"%@",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:settingView_selectIndexPath.section] objectForKey:@"CLASSNM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        changeIdxStr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:settingView_selectIndexPath.section] objectForKey:@"IDX"]];
        changeDomStr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:settingView_selectIndexPath.section] objectForKey:@"DOMAIN_ID"]];
        
        NSLog(@"teset9129321399  -- dom :  %@",changeDomStr);
        
        [self.home_titleLabel setText:homeSchool_Titlestr];
        [self.home_titleClubLabel setText:homeClub_Titlestr];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:settingAction_webView_domainIDstr forKey:@"sq_mainDOMID"];
        [defaults synchronize];
        
        //        // 임시 home URL
        //        homeWebView_URLstr = @"http://118.219.7.120/user/mobile/index.do";
        
        [self.login_viewTitleLabel setText:[NSString stringWithFormat:@"%@ 로그인 정보를 입력해 주세요.",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:settingView_selectIndexPath.section] objectForKey:@"DOMAIN_NM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [self.sos_viewTitleLabel setText:[NSString stringWithFormat:@"%@ 신고내용을 입력해 주세요.",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:settingView_selectIndexPath.section] objectForKey:@"DOMAIN_NM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        NSString *deviceUUID = self.userUUID;
        
        
        homeWebView_URLstr = [NSString stringWithFormat:@"%@&uuid=%@",homeWebView_URLstr,deviceUUID];
        
        NSURL *myURL = [[NSURL alloc] initWithString:homeWebView_URLstr];
        NSURLRequest *myURLReq = [NSURLRequest requestWithURL: myURL];
//        [self.home_webView loadRequest:myURLReq];
        [self webViewResetView];
        [reHome_webView loadRequest:myURLReq];
        
        [self.home_schoolChangeBtnOutlet setHidden:NO];
        [self.mainClubNoView setHidden:YES];
        
    }else if (connection == connection_login) {
        
        login_news = [NSJSONSerialization JSONObjectWithData:login_data options:kNilOptions error:nil];
      
//        NSLog(@"test001 -- login : %@", [login_news objectForKey:@"rst"]);
//        NSString *test_TextStr = [[login_news objectForKey:@"loginInfo"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSString *test_TextStr = [[login_news objectForKey:@"loginInfo"] stringbyreplacingp stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"test001 -- login : %@", login_news);
        
        NSLog(@"로그인결과 exception : %@",[login_news objectForKey:@"exception"]);
        NSLog(@"로그인결과 msg : %@",[login_news objectForKey:@"msg"]);
        
        //로그인 실패시..........
        if([[login_news objectForKey:@"msg"] isEqualToString:@"OK"] == NO)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림"
                                                                message:[login_news objectForKey:@"msg"]
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        NSLog(@"test001 -- login domainNm   : %@", [[[login_news objectForKey:@"loginInfo"] objectForKey:@"domainNm"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        NSLog(@"test001 -- login gradeNm    : %@", [[[login_news objectForKey:@"loginInfo"] objectForKey:@"gradeNm"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        NSLog(@"test001 -- login infoNm     : %@", [[[login_news objectForKey:@"loginInfo"] objectForKey:@"infoNm"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        NSLog(@"test001 -- login roleNm     : %@", [[[login_news objectForKey:@"loginInfo"] objectForKey:@"roleNm"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        NSLog(@"test001 -- login userTyNm   : %@", [[[login_news objectForKey:@"loginInfo"] objectForKey:@"userTyNm"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        
        setting_domainId = [[[login_news objectForKey:@"loginInfo"] objectForKey:@"domainId"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        [self.test_textView setText:[NSString stringWithFormat:@"%@",[[login_news objectForKey:@"loginInfo"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//        [self.test_textView setText:@"ddd"];
        
        if ([[login_news objectForKey:@"msg"] isEqualToString:@"OK"]) {
            
//            menuCd = [[NSString alloc] initWithFormat:@"%@",[[login_news objectForKey:@"loginInfo"] objectForKey:@"menuCd"]];
//            boardId = [[NSString alloc] initWithFormat:@"%@",[[login_news objectForKey:@"loginInfo"] objectForKey:@"boardId"]];
            ssoKey = [NSString stringWithFormat:@"%@",[[login_news objectForKey:@"loginInfo"] objectForKey:@"ssoKey"]];
            domainId = [NSString stringWithFormat:@"%@",[[login_news objectForKey:@"loginInfo"] objectForKey:@"domainId"]];
            

//            domainId = @"DOM_0000466";
//            menuCd = @"MCD_000000000000005349";
//            menuCd = @"MCD_000000000000072776";
//            boardId = @"BBS_0000001";
            
//            domainId = @"DOM_0000118";
//            menuCd = @"MCD_000000000000005401";
//            boardId = @"BBS_0000002";
            
            
            NSLog(@"test12501051050 0 -- test_나머지 = %@,,%@",boardId,menuCd);
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            [defaults setObject:aes_idStr forKey:@"aes_idStr"];
//            [defaults setObject:aes_pwStr forKey:@"aes_pwStr"];
            
            if (autoLoginYN)
            {
                [defaults setObject:@"Y" forKey:@"autoLoginYN"];
                [defaults setObject:self.sos_loginIdTextField.text forKey:@"auto_idStr"];
//                [defaults setObject:self.sos_loginPwTextField.text forKey:@"auto_pwStr"];
                NSInteger pwdLength = [self.sos_loginPwTextField.text length];
                [defaults setObject:[NSNumber numberWithInteger:pwdLength] forKey:@"pwdLength"];
                
                
                if(kUseLoginEncrypt == 0)
                {
                    [defaults setObject:self.sos_loginPwTextField.text forKey:@"auto_pwStr"];
                }
                else
                {
                    [defaults setObject:self.sha256Pwd forKey:@"auto_pwStr"];
                    
                }
                
            }
            else
            {
                [defaults setObject:@"N" forKey:@"autoLoginYN"];
            }
            
            [defaults synchronize];
            
            [self.sos_loginIdTextField setText:nil];
            [self.sos_loginPwTextField setText:nil];
            [self.sos_loginView setHidden:YES];
            
            if (!tab2btn_selectYN) {
//                if ([changeMainHomeURLStr isEqualToString:main_WebViewURLStr] || push_login_ingYN) {
                
                [loginSuccessAlertView dismissWithClickedButtonIndex:0 animated:YES];
                
                [self showPressed_tostAlertLabel:@"정상적으로 로그인 되었습니다."];
                
            }else {
                tab2btn_selectYN = NO;
            }
            
            if (push_login_ingYN) {
                [self.push_showView setHidden:NO];
                [self.sos_loginView setHidden:YES];
                
                NSLog(@"test push url 111111 :  %@",push_login_urlStr);
                
//                push_login_urlStr = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@&ssoKey=%@",push_login_urlStr,ssoKey]];
                NSString *add_ssoKeyStr = [NSString stringWithFormat:@"%@",push_login_urlStr];
                
                add_ssoKeyStr = [add_ssoKeyStr stringByReplacingOccurrencesOfString:@"ssoKey=" withString:[NSString stringWithFormat:@"ssoKey=%@",ssoKey]];
                
                push_login_urlStr = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",add_ssoKeyStr]];
                
                NSLog(@"test push url 222222 :  %@",push_login_urlStr);
                
                NSURLRequest *myURLReq = [NSURLRequest requestWithURL: push_login_urlStr];
                [self.push_webView loadRequest:myURLReq];
            }else {

                if (!tab2btn_login_selectYN) {
                    [self connectToServer_mySchoolList];
                }
//                [self connectToServer_mySchoolList];
            }
            
        }else {
            if (!tab2btn_selectYN) {
//                if ([changeMainHomeURLStr isEqualToString:main_WebViewURLStr] || push_login_ingYN) {
                    UIAlertView *loginErrorAlertView = [[UIAlertView alloc] initWithTitle:@"로그인 실패"
                                                                                  message:[login_news objectForKey:@"msg"]
                                                                                 delegate:self
                                                                        cancelButtonTitle:@"확인"
                                                                        otherButtonTitles:nil, nil];
                    [loginErrorAlertView show];
//                }
            }else {
                tab2btn_selectYN = NO;
            }
            
            [self.sos_loginView setHidden:NO];
        }

    }else if (connection == schoolAdd_connection) {
        schoolAdd_news = [NSJSONSerialization JSONObjectWithData:schoolAdd_data options:kNilOptions error:nil];
        
        NSLog(@"test001 -- login : %@", [schoolAdd_news objectForKey:@"rst"]);
        
//        if (noValue_mySchool_YN) {
//         
//            [self connectToServer_mainCheck2:noValue_mySchool_idxStr];
//            noValue_mySchool_YN = NO;
//                
//        }
        
        if ([[schoolAdd_news objectForKey:@"rst"] isEqualToString:@"Y"]) {
            UIAlertView *schoolAddView = [[UIAlertView alloc] initWithTitle:@"학교등록"
                                                                message:@"정상적으로 등록되었습니다."
                                                               delegate:self
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil , nil];
            [schoolAddView show];
            
            [self.main_homeView setHidden:YES];
            [self.main_sosView setHidden:YES];
            [self.main_schoolSettingView setHidden:NO];
            [self.main_guideView setHidden:YES];
            
            [self.main_searchView setHidden:YES];
            [self.main_changeView setHidden:YES];
            
            [self.main_tabOutlet_1 setBackgroundImage:[UIImage imageNamed:@"bt_menu01"] forState:UIControlStateNormal];
            [self.main_tabOutlet_2 setBackgroundImage:[UIImage imageNamed:@"bt_menu02"] forState:UIControlStateNormal];
            [self.main_tabOutlet_3 setBackgroundImage:[UIImage imageNamed:@"bt_menu03_on"] forState:UIControlStateNormal];
            [self.main_tabOutlet_4 setBackgroundImage:[UIImage imageNamed:@"bt_menu04"] forState:UIControlStateNormal];
            
            [self connectToServer_mySchoolList];
        }else {
            UIAlertView *schoolAddView = [[UIAlertView alloc] initWithTitle:@"학교등록"
                                                                    message:[schoolAdd_news objectForKey:@"msg"]
                                                                   delegate:self
                                                          cancelButtonTitle:@"확인"
                                                          otherButtonTitles:nil , nil];
            [schoolAddView show];
        }
        
        [self.main_searchView setHidden:YES];
        [self.main_changeView setHidden:YES];
        
    }else if (connection == mySchoolList_connection) {
        mySchoolList_news = [NSJSONSerialization JSONObjectWithData:mySchoolList_data options:kNilOptions error:nil];
        
        mySchoolList_news_re = nil;
        mySchoolList_news_re = [NSMutableDictionary dictionaryWithObjectsAndKeys:mySchoolList_news,@"dicData", nil];
        
        NSLog(@"test001 -- mySchoolList : %@", mySchoolList_news);
        
        if (CSchangeYN) {
            CS_detailArray = [[NSMutableArray alloc] init];
            
            NSArray * bbsArray = [[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:CS_indexPath.section] objectForKey:@"BBS"];

            for (int i = 0; i < [bbsArray count]; i++) {
                if (CS_YorN) {
                    if ([[[bbsArray objectAtIndex:i] objectForKey:@"GROUP"] isEqualToString:@"C"]) {
                        [CS_detailArray addObject:[bbsArray objectAtIndex:i]];
                    }
                }else {
                    if ([[[bbsArray objectAtIndex:i] objectForKey:@"GROUP"] isEqualToString:@"S"]) {
                        [CS_detailArray addObject:[bbsArray objectAtIndex:i]];
                    }
                }
            }
            
            CSchangeYN = NO;
//            NSLog(@"test clubAlertShowBtnPress reerererererere %@",CS_detailArray);
        }
        
        
        
        if ([mySchoolList_news count] > 0) {
            
            if (noValue_mySchool_YN) {
                noValue_mySchool_idxStr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:0] objectForKey:@"IDX"]];
                [self connectToServer_mainCheck2:noValue_mySchool_idxStr];
                noValue_mySchool_YN = NO;
            }
            
            
            [self.home_offView setHidden:YES];
            [self.home_onView setHidden:NO];
            
            // 학교 웹뷰 호출
            [self.setting_tableView reloadData];
            
            if (!settingAction_webViewYN) {
                for (int i = 0; i < [mySchoolList_news count]; i++) {
                    if ([[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"MAIN2"] isEqualToString:@"Y"]) {
                        
                        
                        NSString *skinStr = [[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"SKIN"];
                        NSLog(@"test 스킨 정보 값 = %@",skinStr);
                        //        skinStr = @"3";
                        
                        if ([skinStr isEqualToString:@"spring"]) {
                            [self.home_topImageView     setImage:[UIImage imageNamed:@"top_bg01"]];
                            [self.home_topImageView2    setImage:[UIImage imageNamed:@"top_bg01"]];
                            [self.sos_topImageView      setImage:[UIImage imageNamed:@"top_bg01"]];
                            [self.sos_topImageView2     setImage:[UIImage imageNamed:@"top_bg01"]];
                            [self.setting_topImageView  setImage:[UIImage imageNamed:@"top_bg01"]];
                            [self.guide_topImageView    setImage:[UIImage imageNamed:@"top_bg01"]];
                            [self.search_topImageView   setImage:[UIImage imageNamed:@"top_bg01"]];
                            [self.change_topImageView   setImage:[UIImage imageNamed:@"top_bg01"]];
                        }else if ([skinStr isEqualToString:@"summer"]) {
                            [self.home_topImageView     setImage:[UIImage imageNamed:@"top_bg02"]];
                            [self.home_topImageView2    setImage:[UIImage imageNamed:@"top_bg02"]];
                            [self.sos_topImageView      setImage:[UIImage imageNamed:@"top_bg02"]];
                            [self.sos_topImageView2     setImage:[UIImage imageNamed:@"top_bg02"]];
                            [self.setting_topImageView  setImage:[UIImage imageNamed:@"top_bg02"]];
                            [self.guide_topImageView    setImage:[UIImage imageNamed:@"top_bg02"]];
                            [self.search_topImageView   setImage:[UIImage imageNamed:@"top_bg02"]];
                            [self.change_topImageView   setImage:[UIImage imageNamed:@"top_bg02"]];
                        }else if ([skinStr isEqualToString:@"fall"]) {
                            [self.home_topImageView     setImage:[UIImage imageNamed:@"top_bg03"]];
                            [self.home_topImageView2    setImage:[UIImage imageNamed:@"top_bg03"]];
                            [self.sos_topImageView      setImage:[UIImage imageNamed:@"top_bg03"]];
                            [self.sos_topImageView2     setImage:[UIImage imageNamed:@"top_bg03"]];
                            [self.setting_topImageView  setImage:[UIImage imageNamed:@"top_bg03"]];
                            [self.guide_topImageView    setImage:[UIImage imageNamed:@"top_bg03"]];
                            [self.search_topImageView   setImage:[UIImage imageNamed:@"top_bg03"]];
                            [self.change_topImageView   setImage:[UIImage imageNamed:@"top_bg03"]];
                        }else if ([skinStr isEqualToString:@"winter"]) {
                            [self.home_topImageView     setImage:[UIImage imageNamed:@"top_bg04"]];
                            [self.home_topImageView2    setImage:[UIImage imageNamed:@"top_bg04"]];
                            [self.sos_topImageView      setImage:[UIImage imageNamed:@"top_bg04"]];
                            [self.sos_topImageView2     setImage:[UIImage imageNamed:@"top_bg04"]];
                            [self.setting_topImageView  setImage:[UIImage imageNamed:@"top_bg04"]];
                            [self.guide_topImageView    setImage:[UIImage imageNamed:@"top_bg04"]];
                            [self.search_topImageView   setImage:[UIImage imageNamed:@"top_bg04"]];
                            [self.change_topImageView   setImage:[UIImage imageNamed:@"top_bg04"]];
                        }else {
                            [self.home_topImageView     setImage:[UIImage imageNamed:@"login_top_bg"]];
                            [self.home_topImageView2    setImage:[UIImage imageNamed:@"login_top_bg"]];
                            [self.sos_topImageView      setImage:[UIImage imageNamed:@"login_top_bg"]];
                            [self.sos_topImageView2     setImage:[UIImage imageNamed:@"login_top_bg"]];
                            [self.setting_topImageView  setImage:[UIImage imageNamed:@"login_top_bg"]];
                            [self.guide_topImageView    setImage:[UIImage imageNamed:@"login_top_bg"]];
                            [self.search_topImageView   setImage:[UIImage imageNamed:@"login_top_bg"]];
                            [self.change_topImageView   setImage:[UIImage imageNamed:@"login_top_bg"]];
                        }
                    }
                }
            }else {
                for (int i = 0; i < [mySchoolList_news count]; i++) {
                    if ([[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"MAIN"] isEqualToString:@"Y"]) {
                        
                        
                        NSString *skinStr = [[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"SKIN"];
                        NSLog(@"test 스킨 정보 값 = %@",skinStr);
                        //        skinStr = @"3";
                        
                        if ([skinStr isEqualToString:@"spring"]) {
                            [self.home_topImageView     setImage:[UIImage imageNamed:@"top_bg01"]];
                            [self.home_topImageView2    setImage:[UIImage imageNamed:@"top_bg01"]];
                            [self.sos_topImageView      setImage:[UIImage imageNamed:@"top_bg01"]];
                            [self.sos_topImageView2     setImage:[UIImage imageNamed:@"top_bg01"]];
                            [self.setting_topImageView  setImage:[UIImage imageNamed:@"top_bg01"]];
                            [self.guide_topImageView    setImage:[UIImage imageNamed:@"top_bg01"]];
                            [self.search_topImageView   setImage:[UIImage imageNamed:@"top_bg01"]];
                            [self.change_topImageView   setImage:[UIImage imageNamed:@"top_bg01"]];
                        }else if ([skinStr isEqualToString:@"summer"]) {
                            [self.home_topImageView     setImage:[UIImage imageNamed:@"top_bg02"]];
                            [self.home_topImageView2    setImage:[UIImage imageNamed:@"top_bg02"]];
                            [self.sos_topImageView      setImage:[UIImage imageNamed:@"top_bg02"]];
                            [self.sos_topImageView2     setImage:[UIImage imageNamed:@"top_bg02"]];
                            [self.setting_topImageView  setImage:[UIImage imageNamed:@"top_bg02"]];
                            [self.guide_topImageView    setImage:[UIImage imageNamed:@"top_bg02"]];
                            [self.search_topImageView   setImage:[UIImage imageNamed:@"top_bg02"]];
                            [self.change_topImageView   setImage:[UIImage imageNamed:@"top_bg02"]];
                        }else if ([skinStr isEqualToString:@"fall"]) {
                            [self.home_topImageView     setImage:[UIImage imageNamed:@"top_bg03"]];
                            [self.home_topImageView2    setImage:[UIImage imageNamed:@"top_bg03"]];
                            [self.sos_topImageView      setImage:[UIImage imageNamed:@"top_bg03"]];
                            [self.sos_topImageView2     setImage:[UIImage imageNamed:@"top_bg03"]];
                            [self.setting_topImageView  setImage:[UIImage imageNamed:@"top_bg03"]];
                            [self.guide_topImageView    setImage:[UIImage imageNamed:@"top_bg03"]];
                            [self.search_topImageView   setImage:[UIImage imageNamed:@"top_bg03"]];
                            [self.change_topImageView   setImage:[UIImage imageNamed:@"top_bg03"]];
                        }else if ([skinStr isEqualToString:@"winter"]) {
                            [self.home_topImageView     setImage:[UIImage imageNamed:@"top_bg04"]];
                            [self.home_topImageView2    setImage:[UIImage imageNamed:@"top_bg04"]];
                            [self.sos_topImageView      setImage:[UIImage imageNamed:@"top_bg04"]];
                            [self.sos_topImageView2     setImage:[UIImage imageNamed:@"top_bg04"]];
                            [self.setting_topImageView  setImage:[UIImage imageNamed:@"top_bg04"]];
                            [self.guide_topImageView    setImage:[UIImage imageNamed:@"top_bg04"]];
                            [self.search_topImageView   setImage:[UIImage imageNamed:@"top_bg04"]];
                            [self.change_topImageView   setImage:[UIImage imageNamed:@"top_bg04"]];
                        }else {
                            [self.home_topImageView     setImage:[UIImage imageNamed:@"login_top_bg"]];
                            [self.home_topImageView2    setImage:[UIImage imageNamed:@"login_top_bg"]];
                            [self.sos_topImageView      setImage:[UIImage imageNamed:@"login_top_bg"]];
                            [self.sos_topImageView2     setImage:[UIImage imageNamed:@"login_top_bg"]];
                            [self.setting_topImageView  setImage:[UIImage imageNamed:@"login_top_bg"]];
                            [self.guide_topImageView    setImage:[UIImage imageNamed:@"login_top_bg"]];
                            [self.search_topImageView   setImage:[UIImage imageNamed:@"login_top_bg"]];
                            [self.change_topImageView   setImage:[UIImage imageNamed:@"login_top_bg"]];
                        }
                    }
                }

            }
            
            if (self.main_homeView.hidden) {
                NSLog(@"메인 숨김 (1탭이 아닌곳)");
                
                for (int i = 0; i < [mySchoolList_news count]; i++) {
                    if ([[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"MAIN2"] isEqualToString:@"Y"]) {
                        
                        main_WebViewURLStr = [[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN"];
                        
                        NSString *homeWebView_URLstr = [NSString stringWithFormat:@"http://%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN"]];
                        NSString *homeSchool_Titlestr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN_NM"]];
                        NSString *homeClub_Titlestr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"CLASSNM"]];
                        
                        
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        NSString *guestDomainStr = [NSString stringWithFormat:@"%@||",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN_ID"]];
                        guestArrayStr = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"guestAddStr"]];
                        NSRange strRange_searchDomain = [guestArrayStr rangeOfString:guestDomainStr];
                        if (strRange_searchDomain.location != NSNotFound){
//                            homeClub_Titlestr = @"일반사용자";
                            homeClub_Titlestr = @"";
                        }else {
                            homeClub_Titlestr = [[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"CLASSNM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        }
                        
                        
                        changeMainHomeURLStr = homeWebView_URLstr;
                        changeIdxStr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"IDX"]];
                        changeDomStr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN_ID"]];
                        
                        
                        NSLog(@"teset9129321399  -- dom :  %@",homeWebView_URLstr);
                        NSLog(@"teset9129321399  -- dom :  %@",changeDomStr);
                        
                        [self.home_titleLabel setText:homeSchool_Titlestr];
                        [self.home_titleClubLabel setText:homeClub_Titlestr];
                        
                        
                        NSLog(@"teset9129321399  -- ssokey :  %@",ssoKey);
                        NSLog(@"teset9129321399  -- 학교이름 ?? :  %@",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN_NM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                        
                        NSString *homeWebView_URLstr_push;
                        if (!ssoKey || [ssoKey isEqualToString:@""]) {
                            homeWebView_URLstr = [NSString stringWithFormat:@"%@/user/mobile/index.do?loginPos=app&v=1.0",homeWebView_URLstr];
                            homeWebView_URLstr_push = [NSString stringWithFormat:@"%@/user/mobile/index.do?v=1.0",homeWebView_URLstr];
                        }else {
                            homeWebView_URLstr = [NSString stringWithFormat:@"%@/user/mobile/index.do?loginPos=app&ssoKey=%@&v=1.0",homeWebView_URLstr,ssoKey];
                            homeWebView_URLstr_push = [NSString stringWithFormat:@"%@/user/mobile/index.do?ssoKey=%@&v=1.0",homeWebView_URLstr,ssoKey];
                        }
                        
                        // 임시 home URL
                        //                            if (!ssoKey) {
                        //                                homeWebView_URLstr = [NSString stringWithFormat:@"http://118.219.7.120/user/mobile/index.do?loginPos=app"];
                        //                            }else {
                        //                                homeWebView_URLstr = [NSString stringWithFormat:@"http://118.219.7.120/user/mobile/index.do?loginPos=app&ssoKey=%@",ssoKey];
                        //                            }
                        
                        if (!self.push_showView.hidden) {
                            NSLog(@"test push URL : %@",homeWebView_URLstr_push);
                            homeWebView_URLstr_push = [homeWebView_URLstr_push stringByReplacingOccurrencesOfString:@"loginPos=app&" withString:@""];
                            NSURL *myURL = [[NSURL alloc] initWithString:homeWebView_URLstr_push];
                            NSURLRequest *myURLReq = [NSURLRequest requestWithURL: myURL];
                            [self.push_webView loadRequest:myURLReq];
                        }else {
//                            NSURL *myURL = [[NSURL alloc] initWithString:homeWebView_URLstr];
//                            NSURLRequest *myURLReq = [NSURLRequest requestWithURL: myURL];
//                            [self.home_webView loadRequest:myURLReq];
                        }
                        
                        [defaults setObject:changeDomStr forKey:@"sq_mainDOMID"];
                        [defaults synchronize];
                        
                        [self.home_schoolChangeBtnOutlet setHidden:NO];
                        [self.mainClubNoView setHidden:YES];
                        
                        if (!ssoKey || [ssoKey isEqualToString:@""]) {
                            [self.login_viewTitleLabel setText:[NSString stringWithFormat:@"%@ 로그인 정보를 입력해 주세요.",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN_NM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                            [self.sos_viewTitleLabel setText:[NSString stringWithFormat:@"%@ 신고내용을 입력해 주세요.",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN_NM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                        }else{
                            [self.login_viewTitleLabel setText:[NSString stringWithFormat:@"%@ 로그인 정보를 입력해 주세요.",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN_NM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                            [self.sos_viewTitleLabel setText:[NSString stringWithFormat:@"%@ 신고내용을 입력해 주세요.",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN_NM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                        }
                        
                    }
                }
            }else {
                NSLog(@"메인 보임 (1탭 일때)");
                
                if (!settingAction_webViewYN) {
                
                    BOOL mainWebYN = NO;
                    
                    for (int i = 0; i < [mySchoolList_news count]; i++) {
                        if ([[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"MAIN2"] isEqualToString:@"Y"]) {
                            
                            NSLog(@"test maincheck3_1 int : %d", i);
                            
                            mainCheck3_1_intVal = i;
                            
                            NSString *idxStr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"IDX"]];
                            [self connectToServer_mainCheck3_1:idxStr];
                            
                            mainWebYN = YES;
                        }
                    }
                    
                    if (!mainWebYN) {
                        
                        [self.home_titleLabel setText:@"학교명"];
                        [self.home_titleClubLabel setText:@"학반"];
                        
                        [self.home_schoolChangeBtnOutlet setHidden:YES];
                        [self.mainClubNoView setHidden:NO];
                    }
                } else {
                    NSLog(@"메인 보임 (1탭 인데 웹뷰)");
                    
                    for (int i = 0; i < [mySchoolList_news count]; i++) {
                        if ([[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN_ID"] isEqualToString:settingAction_webView_domainIDstr]) {
                            
                            
//                            NSString *idxStr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"IDX"]];
//                            [self connectToServer_mainCheck3:idxStr];
                            
                                    
                            NSString *homeWebView_URLstr = [NSString stringWithFormat:@"http://%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN"]];
                            NSString *homeSchool_Titlestr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN_NM"]];
                            NSString *homeClub_Titlestr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"CLASSNM"]];
                            
                            changeIdxStr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"IDX"]];
                            changeDomStr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN_ID"]];
                            
                            NSLog(@"teset9129321399  -- dom :  %@",changeDomStr);
                            
                            [self.home_titleLabel setText:homeSchool_Titlestr];
                            [self.home_titleClubLabel setText:homeClub_Titlestr];
                            
                            
                            NSString *homeWebView_URLstr_push;
                            if (!ssoKey || [ssoKey isEqualToString:@""]) {
                                homeWebView_URLstr = [NSString stringWithFormat:@"%@/user/mobile/index.do?loginPos=app&v=1.0",homeWebView_URLstr];
                                homeWebView_URLstr_push = [NSString stringWithFormat:@"%@/user/mobile/index.do?v=1.0",homeWebView_URLstr];
                                //                                [self.home_titleClubLabel setHidden:YES];
                            }else {
                                homeWebView_URLstr = [NSString stringWithFormat:@"%@/user/mobile/index.do?loginPos=app&ssoKey=%@&v=1.0",homeWebView_URLstr,ssoKey];
                                homeWebView_URLstr_push = [NSString stringWithFormat:@"%@/user/mobile/index.do?ssoKey=%@&v=1.0",homeWebView_URLstr,ssoKey];
                                //                                [self.home_titleClubLabel setHidden:NO];
                            }
                            
                            // 임시 home URL
                            //                            if (!ssoKey) {
                            //                                homeWebView_URLstr = [NSString stringWithFormat:@"http://118.219.7.120/user/mobile/index.do?loginPos=app"];
                            //                            }else {
                            //                                homeWebView_URLstr = [NSString stringWithFormat:@"http://118.219.7.120/user/mobile/index.do?loginPos=app&ssoKey=%@",ssoKey];
                            //                            }
                            
                            NSString *deviceUUID = self.userUUID;
                            
                            if (!self.push_showView.hidden) {
                                NSLog(@"test push URL : %@",homeWebView_URLstr_push);
                                homeWebView_URLstr_push = [homeWebView_URLstr_push stringByReplacingOccurrencesOfString:@"loginPos=app&" withString:@""];
                                
                                homeWebView_URLstr_push = [NSString stringWithFormat:@"%@&uuid=%@",homeWebView_URLstr_push,deviceUUID];
                                
                                NSURL *myURL = [[NSURL alloc] initWithString:homeWebView_URLstr_push];
                                NSURLRequest *myURLReq = [NSURLRequest requestWithURL: myURL];
                                [self.push_webView loadRequest:myURLReq];
                            }else {
                                
                                homeWebView_URLstr = [NSString stringWithFormat:@"%@&uuid=%@",homeWebView_URLstr,deviceUUID];
                                
                                NSURL *myURL = [[NSURL alloc] initWithString:homeWebView_URLstr];
                                NSURLRequest *myURLReq = [NSURLRequest requestWithURL: myURL];
                                NSLog(@"test 메인 화면 URL 목록 부른 후 : %@",myURLReq);
//                                [self.home_webView loadRequest:myURLReq];
                                [self webViewResetView];
                                [reHome_webView loadRequest:myURLReq];
                            }
                            
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            [defaults setObject:changeDomStr forKey:@"sq_mainDOMID"];
                            [defaults synchronize];
                            
                            [self.home_schoolChangeBtnOutlet setHidden:NO];
                            [self.mainClubNoView setHidden:YES];
                            
                            [self.login_viewTitleLabel setText:[NSString stringWithFormat:@"%@ 로그인 정보를 입력해 주세요.",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN_NM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                            [self.sos_viewTitleLabel setText:[NSString stringWithFormat:@"%@ 신고내용을 입력해 주세요.",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN_NM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                        }
                    }
                }
            }
            
        }else {
            
            noValue_mySchool_YN = YES;
            
            [self.home_offView setHidden:NO];
            [self.home_onView setHidden:YES];
        }
    }else if (connection == skin_connection) {
        skin_news = [NSJSONSerialization JSONObjectWithData:skin_data options:kNilOptions error:nil];
        
//        NSString *skinStr = [[skin_news objectForKey:@"config"] objectForKey:@"skin"];
        NSString *skinStr = [[skin_news objectForKey:@"config"] objectForKey:@"SKIN"];
        NSLog(@"test 스킨 정보 값 = %@",skinStr);
//        skinStr = @"3";
        
        if ([skinStr isEqualToString:@"1"]) {
            [self.home_topImageView     setImage:[UIImage imageNamed:@"top_bg01"]];
            [self.home_topImageView2    setImage:[UIImage imageNamed:@"top_bg01"]];
            [self.sos_topImageView      setImage:[UIImage imageNamed:@"top_bg01"]];
            [self.sos_topImageView2     setImage:[UIImage imageNamed:@"top_bg01"]];
            [self.setting_topImageView  setImage:[UIImage imageNamed:@"top_bg01"]];
            [self.guide_topImageView    setImage:[UIImage imageNamed:@"top_bg01"]];
            [self.search_topImageView   setImage:[UIImage imageNamed:@"top_bg01"]];
            [self.change_topImageView   setImage:[UIImage imageNamed:@"top_bg01"]];
        }else if ([skinStr isEqualToString:@"summer"]) {
            [self.home_topImageView     setImage:[UIImage imageNamed:@"top_bg02"]];
            [self.home_topImageView2    setImage:[UIImage imageNamed:@"top_bg02"]];
            [self.sos_topImageView      setImage:[UIImage imageNamed:@"top_bg02"]];
            [self.sos_topImageView2     setImage:[UIImage imageNamed:@"top_bg02"]];
            [self.setting_topImageView  setImage:[UIImage imageNamed:@"top_bg02"]];
            [self.guide_topImageView    setImage:[UIImage imageNamed:@"top_bg02"]];
            [self.search_topImageView   setImage:[UIImage imageNamed:@"top_bg02"]];
            [self.change_topImageView   setImage:[UIImage imageNamed:@"top_bg02"]];
        }else if ([skinStr isEqualToString:@"3"]) {
            [self.home_topImageView     setImage:[UIImage imageNamed:@"top_bg03"]];
            [self.home_topImageView2    setImage:[UIImage imageNamed:@"top_bg03"]];
            [self.sos_topImageView      setImage:[UIImage imageNamed:@"top_bg03"]];
            [self.sos_topImageView2     setImage:[UIImage imageNamed:@"top_bg03"]];
            [self.setting_topImageView  setImage:[UIImage imageNamed:@"top_bg03"]];
            [self.guide_topImageView    setImage:[UIImage imageNamed:@"top_bg03"]];
            [self.search_topImageView   setImage:[UIImage imageNamed:@"top_bg03"]];
            [self.change_topImageView   setImage:[UIImage imageNamed:@"top_bg03"]];
        }else if ([skinStr isEqualToString:@"4"]) {
            [self.home_topImageView     setImage:[UIImage imageNamed:@"top_bg04"]];
            [self.home_topImageView2    setImage:[UIImage imageNamed:@"top_bg04"]];
            [self.sos_topImageView      setImage:[UIImage imageNamed:@"top_bg04"]];
            [self.sos_topImageView2     setImage:[UIImage imageNamed:@"top_bg04"]];
            [self.setting_topImageView  setImage:[UIImage imageNamed:@"top_bg04"]];
            [self.guide_topImageView    setImage:[UIImage imageNamed:@"top_bg04"]];
            [self.search_topImageView   setImage:[UIImage imageNamed:@"top_bg04"]];
            [self.change_topImageView   setImage:[UIImage imageNamed:@"top_bg04"]];
        }else {
            [self.home_topImageView     setImage:[UIImage imageNamed:@"login_top_bg"]];
            [self.home_topImageView2    setImage:[UIImage imageNamed:@"login_top_bg"]];
            [self.sos_topImageView      setImage:[UIImage imageNamed:@"login_top_bg"]];
            [self.sos_topImageView2     setImage:[UIImage imageNamed:@"login_top_bg"]];
            [self.setting_topImageView  setImage:[UIImage imageNamed:@"login_top_bg"]];
            [self.guide_topImageView    setImage:[UIImage imageNamed:@"login_top_bg"]];
            [self.search_topImageView   setImage:[UIImage imageNamed:@"login_top_bg"]];
            [self.change_topImageView   setImage:[UIImage imageNamed:@"login_top_bg"]];
        }
        
        [self connectToServer_mySchoolList];
        
    }else if (connection == deleteList_connection) {
        deleteList_news = [NSJSONSerialization JSONObjectWithData:deleteList_data options:kNilOptions error:nil];
        
        NSString *deleteListStr = [deleteList_news objectForKey:@"rst"];
        
        if ([deleteListStr isEqualToString:@"Y"]) {
            [self connectToServer_mySchoolList];
            NSLog(@"test191911111 -- complete  %@",deleteListStr);
        }else {
            // 삭제 실패
            NSLog(@"test191911111 -- fail %@",deleteListStr);
        }
    }else if (connection == pushCheck_connection) {
        pushCheck_news = [NSJSONSerialization JSONObjectWithData:pushCheck_data options:kNilOptions error:nil];
        
        NSString *pushCheckStr = [pushCheck_news objectForKey:@"rst"];
        
        if ([pushCheckStr isEqualToString:@"Y"]) {
            [self connectToServer_mySchoolList];
            NSLog(@"test191911111222 -- complete  %@",pushCheckStr);
        }else {
            // 삭제 실패
            NSLog(@"test191911111222 -- fail %@",pushCheckStr);
        }
    }else if (connection == mainCheck_connection) {
        mainCheck_news = [NSJSONSerialization JSONObjectWithData:mainCheck_data options:kNilOptions error:nil];
        /// ddddddd
        
        NSString *pushCheckStr = [mainCheck_news objectForKey:@"rst"];
        
        if ([pushCheckStr isEqualToString:@"Y"]) {
            [self connectToServer_mySchoolList];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:mainDomID forKey:@"sq_mainDOMID"];
            [defaults synchronize];
    
            NSLog(@"test19191111122233 -- complete  %@",pushCheckStr);
        }else {
            // 삭제 실패
            NSLog(@"test19191111122233 -- fail %@",pushCheckStr);
        }
    }else if (connection == clubList_connection) {
        clubList_news = [NSJSONSerialization JSONObjectWithData:clubList_data options:kNilOptions error:nil];
        
        //        NSString *pushCheckStr = [clubChange_news objectForKey:@"rst"];
        
        clubList_news_re = nil;
        clubList_news_re = [NSMutableDictionary dictionaryWithObjectsAndKeys:clubList_news,@"dicData", nil];
        in_schoolChangeArray = [clubList_news_re objectForKey:@"dicData"];
        
        NSLog(@"test293912399999299992999299 -- %@",[clubList_news_re objectForKey:@"dicData"]);
        
        [self.change_tableView reloadData];
        [self.main_changeView setHidden:NO];
        
        schoolClub_addYchangeN = NO;
    }else if (connection == clubChange_connection) {
        clubChange_news = [NSJSONSerialization JSONObjectWithData:clubChange_data options:kNilOptions error:nil];
        
        NSString *clubChangeStr = [clubChange_news objectForKey:@"rst"];
        
        if ([clubChangeStr isEqualToString:@"Y"]) {
            [self connectToServer_mySchoolList];
            
            [self.main_changeView setHidden:YES];
            [self.main_searchView setHidden:YES];
            
            NSLog(@"test19191111122233 -- complete  %@",clubChangeStr);
        }else {
            // 삭제 실패
            NSLog(@"test19191111122233 -- fail %@",clubChangeStr);
        }
    }else if (connection == sendConnection) {
        
        NSError* error;
        NSDictionary* results = [NSJSONSerialization
                                 JSONObjectWithData:sendData
                                 options:kNilOptions
                                 error:&error];
        
//        results = [NSJSONSerialization JSONObjectWithData:sendData options:kNilOptions error:nil];
        
        NSLog(@"test291499  --  send results = %@",results);
        if ([[results objectForKey:@"msg"] isEqualToString:@"OK"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"등록되었습니다. 홈>학교폭력신고에서 확인 가능합니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView.title setIsAccessibilityElement:YES];
            [alertView.title setAccessibilityLabel:@"알림"];
            
            [alertView.message setIsAccessibilityElement:YES];
            [alertView.message setAccessibilityLabel:@"등록되었습니다. 홈>학교폭력신고에서 확인 가능합니다."];
            [alertView show];
            
            [self.sos_titleTextField setText:nil];
            [self.sos_contentsTextView setText:nil];
            
            isPic = nil;
            isVideo = nil;
            
            [self.fileNumberLabel setText:@"(0)"];
            
//            [self reButton];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:[results objectForKey:@"msg"] delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView.title setIsAccessibilityElement:YES];
            [alertView.title setAccessibilityLabel:@"알림"];
            
            [alertView.message setIsAccessibilityElement:YES];
            [alertView.message setAccessibilityLabel:[results objectForKey:@"msg"]];
            [alertView show];
        }
    }else if (connection == videoConnection) {
        
        NSError* error;
        NSDictionary* results = [NSJSONSerialization
                                 JSONObjectWithData:videoData
                                 options:kNilOptions
                                 error:&error];
        
        //        results = [NSJSONSerialization JSONObjectWithData:sendData options:kNilOptions error:nil];
        
        NSLog(@"test291499 22222222222   --  send results = %@",results);
        
        if ([[results objectForKey:@"msg"] isEqualToString:@"ok"]) {
            
            mobileUrlPath = [[NSString alloc] initWithFormat:@"%@",[results objectForKey:@"mobileUrlPath"]];
            mobileThumbFile = [[NSString alloc] initWithFormat:@"%@",[results objectForKey:@"mobileThumbFile"]];
            mobileMovFile = [[NSString alloc] initWithFormat:@"%@",[results objectForKey:@"mobileMovFile"]];
            
            
            isVideo = YES;
            isPic = NO;
//            [self setLogin];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:[results objectForKey:@"msg"] delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView.title setIsAccessibilityElement:YES];
            [alertView.title setAccessibilityLabel:@"알림"];
            
            [alertView.message setIsAccessibilityElement:YES];
            [alertView.message setAccessibilityLabel:[results objectForKey:@"msg"]];
            [alertView show];
            
        }
        
    }else if (connection == getConnection) {
        NSError* error;
        NSDictionary* results = [NSJSONSerialization
                                 JSONObjectWithData:getData
                                 options:kNilOptions
                                 error:&error];
        
        NSLog(@"test mappinginfo result .... \n%@",results);
        
        if ([[results objectForKey:@"msg"] isEqualToString:@"OK"]) {
            
            [self.main_homeView setHidden:YES];
            [self.main_sosView setHidden:NO];
            [self.main_schoolSettingView setHidden:YES];
            [self.main_guideView setHidden:YES];
            
            [self.main_searchView setHidden:YES];
            [self.main_changeView setHidden:YES];
            
            [self.home_offView setHidden:YES];
            
            [self webViewForwardBackBtnOutletSetEnabled:NO selectBtn:self.main_tabBackBtnOutlet imageNameStr:@"bt_menuBack_off"];
            [self webViewForwardBackBtnOutletSetEnabled:NO selectBtn:self.main_tabForwardBtnOutlet imageNameStr:@"bt_menuForward_off"];
            
            [self.main_tabOutlet_1 setBackgroundImage:[UIImage imageNamed:@"bt_menu01"] forState:UIControlStateNormal];
            [self.main_tabOutlet_2 setBackgroundImage:[UIImage imageNamed:@"bt_menu02_on"] forState:UIControlStateNormal];
            [self.main_tabOutlet_3 setBackgroundImage:[UIImage imageNamed:@"bt_menu03"] forState:UIControlStateNormal];
            [self.main_tabOutlet_4 setBackgroundImage:[UIImage imageNamed:@"bt_menu04"] forState:UIControlStateNormal];
            
            if ([ssoKey isEqualToString:@""] || !ssoKey)
            {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                //자동 로그인 체크상태라면...
                if ([[defaults objectForKey:@"autoLoginYN"] isEqualToString:@"Y"])
                {
                    self.sos_loginIdTextField.text = [defaults objectForKey:@"auto_idStr"];
//                    self.sos_loginPwTextField.text = [defaults objectForKey:@"auto_pwStr"];
                    
                    // 자동로그인에 패스워드 제거
//                    self.sos_loginPwTextField.text = [self tempPwd];
                    
                    
                    [self.id_textField_imageView setImage:[UIImage imageNamed:@"idpwd_input_on"]];
                    [self.pw_textField_imageView setImage:[UIImage imageNamed:@"idpwd_input_on"]];
                    
                }
                else
                {
                    self.sos_loginIdTextField.text = nil;
                    self.sos_loginPwTextField.text = nil;
                }
                
                [self.sos_loginView setHidden:NO];
            }else {
                
                // 로그인 되어있을때
//                [self.sos_loginView setHidden:YES];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [self connectToServer_login:[defaults objectForKey:@"auto_idStr"] pwDataStr:[defaults objectForKey:@"auto_pwStr"]];
            }
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([[defaults objectForKey:@"autoLoginYN"] isEqualToString:@"Y"]) {
                self.sos_loginIdTextField.text = [defaults objectForKey:@"auto_idStr"];
//                self.sos_loginPwTextField.text = [defaults objectForKey:@"auto_pwStr"];
                // 자동로그인에 패스워드 제거
//                self.sos_loginPwTextField.text = [self tempPwd];
                
                
                [self.id_textField_imageView setImage:[UIImage imageNamed:@"idpwd_input_on"]];
                [self.pw_textField_imageView setImage:[UIImage imageNamed:@"idpwd_input_on"]];

            }else {
                self.sos_loginIdTextField.text = nil;
                self.sos_loginPwTextField.text = nil;
            }
            menuCd = [[NSString alloc] initWithFormat:@"%@",[results objectForKey:@"menuCd"]];
            boardId = [[NSString alloc] initWithFormat:@"%@",[results objectForKey:@"boardId"]];
            
            NSLog(@"test 메뉴시드 보드아이디 결과값 %@",results);
            NSLog(@"test menuCd , boardId 값 = %@ , %@",menuCd,boardId);
            
        } else {
            // 학교폭력신고 예외처리 부분
            
            UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"알림"
                                                                message:[results objectForKey:@"msg"]
                                                               delegate:self
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil , nil];
            [errorView show];
            
            //            [self homeViewButton];
        }
    }else if (connection == logoutConnection) {
        NSError* error;
        NSDictionary* results = [NSJSONSerialization
                                 JSONObjectWithData:logoutData
                                 options:kNilOptions
                                 error:&error];
        NSLog(@"test logout 결과 = %@",results);
        
        if ([[results objectForKey:@"msg"] isEqualToString:@"OK"])
        {
            //웹뷰 쿠키 삭제하기.
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            
            for(NSHTTPCookie *cookie in [storage cookies])
            {
                [storage deleteCookie:cookie];
            }
            
            
            if (!webviewLogoutYN) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                if ([[defaults objectForKey:@"autoLoginYN"] isEqualToString:@"Y"]) {
                    self.sos_loginIdTextField.text = [defaults objectForKey:@"auto_idStr"];
//                    self.sos_loginPwTextField.text = [defaults objectForKey:@"auto_pwStr"];
                    // 자동로그인에 패스워드 제거
//                    self.sos_loginPwTextField.text = [self tempPwd];
                    
                    
                    [self.id_textField_imageView setImage:[UIImage imageNamed:@"idpwd_input_on"]];
                    [self.pw_textField_imageView setImage:[UIImage imageNamed:@"idpwd_input_on"]];
                    
                }else {
                    self.sos_loginIdTextField.text = nil;
                    self.sos_loginPwTextField.text = nil;
                }
                
                [self.sos_loginView setHidden:NO];
            }
            
            UIAlertView *errorView;
            
            [errorView dismissWithClickedButtonIndex:0 animated:YES];
            [loginSuccessAlertView dismissWithClickedButtonIndex:0 animated:YES];
        
            [self showPressed_tostAlertLabel:@"정상적으로 로그아웃 되었습니다."];
            
//            errorView = [[UIAlertView alloc] initWithTitle:@"로그아웃"
//                                                                message:@"정상적으로 로그아웃 되었습니다."
//                                                               delegate:self
//                                                      cancelButtonTitle:@"확인"
//                                                      otherButtonTitles:nil , nil];
//            [errorView show];
            
            // 키보드 다 내리기
            [self.sos_titleTextField resignFirstResponder];
            [self.sos_contentsTextView resignFirstResponder];
            
            ssoKey = @"";
            
        } else {
            //                        [self homeViewButton];
        }
        
        webviewLogoutYN = NO;
        
        [self connectToServer_mySchoolList];
        
    }else if (connection == logoutAlert_Connection) {
        NSError* error;
        NSDictionary* results = [NSJSONSerialization
                                 JSONObjectWithData:logoutAlert_Data
                                 options:kNilOptions
                                 error:&error];
        NSLog(@"test logoutAlert 결과 = %@",results);
        if ([[results objectForKey:@"msg"] isEqualToString:@"OK"]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            [defaults setObject:@"" forKey:@"aes_idStr"];
//            [defaults setObject:@"" forKey:@"aes_pwStr"];
            
//            [defaults setObject:@"N" forKey:@"autoLoginYN"];
            [defaults synchronize];
            
            ssoKey = @"";
            
            
            [self connectToServer_mainCheck2:change_mainSchool_AlertInt];
            
        } else {
            //                        [self homeViewButton];
        }
    }else if (connection == error_connection) {
//        NSMutableArray *testArray = [NSJSONSerialization JSONObjectWithData:error_data options:kNilOptions error:nil];
//        NSLog(@"test error 결과 = %@",[[NSString alloc] initWithData:error_data encoding:NSUTF8StringEncoding]);
//        NSLog(@"test error 결과 = %@",testArray);
    
    }else if (connection == event_connection) {
        NSError* error;
        
        NSMutableArray *testArray = [NSJSONSerialization JSONObjectWithData:event_data options:kNilOptions error:nil];
        
        NSLog(@"test event 결과 = %@",testArray);
        NSLog(@"test event 결과 = %@",[testArray objectAtIndex:0]);
        NSLog(@"test event 결과 = %@",[[testArray objectAtIndex:0] objectForKey:@"event_edate"]);
        NSLog(@"test event 결과 = %@",[[testArray objectAtIndex:0] objectForKey:@"gubun"]);
        
        NSString *testGubun = [NSString stringWithFormat:@"%@",[[testArray objectAtIndex:0] objectForKey:@"gubun"]];
        
        if ([testGubun isEqualToString:@"1"]) {
            [self.event_View setHidden:NO];
            
            NSURL *webViewURL = [[NSURL alloc] initWithString:@"http://skoschool.skoinfo.co.kr/index.do?menuCd=MCD_000000000000085065"];
            NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:webViewURL];
            [self.event_webView loadRequest:urlRequest];
            
        }else if ([testGubun isEqualToString:@"2"]) {
            [self.event_View setHidden:NO];
            
            NSURL *webViewURL = [[NSURL alloc] initWithString:@"http://skoschool.skoinfo.co.kr/index.do?menuCd=MCD_000000000000085065"];
            NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:webViewURL];
            [self.event_webView loadRequest:urlRequest];
        }else {
            
        }
        
        [self connectToServer_mySchoolList];
        
    }else if (connection == alramSetting_connection) {
        NSError* error;
        
        NSMutableDictionary *testArray = [NSJSONSerialization JSONObjectWithData:alramSetting_data options:kNilOptions error:nil];
        
        NSLog(@"test alramSetting 결과 = %@",[testArray objectForKey:@"rst"]);

        if ([[testArray objectForKey:@"rst"] isEqualToString:@"Y"]) {
            CSchangeYN = YES;
            [self connectToServer_mySchoolList];
        }
    }

    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//    [self.search_indicator stopAnimating];
//    
//    [self.search_indicator setHidden:YES];
//    [self.search_indicatorBG setHidden:YES];
    
    [self.indicator_view stopAnimating];
    
    [self.indicator_view setHidden:YES];
    [self.indicator_bgBtnOutlet setHidden:YES];
    
//    if (connection != schoolSearch_connection) {
//        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"네트워크 연결상태 확인"
//                                                            message:@"인터넷 연결이 끊어졌습니다.\n3G/4G 또는 와이파이 연결 상태를 확인해 주세요"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"확인"
//                                                  otherButtonTitles:nil , nil];
//        [errorView show];
//    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (connection == error_connection) {
        
    }
}


//////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.search_tableView) {
        return 2;
    }else if (tableView == self.change_tableView) {
        return 1;
    }else if (tableView == self.setting_tableView) {
        return [mySchoolList_news count];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.search_tableView) {
        if ([[schoolSearch_news objectForKey:@"data"] count] > 0) {
            if (section == 0) {
                return 0;
            }else {
                return [[schoolSearch_news objectForKey:@"data"] count];
            }
        }else {
            if (section == 0) {
                return 1;
            }else {
                return 0;
            }
        }
    }else if (tableView == self.change_tableView) {
//        return [in_schoolChangeArray count]+1;
        return [in_schoolChangeArray count];
    }else if (tableView == self.setting_tableView) {
//        return [mySchoolList_news count];
        if (isOpen_subTL) {
            if (selectIndex_subTL.section == section) {
//                return [mySchoolList_news count]+ 1;
                return [CS_detailArray count] + 1;
            }
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.setting_tableView) {
        if (indexPath.row != 0) {
            return 35;
        }else {
            return 44.0;
        }
    }else {
        return 44.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([[schoolSearch_news objectForKey:@"data"] count] > 0) {
    
    if (tableView == self.search_tableView) {
        if (indexPath.section == 1) {
        
            UITableViewCell *cell=(UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"searchTableCell"];
            
            if (cell == nil) {
                cell=[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:@"searchTableCell"];
                
            }
            
            UILabel *schoolNameLabel = (UILabel *)[cell viewWithTag:11];
            [schoolNameLabel setText:nil];
            
            NSString *testStr;

            if ([[schoolSearch_news objectForKey:@"data"] count] > 0) {
                testStr = [[[[schoolSearch_news objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"schoolName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            
            [schoolNameLabel setText:testStr];
            
            return cell;
        } else {
            UITableViewCell *cell=(UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"searchTableCell2"];
            
            if (cell == nil) {
                cell=[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:@"searchTableCell2"];
            }
            
            return  cell;
        }
    }else if (tableView == self.change_tableView) {
        UITableViewCell *cell=(UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"changeTableCell"];
        
        if (cell == nil) {
            cell=[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:@"changeTableCell"];
            
        }
        
        UILabel *schoolNameLabel = (UILabel *)[cell viewWithTag:11];
        [schoolNameLabel setText:nil];
        
//        if (indexPath.row == 0) {
//            [schoolNameLabel setText:@"일반사용자"];
//        }else {
//        
//            NSString *testStr;
//            
//            //        if ([[in_schoolChangeArray objectForKey:@"data"] count] > 0) {
//            NSLog(@"test22222292929299999222999299920 -- %@",in_schoolChangeArray);
//            testStr = [[[in_schoolChangeArray objectAtIndex:indexPath.row - 1] objectForKey:@"CLASSNM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            //        }
//            
//            [schoolNameLabel setText:testStr];
//        }
        NSString *testStr = [[[in_schoolChangeArray objectAtIndex:indexPath.row] objectForKey:@"CLASSNM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [schoolNameLabel setText:testStr];
        
        return cell;
    }else if (tableView == self.setting_tableView) {
        if (isOpen_subTL&&selectIndex_subTL.section == indexPath.section&&indexPath.row!=0) {
            Sub_Cell_2 *cell = (Sub_Cell_2*)[tableView dequeueReusableCellWithIdentifier:@"sub_cell_2"];
            
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"Sub_Cell_2" owner:self options:nil] objectAtIndex:0];
            }
            
            cell.backgroundColor=[UIColor clearColor];
            cell.backgroundColor=[UIColor groupTableViewBackgroundColor];
            
            CS_detailArray = [[NSMutableArray alloc] init];
            
//            NSString *cell2_bbsStr = [[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:indexPath.section] objectForKey:@"BBS"];
//            
//            NSArray *bbsArray = [cell2_bbsStr componentsSeparatedByString:@","];
//            
//            for (int i = 0; i < [bbsArray count]; i++) {
//                NSArray *detail_bbsArray = [[bbsArray objectAtIndex:i] componentsSeparatedByString:@"|"];
//                if (CS_YorN) {
//                    if ([[detail_bbsArray objectAtIndex:2] isEqualToString:@"C"]) {
//                        [CS_detailArray addObject:[bbsArray objectAtIndex:i]];
//                    }
//                }else {
//                    if ([[detail_bbsArray objectAtIndex:2] isEqualToString:@"S"]) {
//                        [CS_detailArray addObject:[bbsArray objectAtIndex:i]];
//                    }
//                }
//            }
            
            NSArray * bbsArray = [[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:indexPath.section] objectForKey:@"BBS"];
            
            for (int i = 0; i < [bbsArray count]; i++) {
                if (CS_YorN) {
                    if ([[[bbsArray objectAtIndex:i] objectForKey:@"GROUP"] isEqualToString:@"C"]) {
                        [CS_detailArray addObject:[bbsArray objectAtIndex:i]];
                    }
                }else {
                    if ([[[bbsArray objectAtIndex:i] objectForKey:@"GROUP"] isEqualToString:@"S"]) {
                        [CS_detailArray addObject:[bbsArray objectAtIndex:i]];
                    }
                }
            }
            

//            NSLog(@"test clubAlertShowBtnPress reerererererere %@",CS_detailArray);
            
            cell.cell2_label.text = [NSString stringWithFormat:@"%@",[[CS_detailArray objectAtIndex:indexPath.row-1] objectForKey:@"MENU_NAME"]];
            
            if ([[[CS_detailArray objectAtIndex:indexPath.row-1] objectForKey:@"ISUSE"] isEqualToString:@"Y"]) {
                [cell.cell2_btnImageView setImage:[UIImage imageNamed:@"btn_alam_on"]];
            }else {
                [cell.cell2_btnImageView setImage:[UIImage imageNamed:@"btn_alam_off"]];
            }
            
            [cell.cell2_btnOutlet setTag:indexPath.row + 10000];
            cell.cell2_btnOutlet.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
            cell.cell2_btnOutlet.titleLabel.hidden = YES;
            [cell.cell2_btnOutlet addTarget:self action:@selector(cell2_alramBtnPress:) forControlEvents:UIControlEventTouchUpInside];

            return cell;
            
        } else {
            
            UITableViewCell *cell=(UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"settingTableCell"];
            
            if (cell == nil) {
                cell=[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:@"settingTableCell"];
                
            }
            
            UILabel *schoolNameLabel = (UILabel *)[cell viewWithTag:11];
            UILabel *schoolClubLabel = (UILabel *)[cell viewWithTag:12];
            UIImageView *pushCheckImgView = (UIImageView *)[cell viewWithTag:14];
            UIImageView *mainSchoolCheckImgView = (UIImageView *)[cell viewWithTag:15];
            
            UIImageView *C_settingBtnImgView = (UIImageView *)[cell viewWithTag:16];
            UIImageView *S_settingBtnImgView = (UIImageView *)[cell viewWithTag:17];
            
            //        UIButton *clubChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            UIButton *pushCheckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            UIButton *mainCheckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            UIButton *clubAlertShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            UIButton *defaultAlertShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [schoolNameLabel setText:nil];
            [schoolClubLabel setText:nil];
            [pushCheckImgView setImage:nil];
            [mainSchoolCheckImgView setImage:nil];
            
            [C_settingBtnImgView setImage:nil];
            //        [S_settingBtnImgView setImage:nil];
            
            //        [clubChangeBtn setFrame:CGRectMake(150, 5, 85, 40)];
            [pushCheckBtn setFrame:CGRectMake(235, 5, 40, 40)];
            [mainCheckBtn setFrame:CGRectMake(275, 5, 40, 40)];
            
            [clubAlertShowBtn setFrame:CGRectMake(175, 5, 40, 40)];
            [defaultAlertShowBtn setFrame:CGRectMake(235, 5, 40, 40)];
            
            NSString *schoolNameStr;
            NSString *schoolClubStr;
            
            
            //        NSMutableArray *mySchoolList_reArray = [NSJSONSerialization JSONObjectWithData:[[NSString stringWithFormat:@"%@", mySchoolList_news] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
            
            
            //        NSLog(@"test21939122222222 내 목록 리스트 -- %@",mySchoolList_news_re);
            //        if ([[in_schoolChangeArray objectForKey:@"data"] count] > 0) {
//            schoolNameStr = [[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:indexPath.row] objectForKey:@"DOMAIN_NM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            NSString *guestDomainStr = [NSString stringWithFormat:@"%@||",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:indexPath.row] objectForKey:@"DOMAIN_ID"]];
//            guestArrayStr = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"guestAddStr"]];
//            NSRange strRange_searchDomain = [guestArrayStr rangeOfString:guestDomainStr];
//            if (strRange_searchDomain.location != NSNotFound){
//                schoolClubStr = @"일반사용자";
//            }else {
//                schoolClubStr = [[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:indexPath.row] objectForKey:@"CLASSNM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            }

            schoolNameStr = [[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:indexPath.section] objectForKey:@"DOMAIN_NM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *guestDomainStr = [NSString stringWithFormat:@"%@||",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:indexPath.section] objectForKey:@"DOMAIN_ID"]];
            guestArrayStr = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"guestAddStr"]];
            NSRange strRange_searchDomain = [guestArrayStr rangeOfString:guestDomainStr];
            if (strRange_searchDomain.location != NSNotFound){
//                schoolClubStr = @"일반사용자";
                schoolClubStr = @"";
            }else {
                schoolClubStr = [[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:indexPath.section] objectForKey:@"CLASSNM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            
            schoolClubStr = [[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:indexPath.section] objectForKey:@"CLASSNM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            //        }
            
            [schoolNameLabel setText:schoolNameStr];
            [schoolClubLabel setText:schoolClubStr];
            
//            // 푸시 알림 설정에 따라 이미지 변경
//            if ([[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:indexPath.row] objectForKey:@"PUSH"] isEqualToString:@"N"]) {
//                [pushCheckImgView setImage:[UIImage imageNamed:@"check_none"]];
//            }else {
//                [pushCheckImgView setImage:[UIImage imageNamed:@"check_check"]];
//            }
//            
//            //        [pushCheckImgView setImage:[UIImage imageNamed:@"check_check"]];
//            
//            if ([[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:indexPath.row] objectForKey:@"MAIN"] isEqualToString:@"Y"]) {
//                [mainSchoolCheckImgView setImage:[UIImage imageNamed:@"radio_check"]];
//            }else {
//                [mainSchoolCheckImgView setImage:[UIImage imageNamed:@"radio_none"]];
//            }
//            
//            
//            if (![[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:indexPath.row] objectForKey:@"CLASSNM"] isEqualToString:@""]) {
//                [C_settingBtnImgView setImage:[UIImage imageNamed:@"icon_option_on"]];
//            }else {
//                [C_settingBtnImgView setImage:[UIImage imageNamed:@"icon_option"]];
//            }

            
            // 푸시 알림 설정에 따라 이미지 변경
            if ([[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:indexPath.section] objectForKey:@"PUSH"] isEqualToString:@"N"]) {
                [pushCheckImgView setImage:[UIImage imageNamed:@"check_none"]];
            }else {
                [pushCheckImgView setImage:[UIImage imageNamed:@"check_check"]];
            }
            
            if ([[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:indexPath.section] objectForKey:@"MAIN2"] isEqualToString:@"Y"]) {
                [mainSchoolCheckImgView setImage:[UIImage imageNamed:@"radio_check"]];
            }else {
                [mainSchoolCheckImgView setImage:[UIImage imageNamed:@"radio_none"]];
            }
            
            
            if (![[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:indexPath.section] objectForKey:@"CLASSNM"] isEqualToString:@""]) {
                [C_settingBtnImgView setImage:[UIImage imageNamed:@"icon_option_on"]];
            }else {
                [C_settingBtnImgView setImage:[UIImage imageNamed:@"icon_option"]];
            }
            
            
            //        [clubChangeBtn setTag:indexPath.row + 1000];
            //        [clubChangeBtn addTarget:self action:@selector(clubChangeBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            
            [pushCheckBtn setTag:indexPath.row + 10000];
            [pushCheckBtn addTarget:self action:@selector(pushCheckBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            
//            [mainCheckBtn setTag:indexPath.row + 100000];
            [mainCheckBtn setTag:indexPath.section + 100000];
            [mainCheckBtn addTarget:self action:@selector(mainCheckBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            
            [clubAlertShowBtn setTag:indexPath.row + 100000];
            clubAlertShowBtn.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
            clubAlertShowBtn.titleLabel.hidden = YES;
            [clubAlertShowBtn addTarget:self action:@selector(clubAlertShowBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            
            [defaultAlertShowBtn setTag:indexPath.row + 100000];
            defaultAlertShowBtn.titleLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
            defaultAlertShowBtn.titleLabel.hidden = YES;
            [defaultAlertShowBtn addTarget:self action:@selector(defaultAlertShowBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            
            //        [cell.contentView addSubview:clubChangeBtn];
            [cell.contentView addSubview:pushCheckBtn];
            [cell.contentView addSubview:mainCheckBtn];
            
            [cell.contentView addSubview:clubAlertShowBtn];
            [cell.contentView addSubview:defaultAlertShowBtn];
            
            return cell;
        }
    }else {
        UITableViewCell *cell=(UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"searchTableCell22"];
        
        if (cell == nil) {
            cell=[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:@"searchTableCell22"];
        }
        
        return cell;
    }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.search_tableView) {
        if (indexPath.section == 1) {
            
            [self.search_searchBar resignFirstResponder];
            
    //        [self.main_searchView setHidden:YES];
            
            
            if ([[schoolSearch_news objectForKey:@"data"] count] > 0) {
//            if ([[[[schoolSearch_news objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"club"] count] > 0) {
                
                in_schoolChangeArray = [[NSMutableArray alloc] init];
                
                in_schoolChangeArray = [NSJSONSerialization JSONObjectWithData:[[[[schoolSearch_news objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"club"] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];

                NSLog(@"test400 no value school data -- %@", schoolSearch_news);
                NSLog(@"test400 -- %@", in_schoolChangeArray);

                if ([in_schoolChangeArray count] > 0) {
                    
                    schoolClub_addYchangeN = YES;
                    
                    [self.main_changeView setHidden:NO];
                    
                    [self.change_tableView reloadData];
                    
                    NSString *domainStr;
                    NSString *sidStr;
                    NSString *infoStr;
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSString *guestDomainStr = [NSString stringWithFormat:@"%@||",[[in_schoolChangeArray objectAtIndex:0] objectForKey:@"DOMAIN_ID"]];
                    guestArrayStr = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"guestAddStr"]];
                    
                    if (indexPath.row == 0) {
                        // 일반사용자 Array 저장
                        NSLog(@"test 일반사용자 등록");
                        
                        guestArrayStr = [NSString stringWithFormat:@"%@%@",guestArrayStr,guestDomainStr];
                        
                    }else {
                        guestArrayStr = [guestArrayStr stringByReplacingOccurrencesOfString:guestDomainStr withString:@""];
                        
                    }
                    [defaults setObject:guestArrayStr forKey:@"guestAddStr"];
                    [defaults synchronize];
                    
                    if (schoolClub_addYchangeN) {
                        //                if (indexPath.row == 0) {
                        //                    domainStr = [[in_schoolChangeArray objectAtIndex:0] objectForKey:@"DOMAIN_ID"];
                        //                    sidStr = [[in_schoolChangeArray objectAtIndex:0] objectForKey:@"GRADE_SID"];
                        //                    infoStr = [[in_schoolChangeArray objectAtIndex:0] objectForKey:@"INFO_ID"];
                        //                }else {
                        //                    domainStr = [[in_schoolChangeArray objectAtIndex:indexPath.row - 1] objectForKey:@"DOMAIN_ID"];
                        //                    sidStr = [[in_schoolChangeArray objectAtIndex:indexPath.row - 1] objectForKey:@"GRADE_SID"];
                        //                    infoStr = [[in_schoolChangeArray objectAtIndex:indexPath.row - 1] objectForKey:@"INFO_ID"];
                        //                }
                        
                        domainStr = [[in_schoolChangeArray objectAtIndex:0] objectForKey:@"DOMAIN_ID"];
                        sidStr = [[in_schoolChangeArray objectAtIndex:0] objectForKey:@"GRADE_SID"];
                        infoStr = [[in_schoolChangeArray objectAtIndex:0] objectForKey:@"INFO_ID"];
                        
//                        [self connectToServer_schoolAdd:domainStr sidData:sidStr infoData:infoStr];
                    }else {
                        
                        //                if (indexPath.row == 0) {
                        //                    sidStr = [[in_schoolChangeArray objectAtIndex:0] objectForKey:@"GRADE_SID"];
                        //                    infoStr = [[in_schoolChangeArray objectAtIndex:0] objectForKey:@"INFO_ID"];
                        //                }else {
                        //                    sidStr = [[in_schoolChangeArray objectAtIndex:indexPath.row - 1] objectForKey:@"GRADE_SID"];
                        //                    infoStr = [[in_schoolChangeArray objectAtIndex:indexPath.row - 1] objectForKey:@"INFO_ID"];
                        //                }
                        
                        sidStr = [[in_schoolChangeArray objectAtIndex:0] objectForKey:@"GRADE_SID"];
                        infoStr = [[in_schoolChangeArray objectAtIndex:0] objectForKey:@"INFO_ID"];
                        
                        //            NSString *sidStr = [[in_schoolChangeArray objectAtIndex:indexPath.row] objectForKey:@"GRADE_SID"];
                        //            NSString *infoStr = [[in_schoolChangeArray objectAtIndex:indexPath.row] objectForKey:@"INFO_ID"];
                        
//                        [self connectToServer_clubChange:changeIdxStr sidData:sidStr infoData:infoStr];
                        
                        //            NSString *sidStr = [[in_schoolChangeArray objectAtIndex:indexPath.row] objectForKey:@"GRADE_SID"];
                        //            NSString *infoStr = [[in_schoolChangeArray objectAtIndex:indexPath.row] objectForKey:@"INFO_ID"];
                        //
                        //            [self connectToServer_clubChange:changeIdxStr sidData:sidStr infoData:infoStr];
                    }
                    
                }else {
                    
//                    NSMutableArray *testM_array = [[NSMutableArray alloc] init];
//                    
//                    testM_array = [NSJSONSerialization JSONObjectWithData:[[schoolSearch_news objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
                    
                    schoolAdd_noClubDomainIDStr = [NSString stringWithFormat:@"%@",[[[schoolSearch_news objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"schoolDomainId"]];
                    
                    schoolAdd_noClubAlert = [[UIAlertView alloc] initWithTitle:@"알림"
                                                                        message:@"학반정보가 없는 학교입니다.\n해당 학교를 추가 하시겠습니까?"
                                                                       delegate:self
                                                              cancelButtonTitle:@"취소"
                                                              otherButtonTitles:@"추가" , nil];
                    [schoolAdd_noClubAlert show];
                }
            }
            
        }
    }else if (tableView == self.change_tableView) {
        
        NSString *domainStr;
        NSString *sidStr;
        NSString *infoStr;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *guestDomainStr = [NSString stringWithFormat:@"%@||",[[in_schoolChangeArray objectAtIndex:0] objectForKey:@"DOMAIN_ID"]];
        guestArrayStr = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"guestAddStr"]];
        
//        if (indexPath.row == 0) {
//            // 일반사용자 Array 저장
//            NSLog(@"test 일반사용자 등록");
//            
//            guestArrayStr = [NSString stringWithFormat:@"%@%@",guestArrayStr,guestDomainStr];
//            
//        }else {
//            guestArrayStr = [guestArrayStr stringByReplacingOccurrencesOfString:guestDomainStr withString:@""];
//            
//        }
        
        guestArrayStr = [guestArrayStr stringByReplacingOccurrencesOfString:guestDomainStr withString:@""];
        
        [defaults setObject:guestArrayStr forKey:@"guestAddStr"];
        [defaults synchronize];
        
        if (schoolClub_addYchangeN) {
//            if (indexPath.row == 0) {
//                domainStr = [[in_schoolChangeArray objectAtIndex:0] objectForKey:@"DOMAIN_ID"];
//                sidStr = [[in_schoolChangeArray objectAtIndex:0] objectForKey:@"GRADE_SID"];
//                infoStr = [[in_schoolChangeArray objectAtIndex:0] objectForKey:@"INFO_ID"];
//            }else {
//                domainStr = [[in_schoolChangeArray objectAtIndex:indexPath.row - 1] objectForKey:@"DOMAIN_ID"];
//                sidStr = [[in_schoolChangeArray objectAtIndex:indexPath.row - 1] objectForKey:@"GRADE_SID"];
//                infoStr = [[in_schoolChangeArray objectAtIndex:indexPath.row - 1] objectForKey:@"INFO_ID"];
//            }

            domainStr = [[in_schoolChangeArray objectAtIndex:indexPath.row] objectForKey:@"DOMAIN_ID"];
            sidStr = [[in_schoolChangeArray objectAtIndex:indexPath.row] objectForKey:@"GRADE_SID"];
            infoStr = [[in_schoolChangeArray objectAtIndex:indexPath.row] objectForKey:@"INFO_ID"];
            
            NSLog(@"test data value check -- %@",in_schoolChangeArray);
            
//            noValue_mySchool_idxStr = [NSString stringWithFormat:@"%@",[[in_schoolChangeArray objectAtIndex:indexPath.row] objectForKey:@"IDX"]];
            
            [self connectToServer_schoolAdd:domainStr sidData:sidStr infoData:infoStr];
        }else {

//            if (indexPath.row == 0) {
//                sidStr = [[in_schoolChangeArray objectAtIndex:0] objectForKey:@"GRADE_SID"];
//                infoStr = [[in_schoolChangeArray objectAtIndex:0] objectForKey:@"INFO_ID"];
//            }else {
//                sidStr = [[in_schoolChangeArray objectAtIndex:indexPath.row - 1] objectForKey:@"GRADE_SID"];
//                infoStr = [[in_schoolChangeArray objectAtIndex:indexPath.row - 1] objectForKey:@"INFO_ID"];
//            }
            NSString *sidStr = [[in_schoolChangeArray objectAtIndex:indexPath.row] objectForKey:@"GRADE_SID"];
            NSString *infoStr = [[in_schoolChangeArray objectAtIndex:indexPath.row] objectForKey:@"INFO_ID"];
            
            [self connectToServer_clubChange:changeIdxStr sidData:sidStr infoData:infoStr];
            
//            NSString *sidStr = [[in_schoolChangeArray objectAtIndex:indexPath.row] objectForKey:@"GRADE_SID"];
//            NSString *infoStr = [[in_schoolChangeArray objectAtIndex:indexPath.row] objectForKey:@"INFO_ID"];
//
//            [self connectToServer_clubChange:changeIdxStr sidData:sidStr infoData:infoStr];
        }
    }else if (tableView == self.setting_tableView) {
        
        if (indexPath.row == 0) {

            NSString *idxStr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:indexPath.section] objectForKey:@"IDX"]];
            
            [self connectToServer_mainCheck:idxStr];
            
            settingView_selectIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.setting_tableView) {
        return YES;
    }else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    NSLog(@"test2914991111111122222 -- ");
    
//    [self connectToServer_deleteList:[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:indexPath.row] objectForKey:@"IDX"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self connectToServer_deleteList:[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:indexPath.section] objectForKey:@"IDX"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"삭제";
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.search_searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (![searchText isEqualToString:@""]) {
        [self connectToServer_schoolSearch];
    }else {
        //        [searchBar resignFirstResponder];
    }
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.sos_loginIdTextField) {
//        if ([textField.text isEqualToString:@""]) {
//            [self.id_textField_imageView setImage:[UIImage imageNamed:@"id_input"]];
//        }else {
            [self.id_textField_imageView setImage:[UIImage imageNamed:@"idpwd_input_on"]];
//        }
    }else if (textField == self.sos_loginPwTextField) {
//        if ([textField.text isEqualToString:@""]) {
//            [self.pw_textField_imageView setImage:[UIImage imageNamed:@"pwd_input"]];
//        }else {
            [self.pw_textField_imageView setImage:[UIImage imageNamed:@"idpwd_input_on"]];
//        }
    }
    
    return YES;
}


// textfield 편집이 종료된 후에 실행
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.sos_loginIdTextField) {
        if ([textField.text isEqualToString:@""]) {
            [self.id_textField_imageView setImage:[UIImage imageNamed:@"id_input"]];
        }else {
            [self.id_textField_imageView setImage:[UIImage imageNamed:@"idpwd_input_on"]];
        }
    }else if (textField == self.sos_loginPwTextField) {
        if ([textField.text isEqualToString:@""]) {
            [self.pw_textField_imageView setImage:[UIImage imageNamed:@"pwd_input"]];
        }else {
            [self.pw_textField_imageView setImage:[UIImage imageNamed:@"idpwd_input_on"]];
        }
    }
}

// 리턴 키를 누를 때 실행
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.sos_loginIdTextField || textField == self.sos_loginPwTextField || textField == self.sos_titleTextField) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"textViewShouldBeginEditing:");
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationsEnabled:YES];
    
//    CGRect rect = self.textView_downView.frame;
//    NSLog(@"test299419 %f",rect.origin.y);
//    if (rect.origin.y == 568) {
//        rect.origin.y -= 215;
//        rect.size.height += 215;
//        self.textView_downView.frame = rect;
//    }
    
//    [self.textView_downView setFrame:CGRectMake(0, 400, 320, 25)];
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (iOSDeviceScreenSize.height == 480) {
        [self.textView_downView setFrame:CGRectMake(0, 237, 320, 40)];
    }else { //if (iOSDeviceScreenSize.height == 568) {
        [self.textView_downView setFrame:CGRectMake(0, 325, 320, 40)];
    }
    
    [self.textView_downView setAlpha:1.0];
    
    [UIView commitAnimations];
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"textViewShouldEndEditing:");
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationsEnabled:YES];
    
//    [self.textView_downView setFrame:CGRectMake(0, 568, 320, 25)];
    [self.textView_downView setAlpha:0.0];
    
    [UIView commitAnimations];
    
    return YES;
}


- (IBAction)clubChangeBtnPress:(id)sender {
    
    UIButton *tempBtn = (UIButton *)sender;

    changeIdxStr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:tempBtn.tag-1000] objectForKey:@"IDX"]];
    [self connectToServer_clubList:[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:tempBtn.tag-1000] objectForKey:@"DOMAIN_ID"]];
}

- (IBAction)pushCheckBtnPress:(id)sender {
    
    UIButton *tempBtn = (UIButton *)sender;
    
    NSString *pushCheckYN = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:tempBtn.tag-10000] objectForKey:@"PUSH"]];
    NSString *idxStr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:tempBtn.tag-10000] objectForKey:@"IDX"]];
    
    NSLog(@"test160302_001 -- %@,,%@",pushCheckYN,idxStr);
    
    if ([pushCheckYN isEqualToString:@"N"]) {
        [self connectToServer_pushCheck:@"Y" idxData:idxStr];
    }else {
        [self connectToServer_pushCheck:@"N" idxData:idxStr];
    }
}

- (IBAction)mainCheckBtnPress:(id)sender {
    
    UIButton *tempBtn = (UIButton *)sender;
    
    NSString *pushCheckYN = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:tempBtn.tag-100000] objectForKey:@"MAIN2"]];
    NSString *idxStr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:tempBtn.tag-100000] objectForKey:@"IDX"]];
    
    mainDomID = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:tempBtn.tag-100000] objectForKey:@"DOMAIN_ID"]];
    
    if (![pushCheckYN isEqualToString:@"Y"]) {
        if ([ssoKey isEqualToString:@""] || !ssoKey) {
            [self connectToServer_mainCheck2:idxStr];
        }else {
            change_mainSchool_AlertInt = idxStr;
            
            change_mainSchool_AlertView = [[UIAlertView alloc] initWithTitle:@"기본학급 변경하기"
                                                                     message:@"기본학급 변경시 재로그인이 필요합니다."
                                                                    delegate:self
                                                           cancelButtonTitle:@"취소"
                                                           otherButtonTitles:@"확인" , nil];
            [change_mainSchool_AlertView show];
        }
//        [self connectToServer_mainCheck:idxStr];
    }else {
        // 이미 대표 학교임
    }
}

- (IBAction)clubAlertShowBtnPress:(id)sender {
    
    BOOL cs_self_YN;
    if (CS_YorN) {
        cs_self_YN = YES;
    }else {
        cs_self_YN = NO;
    }
    
    CS_YorN = YES;
    
    UIButton *tempBtn = (UIButton *)sender;
    
    NSLog(@"test clubAlertShowBtnPress!! %ld",tempBtn.tag-100000);
    NSLog(@"test clubAlertShowBtnPress!! %d",[tempBtn.titleLabel.text intValue]);
    
    int custom_indexRow = (int)tempBtn.tag-100000;
    int custom_indexSection = [tempBtn.titleLabel.text intValue];
    NSIndexPath *cutom_indexPath = [NSIndexPath indexPathForRow:custom_indexRow inSection:custom_indexSection];
    
    CS_indexPath = [[NSIndexPath alloc] init];
    CS_indexPath = cutom_indexPath;
    
    if (![[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:cutom_indexPath.section] objectForKey:@"CLASSNM"] isEqualToString:@""]) {
        NSLog(@"test clubAlertShow  yes!!");
        
        
        if (![cutom_indexPath isEqual:selectIndex_subTL] || !cs_self_YN) {
            if (selectIndex_subTL) {
                isOpen_subTL = NO;
                [self didSelectCellRowFirstDo2:NO nextDo:NO];
                selectIndex_subTL = nil;
                
            }
//        }else if([cutom_indexPath isEqual:selectIndex_subTL] && isOpen_subTL) {
//            isOpen_subTL = NO;
//            [self didSelectCellRowFirstDo2:NO nextDo:NO];
//            selectIndex_subTL = nil;
//        }
        
            CS_detailArray = [[NSMutableArray alloc] init];
            
//            NSString *bbsStr = [[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:cutom_indexPath.section] objectForKey:@"BBS"];
//            NSArray * bbsArray = [bbsStr componentsSeparatedByString:@","];
//            
//            for (int i = 0; i < [bbsArray count]; i++) {
//                NSArray *detail_bbsArray = [[bbsArray objectAtIndex:i] componentsSeparatedByString:@"|"];
//                if ([[detail_bbsArray objectAtIndex:2] isEqualToString:@"C"]) {
//                    [CS_detailArray addObject:[bbsArray objectAtIndex:i]];
//                }
//            }
            
            NSArray * bbsArray = [[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:cutom_indexPath.section] objectForKey:@"BBS"];
            
            for (int i = 0; i < [bbsArray count]; i++) {
                if (CS_YorN) {
                    if ([[[bbsArray objectAtIndex:i] objectForKey:@"GROUP"] isEqualToString:@"C"]) {
                        [CS_detailArray addObject:[bbsArray objectAtIndex:i]];
                    }
                }else {
                    if ([[[bbsArray objectAtIndex:i] objectForKey:@"GROUP"] isEqualToString:@"S"]) {
                        [CS_detailArray addObject:[bbsArray objectAtIndex:i]];
                    }
                }
            }
            
            NSLog(@"test clubAlertShowBtnPress!!1234 %@",CS_detailArray);
            
            if (cutom_indexPath.row == 0) {
                
                NSLog(@"test1234 -- kkk 0000");
                
                if ([cutom_indexPath isEqual:selectIndex_subTL]) {
                    isOpen_subTL = NO;
                    [self didSelectCellRowFirstDo2:NO nextDo:NO];
                    selectIndex_subTL = nil;
                    
                }else
                {
                    if (!selectIndex_subTL) {
                        selectIndex_subTL = cutom_indexPath;
                        [self didSelectCellRowFirstDo2:YES nextDo:NO];
                        
                    }else
                    {
                        
                        [self didSelectCellRowFirstDo2:NO nextDo:YES];
                    }
                }
                
            }else
            {
                NSLog(@"test1234 -- kkk 33333");
                
                
            
            }
        

            [self.setting_tableView deselectRowAtIndexPath:cutom_indexPath animated:YES];

        }else if([cutom_indexPath isEqual:selectIndex_subTL] && isOpen_subTL) {
            isOpen_subTL = NO;
            [self didSelectCellRowFirstDo2:NO nextDo:NO];
            selectIndex_subTL = nil;
        }
        
    }else {
        NSLog(@"test clubAlertShow  no!!");
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림"
                                                            message:@"학반 정보가 없습니다."
                                                           delegate:self
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil , nil];
        [alertView show];
    
    }
}

- (IBAction)defaultAlertShowBtnPress:(id)sender {
    
    BOOL cs_self_YN;
    if (!CS_YorN) {
        cs_self_YN = YES;
    }else {
        cs_self_YN = NO;
    }
    
    CS_YorN = NO;
    
    UIButton *tempBtn = (UIButton *)sender;
    
    NSLog(@"test clubAlertShowBtnPress!!3333 %ld",tempBtn.tag-100000);
    NSLog(@"test clubAlertShowBtnPress!!3333 %d",[tempBtn.titleLabel.text intValue]);
    
    int custom_indexRow = (int)tempBtn.tag-100000;
    int custom_indexSection = [tempBtn.titleLabel.text intValue];
    NSIndexPath *cutom_indexPath = [NSIndexPath indexPathForRow:custom_indexRow inSection:custom_indexSection];
    
    CS_indexPath = [[NSIndexPath alloc] init];
    CS_indexPath = cutom_indexPath;
    
    if (![cutom_indexPath isEqual:selectIndex_subTL] || !cs_self_YN) {
        if (selectIndex_subTL) {
            isOpen_subTL = NO;
            [self didSelectCellRowFirstDo2:NO nextDo:NO];
            selectIndex_subTL = nil;
            
        }
//    }else if([cutom_indexPath isEqual:selectIndex_subTL] && isOpen_subTL) {
//        isOpen_subTL = NO;
//        [self didSelectCellRowFirstDo2:NO nextDo:NO];
//        selectIndex_subTL = nil;
//    }
    
        CS_detailArray = [[NSMutableArray alloc] init];
        
//        NSString *bbsStr = [[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:cutom_indexPath.section] objectForKey:@"BBS"];
//        NSArray * bbsArray = [bbsStr componentsSeparatedByString:@","];
//        
//        for (int i = 0; i < [bbsArray count]; i++) {
//            NSArray *detail_bbsArray = [[bbsArray objectAtIndex:i] componentsSeparatedByString:@"|"];
//            if ([[detail_bbsArray objectAtIndex:2] isEqualToString:@"S"]) {
//                [CS_detailArray addObject:[bbsArray objectAtIndex:i]];
//            }
//        }
        
        NSArray * bbsArray = [[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:cutom_indexPath.section] objectForKey:@"BBS"];
        
        for (int i = 0; i < [bbsArray count]; i++) {
            if ([[[bbsArray objectAtIndex:i] objectForKey:@"GROUP"] isEqualToString:@"S"]) {
                [CS_detailArray addObject:[bbsArray objectAtIndex:i]];
            }
        }
        
        
        NSLog(@"test clubAlertShowBtnPress!! %@",CS_detailArray);

        
        if (cutom_indexPath.row == 0) {
            
            NSLog(@"test1234 -- kkk 0000");
            
            if ([cutom_indexPath isEqual:selectIndex_subTL]) {
                isOpen_subTL = NO;
                [self didSelectCellRowFirstDo2:NO nextDo:NO];
                selectIndex_subTL = nil;
                
            }else
            {
                
                if (!selectIndex_subTL) {
                    selectIndex_subTL = cutom_indexPath;
                    [self didSelectCellRowFirstDo2:YES nextDo:NO];
                    
                }else
                {
                    
                    [self didSelectCellRowFirstDo2:NO nextDo:YES];
                }
            }
            
        }else
        {
            NSLog(@"test1234 -- kkk 33333");
            
            
        }
        [self.setting_tableView deselectRowAtIndexPath:cutom_indexPath animated:YES];

    }else if([cutom_indexPath isEqual:selectIndex_subTL] && isOpen_subTL) {
        isOpen_subTL = NO;
        [self didSelectCellRowFirstDo2:NO nextDo:NO];
        selectIndex_subTL = nil;
    }

    
}

- (IBAction)cell2_alramBtnPress:(id)sender {
    
    UIButton *tempBtn = (UIButton *)sender;
    
    NSLog(@"test alram Tap!! %ld",(long)tempBtn.tag);
    
    int custom_indexRow = (int)tempBtn.tag-10000;
    int custom_indexSection = [tempBtn.titleLabel.text intValue];
    NSIndexPath *cutom_indexPath = [NSIndexPath indexPathForRow:custom_indexRow inSection:custom_indexSection];
    
    NSString *domainStr = [NSString stringWithFormat:@"%@",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:cutom_indexPath.section] objectForKey:@"DOMAIN_ID"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
//    NSArray *cell2_bbsArray = [[CS_detailArray objectAtIndex:cutom_indexPath.row-1] componentsSeparatedByString:@"|"];
//    NSString *bbsStr = [cell2_bbsArray objectAtIndex:1];
//    NSString *valStr = [cell2_bbsArray objectAtIndex:3];
    
    NSString *bbsStr = [[CS_detailArray objectAtIndex:cutom_indexPath.row-1] objectForKey:@"MOB_MCD"];
    NSString *valStr = [[CS_detailArray objectAtIndex:cutom_indexPath.row-1] objectForKey:@"ISUSE"];
    NSString *groupStr = [[CS_detailArray objectAtIndex:cutom_indexPath.row-1] objectForKey:@"GROUP"];
    
    NSString *infoIdStr = @"";
    infoIdStr = [NSString stringWithFormat:@"%@",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:cutom_indexPath.section] objectForKey:@"INFO_ID"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if ([valStr isEqualToString:@"Y"]) {
        [self connectToServer_alramSetting:domainStr bbsData:bbsStr valData:@"N" infoIdData:infoIdStr groupData:groupStr];
    }else {
        [self connectToServer_alramSetting:domainStr bbsData:bbsStr valData:@"Y" infoIdData:infoIdStr groupData:groupStr];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////


- (IBAction)main_tabBtn:(id)sender {
    UIButton *tempBtn = (UIButton *)sender;
    
    [self.push_showView setHidden:YES];
    
    push_login_ingYN = NO;
    tab2btn_selectYN = NO;
    tab2btn_login_selectYN = NO;
    
    if (tempBtn.tag == 11) {
        settingAction_webViewYN = NO;
        
        [self.sos_loginView setHidden:YES];
        
        [self.main_homeView setHidden:NO];
        [self.main_sosView setHidden:YES];
        [self.main_schoolSettingView setHidden:YES];
        [self.main_guideView setHidden:YES];
        
        [self.main_searchView setHidden:YES];
        [self.main_changeView setHidden:YES];
        
//        [self webViewForwardBackBtnOutletSetEnabled:YES selectBtn:self.main_tabBackBtnOutlet imageNameStr:@"bt_menuBack_on"];
//        [self webViewForwardBackBtnOutletSetEnabled:YES selectBtn:self.main_tabForwardBtnOutlet imageNameStr:@"bt_menuForward_on"];
        
        [self.main_tabOutlet_1 setBackgroundImage:[UIImage imageNamed:@"bt_menu01_on"] forState:UIControlStateNormal];
        [self.main_tabOutlet_2 setBackgroundImage:[UIImage imageNamed:@"bt_menu02"] forState:UIControlStateNormal];
        [self.main_tabOutlet_3 setBackgroundImage:[UIImage imageNamed:@"bt_menu03"] forState:UIControlStateNormal];
        [self.main_tabOutlet_4 setBackgroundImage:[UIImage imageNamed:@"bt_menu04"] forState:UIControlStateNormal];
        
        [self connectToServer_mySchoolList];
        
    }else if (tempBtn.tag == 12) {
//        [self.main_homeView setHidden:YES];
//        [self.main_sosView setHidden:NO];
//        [self.main_schoolSettingView setHidden:YES];
//        [self.main_guideView setHidden:YES];
//        
//        [self.main_searchView setHidden:YES];
//        [self.main_changeView setHidden:YES];
//        
//        [self.home_offView setHidden:YES];
//        
//        [self.main_tabOutlet_1 setBackgroundImage:[UIImage imageNamed:@"bt_menu01"] forState:UIControlStateNormal];
//        [self.main_tabOutlet_2 setBackgroundImage:[UIImage imageNamed:@"bt_menu02_on"] forState:UIControlStateNormal];
//        [self.main_tabOutlet_3 setBackgroundImage:[UIImage imageNamed:@"bt_menu03"] forState:UIControlStateNormal];
//        [self.main_tabOutlet_4 setBackgroundImage:[UIImage imageNamed:@"bt_menu04"] forState:UIControlStateNormal];
//        
////        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
////        if ([[defaults objectForKey:@"autoLoginYN"] isEqualToString:@"Y"]) {
////            
////            aes_idStr = [defaults objectForKey:@"aes_idStr"];
////            aes_pwStr = [defaults objectForKey:@"aes_pwStr"];
////            
////            // 자동로그인
//////            [self connectToServer_login:aes_idStr pwDataStr:aes_pwStr];
////        }else {
////            [self.sos_loginView setHidden:NO];
////        }
//        if ([ssoKey isEqualToString:@""] || !ssoKey) {
//            [self.sos_loginView setHidden:NO];
//        }else {
//            [self.sos_loginView setHidden:YES];
//        }
        
        tab2btn_selectYN = YES;
        tab2btn_login_selectYN = YES;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *guestDomainStr = [NSString stringWithFormat:@"%@||",[defaults objectForKey:@"sq_mainDOMID"]];
        guestArrayStr = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"guestAddStr"]];
        NSRange strRange_searchDomain = [guestArrayStr rangeOfString:guestDomainStr];
//        if (strRange_searchDomain.location != NSNotFound){
//            UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"학교폭력신고"
//                                                                message:@"일반사용자는 사용할 수 없습니다."
//                                                               delegate:self
//                                                      cancelButtonTitle:@"확인"
//                                                      otherButtonTitles:nil , nil];
//            [errorView show];
//        }else {
//            [self getMappingInfo];
//        }
        
        [self getMappingInfo];
        
    }else if (tempBtn.tag == 13) {
        
        [self.sos_loginView setHidden:YES];
        
        [self.main_homeView setHidden:YES];
        [self.main_sosView setHidden:YES];
        [self.main_schoolSettingView setHidden:NO];
        [self.main_guideView setHidden:YES];
        
        [self.main_searchView setHidden:YES];
        [self.main_changeView setHidden:YES];
        
        [self webViewForwardBackBtnOutletSetEnabled:NO selectBtn:self.main_tabBackBtnOutlet imageNameStr:@"bt_menuBack_off"];
        [self webViewForwardBackBtnOutletSetEnabled:NO selectBtn:self.main_tabForwardBtnOutlet imageNameStr:@"bt_menuForward_off"];
        
        [self.main_tabOutlet_1 setBackgroundImage:[UIImage imageNamed:@"bt_menu01"] forState:UIControlStateNormal];
        [self.main_tabOutlet_2 setBackgroundImage:[UIImage imageNamed:@"bt_menu02"] forState:UIControlStateNormal];
        [self.main_tabOutlet_3 setBackgroundImage:[UIImage imageNamed:@"bt_menu03_on"] forState:UIControlStateNormal];
        [self.main_tabOutlet_4 setBackgroundImage:[UIImage imageNamed:@"bt_menu04"] forState:UIControlStateNormal];
        
        [self connectToServer_mySchoolList];
        
    }else if (tempBtn.tag == 14) {
        
        [self.sos_loginView setHidden:YES];
        
        [self.main_homeView setHidden:YES];
        [self.main_sosView setHidden:YES];
        [self.main_schoolSettingView setHidden:YES];
        [self.main_guideView setHidden:NO];
        
        [self.main_searchView setHidden:YES];
        [self.main_changeView setHidden:YES];
        
        [self.home_offView setHidden:YES];
        
        [self webViewForwardBackBtnOutletSetEnabled:NO selectBtn:self.main_tabBackBtnOutlet imageNameStr:@"bt_menuBack_off"];
        [self webViewForwardBackBtnOutletSetEnabled:NO selectBtn:self.main_tabForwardBtnOutlet imageNameStr:@"bt_menuForward_off"];
        
        [self.main_tabOutlet_1 setBackgroundImage:[UIImage imageNamed:@"bt_menu01"] forState:UIControlStateNormal];
        [self.main_tabOutlet_2 setBackgroundImage:[UIImage imageNamed:@"bt_menu02"] forState:UIControlStateNormal];
        [self.main_tabOutlet_3 setBackgroundImage:[UIImage imageNamed:@"bt_menu03"] forState:UIControlStateNormal];
        [self.main_tabOutlet_4 setBackgroundImage:[UIImage imageNamed:@"bt_menu04_on"] forState:UIControlStateNormal];
        
    }
}

- (IBAction)home_schoolChangeBtn:(id)sender {
    // 학급변경
    
//    [self connectToServer_clubList:changeDomStr];
//    [self.main_changeView setHidden:NO];
}

- (IBAction)home_schoolAddBtn:(id)sender {
    // 학교추가 + 학교검색
    
    schoolSearch_news = nil;
    [self.search_tableView reloadData];
    [self.search_searchBar setText:nil];
    [self.main_searchView setHidden:NO];
}

- (IBAction)sos_signOutBtn:(id)sender
{
    // 로그아웃
    [self connectToServer_logout];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:@"" forKey:@"aes_idStr"];
//    [defaults setObject:@"" forKey:@"aes_pwStr"];
//    
//    [defaults setObject:@"N" forKey:@"autoLoginYN"];
//    [defaults synchronize];
//
//    [self.sos_loginView setHidden:NO];
}

- (IBAction)sos_fileAddBtn:(id)sender {
    // 학교폭력 파일추가 (동영상/사진)
    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"앨범에서 사진 선택", @"사진 촬영", @"동영상 촬영", nil];
//    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//    [actionSheet setIsAccessibilityElement:YES];
//    [actionSheet setAccessibilityLabel:@"첨부파일 형태 선택"];
//    [actionSheet setAccessibilityHint:@"첨부파일 형태 선택하십시오"];
//    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
    if (isPic || isVideo) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"한개의 파일만 첨부가능하며, 계속 첨부하시면 이전 첨부파일은 삭제됩니다." delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"앨범에서 사진 선택", @"사진 촬영", @"동영상 촬영", @"기존 삭제", nil];
        [actionSheet setIsAccessibilityElement:YES];
        [actionSheet setAccessibilityLabel:@"첨부파일 형태 선택"];
        [actionSheet setAccessibilityHint:@"첨부파일 형태 선택하십시오"];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"앨범에서 사진 선택", @"사진 촬영", @"동영상 촬영", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet setIsAccessibilityElement:YES];
        [actionSheet setAccessibilityLabel:@"첨부파일 형태 선택"];
        [actionSheet setAccessibilityHint:@"첨부파일 형태 선택하십시오"];
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
    
}

- (IBAction)sos_sendBtn:(id)sender {
    // 학교폭력 신고하기
//    [self.sos_sosView setHidden:YES];
    if ([self.sos_titleTextField.text isEqualToString:@""] || [self.sos_titleTextField.text isEqualToString:@""]) {
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"학교폭력신고"
                                                            message:@"제목/내용을 입력해 주세요."
                                                           delegate:self
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil , nil];
        [errorView show];
    }else {
        [self writeAct];
    }
}

- (IBAction)sos_reWriteBtn:(id)sender {
    [self.sos_titleTextField setText:nil];
    [self.sos_contentsTextView setText:nil];
    picView = nil;
    
    isVideo = NO;
    isPic = NO;
    
    [self.fileNumberLabel setText:@"(0)"];
    
}

- (IBAction)sos_autoLoginBtn:(id)sender
{
    // 자동로그인
    if (autoLoginYN)
    {
        [self.sos_autoLoginCheckImageView setImage:[UIImage imageNamed:@"check_none"]];
        autoLoginYN = NO;
//        NSLog(@"자동 로그인 OFF");
    }
    else
    {
        [self.sos_autoLoginCheckImageView setImage:[UIImage imageNamed:@"check_check"]];
        autoLoginYN = YES;
//        NSLog(@"자동 로그인 ON");
    }
}

- (IBAction)sos_loginBtn:(id)sender
{
    NSLog(@"로그인 버튼 눌림!!");
    
    if(changeMainHomeURLStr == nil)
    {
        [[[UIAlertView alloc] initWithTitle:@"알림"
                                    message:@"학교가 선택되지 않았습니다."
                                   delegate:nil
                          cancelButtonTitle:@"확인"
                          otherButtonTitles:nil, nil] show];
        return;
    }
    
    // 로그인
    [self.sos_loginIdTextField resignFirstResponder];
    [self.sos_loginPwTextField resignFirstResponder];
    
    if ([self.sos_loginIdTextField.text isEqualToString:@""] || [self.sos_loginPwTextField.text isEqualToString:@""])
    {
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle:@"로그인"
                                                            message:@"아이디/암호를 정확하게 입력해주세요."
                                                           delegate:self
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil , nil];
        [errorView show];
    }
    else
    {
        NSString *pwdStr;
        
        //암호화 사용할때..
        if(kUseLoginEncrypt != 0)
        {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            pwdStr = [userDefault objectForKey:@"auto_pwStr"];
            
            //이전에 저장된 비밀번호가 없거나, 사용자가 비밀번호를 다시 입력했을경우...
            if(pwdStr == nil || didNewInputPwd == YES)
            {
                pwdStr = [self createSHA256:self.sos_loginPwTextField.text];
                didNewInputPwd = NO;
            }
            
            self.sha256Pwd = pwdStr;
        }
        else
            pwdStr = self.sos_loginPwTextField.text;

        NSLog(@"로그인 sha256Pwd : %@",self.sha256Pwd);
        
        [self connectToServer_login:self.sos_loginIdTextField.text pwDataStr:pwdStr];
    }
}

- (IBAction)setting_schoolAddBtn:(id)sender {
    // 학교추가 + 학교검색
    
    schoolSearch_news = nil;
    [self.search_tableView reloadData];
    [self.search_searchBar setText:nil];
    [self.main_searchView setHidden:NO];
}

- (IBAction)search_searchBtn:(id)sender {
    // 학교검색
    if (![self.search_searchBar.text isEqualToString:@""]) {
        [self.search_searchBar resignFirstResponder];
        [self connectToServer_schoolSearch];
    }
}

- (IBAction)mainClubNoBtn:(id)sender {
    [self.main_homeView setHidden:YES];
    [self.main_sosView setHidden:YES];
    [self.main_schoolSettingView setHidden:NO];
    [self.main_guideView setHidden:YES];
    
    [self.main_searchView setHidden:YES];
    [self.main_changeView setHidden:YES];
    
    [self.main_tabOutlet_1 setBackgroundImage:[UIImage imageNamed:@"bt_menu01"] forState:UIControlStateNormal];
    [self.main_tabOutlet_2 setBackgroundImage:[UIImage imageNamed:@"bt_menu02"] forState:UIControlStateNormal];
    [self.main_tabOutlet_3 setBackgroundImage:[UIImage imageNamed:@"bt_menu03_on"] forState:UIControlStateNormal];
    [self.main_tabOutlet_4 setBackgroundImage:[UIImage imageNamed:@"bt_menu04"] forState:UIControlStateNormal];
    
    [self connectToServer_mySchoolList];
}

- (IBAction)search_backBtn:(id)sender {
    [self.main_searchView setHidden:YES];
    [self.view endEditing:TRUE];
}

- (IBAction)change_backBtn:(id)sender {
    [self.main_changeView setHidden:YES];
}

- (IBAction)change_passClubBtn:(id)sender {
    NSLog(@"test pass club btn -- %@" , in_schoolChangeArray);
    
    NSString *domainStr = @"";
    NSString *sidStr = @"";
    NSString *infoStr = @"";
    
    domainStr = [[in_schoolChangeArray objectAtIndex:0] objectForKey:@"DOMAIN_ID"];

//    noValue_mySchool_idxStr = [NSString stringWithFormat:@"%@",[[in_schoolChangeArray objectAtIndex:0] objectForKey:@"IDX"]];
    
    [self connectToServer_schoolAdd:domainStr sidData:sidStr infoData:infoStr];
}

- (IBAction)textView_downBtn:(id)sender {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationsEnabled:YES];
    
//    [self.textView_downView setFrame:CGRectMake(0, 568, 320, 40)];
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (iOSDeviceScreenSize.height == 480) {
        [self.textView_downView setFrame:CGRectMake(0, 480, 320, 40)];
    }else { //if (iOSDeviceScreenSize.height == 568) {
        [self.textView_downView setFrame:CGRectMake(0, 568, 320, 40)];
    }
    
    [UIView commitAnimations];
    
    [self.sos_contentsTextView resignFirstResponder];
}




//////////////////////////////////////////////////////////////////////////////////////////////////////////////


//-(IBAction)addFileButton:(id)sender {
//    if (isPic || isVideo) {
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"한개의 파일만 첨부가능하며, 계속 첨부하시면 이전 첨부파일은 삭제됩니다." delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"앨범에서 사진 선택", @"사진 촬영", @"동영상 촬영", @"기존 삭제", nil];
//        [actionSheet setIsAccessibilityElement:YES];
//        [actionSheet setAccessibilityLabel:@"첨부파일 형태 선택"];
//        [actionSheet setAccessibilityHint:@"첨부파일 형태 선택하십시오"];
//        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//        [actionSheet showFromTabBar:self.tabBarController.tabBar];
//
//    } else {
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"앨범에서 사진 선택", @"사진 촬영", @"동영상 촬영", nil];
//        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
//        [actionSheet setIsAccessibilityElement:YES];
//        [actionSheet setAccessibilityLabel:@"첨부파일 형태 선택"];
//        [actionSheet setAccessibilityHint:@"첨부파일 형태 선택하십시오"];
//        [actionSheet showFromTabBar:self.tabBarController.tabBar];
//
//    }
//}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex == 0) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.sourceType = sourceType;
            picker.delegate = self;
            //[picker setAllowsEditing:YES];
            [self presentViewController:picker animated:YES completion:nil];
//            [picker release];
            
            isVideo = NO;
            isPic = NO;
//            UIImageView *temp_image = (UIImageView *)[self.scrollview viewWithTag:2001];
//            temp_image.image = [UIImage imageNamed:@""];
            [self.fileNumberLabel setText:@"(0)"];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"현재기기는 사용할 수 없습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView.title setIsAccessibilityElement:YES];
            [alertView.title setAccessibilityLabel:@"알림"];
            
            [alertView.message setIsAccessibilityElement:YES];
            [alertView.message setAccessibilityLabel:@"현재기기는 사용할 수 없습니다."];
            alertView.tag = 1000;
            [alertView show];
//            [alertView release];
        }
    } else if(buttonIndex == 1) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypeCamera;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.sourceType = sourceType;
            picker.delegate = self;
            //[picker setAllowsEditing:YES];
            [self presentViewController:picker animated:YES completion:nil];
//            [picker release];
            
            isVideo = NO;
            isPic = NO;
//            UIImageView *temp_image = (UIImageView *)[self.scrollview viewWithTag:2001];
//            temp_image.image = [UIImage imageNamed:@""];
            [self.fileNumberLabel setText:@"(0)"];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"현재기기는 사용할 수 없습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView.title setIsAccessibilityElement:YES];
            [alertView.title setAccessibilityLabel:@"알림"];
            
            [alertView.message setIsAccessibilityElement:YES];
            [alertView.message setAccessibilityLabel:@"현재기기는 사용할 수 없습니다."];
            alertView.tag = 1000;
            [alertView show];
//            [alertView release];
        }
    } else if(buttonIndex == 2) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypeCamera;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.videoQuality = UIImagePickerControllerQualityTypeLow;
            picker.sourceType = sourceType;
            picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
            
            picker.delegate = self;
            //[picker setAllowsEditing:YES];
            [self presentViewController:picker animated:YES completion:nil];
//            [picker release];
            
            isVideo = NO;
            isPic = NO;
//            UIImageView *temp_image = (UIImageView *)[self.scrollview viewWithTag:2001];
//            temp_image.image = [UIImage imageNamed:@""];
            [self.fileNumberLabel setText:@"(0)"];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"알림" message:@"현재기기는 사용할 수 없습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView.title setIsAccessibilityElement:YES];
            [alertView.title setAccessibilityLabel:@"알림"];
            
            [alertView.message setIsAccessibilityElement:YES];
            [alertView.message setAccessibilityLabel:@"현재기기는 사용할 수 없습니다."];
            alertView.tag = 1000;
            [alertView show];
//            [alertView release];
        }
    }  else if(buttonIndex == 3) {
        isVideo = NO;
        isPic = NO;
//        UIImageView *temp_image = (UIImageView *)[self.scrollview viewWithTag:2001];
//        temp_image.image = [UIImage imageNamed:@""];
        [self.fileNumberLabel setText:@"(0)"];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark -
#pragma mark UIImagePickerController

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    // Handle a movie capture
    if (CFStringCompare (( CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        
        //NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        
        
        
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        //NSData *picData = [NSData dataWithContentsOfFile:[videoURL path]];
        NSData *webData = [NSData dataWithContentsOfURL:videoURL];
        if (vData==nil) {
            vData = [[NSData alloc] initWithContentsOfURL:videoURL];
        } else {
            vData = [NSData dataWithContentsOfURL:videoURL];
        }
        
        [webData writeToFile:[self dataFilPath:@"test.MOV"]  atomically:YES];
        
        
        video_url = [[NSString alloc] initWithFormat:@"%@",[self dataFilPath:@"test.MOV"]];
        
        
        
//        UIImageView *temp_image = (UIImageView *)[self.scrollview viewWithTag:2001];
//        temp_image.image = [UIImage imageNamed:@"btn_pmicon01.png"];
        [self.fileNumberLabel setText:@"(1)"];
        
        isVideo = YES;
        isPic = NO;
        [self sendVideo];
    } else {
        UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (picView==nil) {
            
            picView = [[UIImageView alloc] initWithImage:pickedImage];
        } else {
            
            picView.image = pickedImage;
        }
        
        //[self setLogin];
        isPic = YES;
        isVideo = NO;
        
//        UIImageView *temp_image = (UIImageView *)[self.scrollview viewWithTag:2001];
//        temp_image.image = [UIImage imageNamed:@"btn_pmicon02.png"];
        [self.fileNumberLabel setText:@"(1)"];
        
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    isPic = NO;
    isVideo = NO;
//    UIImageView *temp_image = (UIImageView *)[self.scrollview viewWithTag:2001];
//    temp_image.image = [UIImage imageNamed:@""];
    [self.fileNumberLabel setText:@"(0)"];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Set Data
-(NSString *) dataFilPath:(NSString *)fileName {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [docDir stringByAppendingPathComponent:fileName];
    return plistPath;
}
-(NSData *)passData:(NSDictionary *)list {
    NSString *err = nil;
    NSData *plist;
    plist = [NSPropertyListSerialization dataFromPropertyList:list format:NSPropertyListBinaryFormat_v1_0 errorDescription:&err];
    return plist;
}

-(void) writeAct {
    
    [self.indicator_view startAnimating];
    
    [self.indicator_view setHidden:NO];
    [self.indicator_bgBtnOutlet setHidden:NO];
    
    NSString *boundary = @"0xKhTmLbOuNdArY";
//    NSString *url_str = [NSString stringWithFormat:@"http://sch.dge.go.kr/board/openapi/writeAct.do?dataSecret=true"];
//    NSString *url_str = [NSString stringWithFormat:@"http://118.219.7.120/board/openapi/writeAct.do?dataSecret=true"];
    
//    NSString *url_str = [NSString stringWithFormat:@"http://sch.dge.go.kr/board/openapi/writeAct.do?dataSecret=true&ssoKey=%@",test_ssoKey];
    NSString *url_str = [NSString stringWithFormat:@"http://118.219.7.120/board/openapi/writeAct.do?dataSecret=true"];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]init];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    domainId = [defaults objectForKey:@"sq_mainDOMID"];
    
    url_str = [url_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    boardId = [boardId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    menuCd = [menuCd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    domainId = [domainId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    ssoKey = [ssoKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSLog(@"test12501051050 0 -- test_ssoKey = %@",test_ssoKey);
    NSLog(@"test12501051050 0 -- test_ssoKey = %@",ssoKey);
    NSLog(@"test12501051050 0 -- test_나머지 = %@,,%@,,%@",boardId,menuCd,url_str);
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.dimBackground = YES;
//    hud.labelText = @"Loading..";
    
    
    [urlRequest setURL:[NSURL URLWithString:url_str]];
    [urlRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [urlRequest setHTTPMethod:@"POST"];
    
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [urlRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSMutableData *body = [[NSMutableData alloc] init];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"boardId\"\r\n\r\n%@",boardId] dataUsingEncoding:NSUTF8StringEncoding] ];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // mutId (2018.01.02 추가)
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"mutId\"\r\n\r\n%@",menuCd] dataUsingEncoding:NSUTF8StringEncoding] ];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // menuCd
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"menuCd\"\r\n\r\n%@",menuCd] dataUsingEncoding:NSUTF8StringEncoding] ];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // domainId
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"domainId\"\r\n\r\n%@",domainId] dataUsingEncoding:NSUTF8StringEncoding] ];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"domainId\"\r\n\r\n%@",@"DOM_0000118"] dataUsingEncoding:NSUTF8StringEncoding] ];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // session key
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"ssoKey\"\r\n\r\n%@",ssoKey] dataUsingEncoding:NSUTF8StringEncoding] ];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // session key
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"command\"\r\n\r\nwrite"] dataUsingEncoding:NSUTF8StringEncoding] ];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // subject
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"dataTitle\"\r\n\r\n%@",titleView.text] dataUsingEncoding:NSUTF8StringEncoding] ];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"dataTitle\"\r\n\r\n%@",self.sos_titleTextField.text] dataUsingEncoding:NSUTF8StringEncoding] ];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // content
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"dataContent\"\r\n\r\n%@",contentView.text] dataUsingEncoding:NSUTF8StringEncoding] ];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"dataContent\"\r\n\r\n%@",self.sos_contentsTextView.text] dataUsingEncoding:NSUTF8StringEncoding] ];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // restMode
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"restMode\"\r\n\r\njson"] dataUsingEncoding:NSUTF8StringEncoding] ];
    
    
    NSLog(@"test 글쓰기 필요 정보 \n %@\n %@\n %@\n %@",boardId,menuCd,domainId,domainNm);
    
    if (isPic) {
        int timestamp = [[NSDate date] timeIntervalSince1970];
        NSString *nStr = [NSString stringWithFormat:@"%d",timestamp];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload\"; filename=\"%@.jpg\"\r\n",nStr] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\ffff677 \r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:UIImageJPEGRepresentation(picView.image, 100)];
        
        NSLog(@"test160302_002 -- %d",timestamp);
    } else if(isVideo) {
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        // mobileUrlPath
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;name=\"mobileUrlPath\"\r\n\r\n%@",mobileUrlPath] dataUsingEncoding:NSUTF8StringEncoding] ];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        // mobileMovFile
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;name=\"mobileMovFile\"\r\n\r\n%@",mobileMovFile] dataUsingEncoding:NSUTF8StringEncoding] ];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        // mobileThumbFile
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"mobileThumbFile\"\r\n\r\n%@",mobileThumbFile] dataUsingEncoding:NSUTF8StringEncoding] ];
        
        NSLog(@"test 동영상 업로드 값 - %@,,%@,,%@",mobileUrlPath,mobileMovFile,mobileThumbFile);
    }
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [urlRequest setHTTPBody:body];
    
    sendConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    if (sendConnection) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        sendData = [NSMutableData data];
    }
    
    NSLog(@"test 동여상 업로드 URL - %@",urlRequest);
}

-(void) getMappingInfo {
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    HUD.dimBackground = YES;
    //    hud.labelText = @"Loading..";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *domIDstr = [defaults objectForKey:@"sq_mainDOMID"];
    
    NSLog(@"test 맵핑시 도메인 URL : %@",domIDstr);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://118.219.7.120/board/openapi/mappingInfo.do?domainId=%@&mobMcd=c_force&restMode=json", domIDstr]];
    
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://210.206.69.183/board/openapi/mappingInfo.do?domainId=%@&mobMcd=c_force&restMode=json", domainId]];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    getConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (getConnection) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        getData = [NSMutableData data];
    }
    NSLog(@"test 맵핑시 도메인 URL : %@",url);
}

-(void) getMappingInfo:(NSString *)domainIDstr {
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    HUD.dimBackground = YES;
    //    hud.labelText = @"Loading..";
    
    
    NSLog(@"test push 맵핑시 도메인 URL : %@",domainIDstr);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://118.219.7.120/board/openapi/mappingInfo.do?domainId=%@&mobMcd=c_force&restMode=json", domainIDstr]];
    
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://210.206.69.183/board/openapi/mappingInfo.do?domainId=%@&mobMcd=c_force&restMode=json", domainId]];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    getConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (getConnection) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        getData = [NSMutableData data];
    }
    
    NSLog(@"test 맵핑시 도메인 URL : %@",url);
}


-(void) sendVideo {
    
    [self.indicator_view startAnimating];
    
    [self.indicator_view setHidden:NO];
    [self.indicator_bgBtnOutlet setHidden:NO];
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.dimBackground = YES;
//    hud.labelText = @"Loading..";
    
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSString *url_str = [NSString stringWithFormat:@"http://118.219.7.112:81/upload.jsp"];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]init];
    [urlRequest setURL:[NSURL URLWithString:url_str]];
    [urlRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [urlRequest setHTTPMethod:@"POST"];
    
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [urlRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSMutableData *body = [[NSMutableData alloc] init];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding] ];
    
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload\"; filename=\"somefile.MOV\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\ffff677 \r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload\"; filename=\"somefile.MOV\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\ffff677 \r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:vData];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [urlRequest setHTTPBody:body];
    
    videoConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    if (videoConnection) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        self.videoData = [[NSMutableData data] retain];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([reHome_webView canGoBack])
    {
        [self webViewForwardBackBtnOutletSetEnabled:YES selectBtn:self.main_tabBackBtnOutlet imageNameStr:@"bt_menuBack_on"];
    }
    else
    {
        [self webViewForwardBackBtnOutletSetEnabled:NO selectBtn:self.main_tabBackBtnOutlet imageNameStr:@"bt_menuBack_off"];
    }
    if ([reHome_webView canGoForward])
    {
        [self webViewForwardBackBtnOutletSetEnabled:YES selectBtn:self.main_tabForwardBtnOutlet imageNameStr:@"bt_menuForward_on"];
    }
    else
    {
        [self webViewForwardBackBtnOutletSetEnabled:NO selectBtn:self.main_tabForwardBtnOutlet imageNameStr:@"bt_menuForward_off"];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    [webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:@"AppVersionCheck()" waitUntilDone:NO];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@",request.URL];
    
    NSLog(@"test00122233334445555666777 -- %@",requestStr);
    
    //알림장일때...
    NSRange range = [requestStr rangeOfString:@"YCD_000000000000385700"];
    if(range.location != NSNotFound)
    {
        range = [requestStr rangeOfString:@"ssoKey=&"];
        
        if(range.location != NSNotFound)
        {
            if([ssoKey length] > 0)
            {
                NSString *loadTargetUrl = [NSString stringWithFormat:@"http://skoschool.skoinfo.co.kr/user/mobile/board/list.do?mobMcd=e_know&ssoKey=%@&loginPos=app&menuCd=YCD_000000000000385700&uuid=%@",ssoKey,self.userUUID];
                
                [reHome_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadTargetUrl]]];
                
                return NO;
            }
        }
    }
    
    //학급앨범일때...
    range = [requestStr rangeOfString:@"YCD_000000000000385698"];

    if(range.location != NSNotFound)
    {
        range = [requestStr rangeOfString:@"ssoKey=&"];
        
        if(range.location != NSNotFound)
        {
            if([ssoKey length] > 0)
            {
                NSString *loadTargetUrl = [NSString stringWithFormat:@"http://skoschool.skoinfo.co.kr/user/mobile/board/list.do?mobMcd=e_know&ssoKey=%@&loginPos=app&menuCd=YCD_000000000000385698&uuid=%@",ssoKey,self.userUUID];


                [reHome_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadTargetUrl]]];

                return NO;
            }
        }
    }
    
    NSRange strRange_schoolList_WebView = [requestStr rangeOfString:@"schoolList=ok"];
    if (strRange_schoolList_WebView.location != NSNotFound) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://school.dge.go.kr/index.do?loginPos=&schoolList=ok"]];
        
        return NO;
    }
    
    NSRange strRange_pushWebviewClose = [requestStr rangeOfString:@"pushViewClose=ok"];
    if (strRange_pushWebviewClose.location != NSNotFound) {
        
        [self.push_webView stopLoading];
        [self.push_showView setHidden:YES];
        return NO;
    }
    
    NSRange strRange_eventNewBrowser1 = [requestStr rangeOfString:@"http://skoschool.skoinfo.co.kr/board/write.do?boardId=BBS_0000009&menuCd=MCD_000000000000085064&startPage=1"];
    NSRange strRange_eventNewBrowser2 = [requestStr rangeOfString:@"http://skoschool.skoinfo.co.kr/index.do?menuCd=MCD_000000000000085064"];
    if (strRange_eventNewBrowser1.location != NSNotFound || strRange_eventNewBrowser2.location != NSNotFound) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:requestStr]];
        
        return NO;
    }
    
    NSRange strRange_clubchange = [requestStr rangeOfString:@"clubchange=ok"];
    if (strRange_clubchange.location != NSNotFound) {
        
        [loginSuccessAlertView dismissWithClickedButtonIndex:0 animated:YES];
        
        webviewLogoutYN = YES;
        
        [self connectToServer_logout];
        
        [self.push_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        [self.push_showView setHidden:YES];
        
        [self.main_homeView setHidden:YES];
        [self.main_sosView setHidden:YES];
        [self.main_schoolSettingView setHidden:NO];
        [self.main_guideView setHidden:YES];
        
        [self.main_searchView setHidden:YES];
        [self.main_changeView setHidden:YES];
        
        [self.main_tabOutlet_1 setBackgroundImage:[UIImage imageNamed:@"bt_menu01"] forState:UIControlStateNormal];
        [self.main_tabOutlet_2 setBackgroundImage:[UIImage imageNamed:@"bt_menu02"] forState:UIControlStateNormal];
        [self.main_tabOutlet_3 setBackgroundImage:[UIImage imageNamed:@"bt_menu03_on"] forState:UIControlStateNormal];
        [self.main_tabOutlet_4 setBackgroundImage:[UIImage imageNamed:@"bt_menu04"] forState:UIControlStateNormal];
        
        return NO;
    }
    
    NSRange strRange_eventClose = [requestStr rangeOfString:@"mobileeventclose=ok"];
    if (strRange_eventClose.location != NSNotFound) {
        
        if (webView == self.errorWebView) {
            [self.errorWebView setHidden:YES];
        }else if (webView == self.errorWebView_xml) {
            [self.errorWebView_xml setHidden:YES];
        }else {
            eventCloseAlert = [[UIAlertView alloc] initWithTitle:@"이벤트"
                                                         message:@"이벤트 창을 닫겠습니까?"
                                                        delegate:self
                                               cancelButtonTitle:@"닫기"
                                               otherButtonTitles:@"오늘하루 보지않기" , nil];
            [eventCloseAlert show];
        }
        return NO;
    }
    
//    http://www.wolbae.es.kr/user/mobile/login.do
    NSRange strRange_filedown = [requestStr rangeOfString:@"login.do"];
    if (strRange_filedown.location != NSNotFound) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([[defaults objectForKey:@"autoLoginYN"] isEqualToString:@"Y"]) {
            self.sos_loginIdTextField.text = [defaults objectForKey:@"auto_idStr"];
//            self.sos_loginPwTextField.text = [defaults objectForKey:@"auto_pwStr"];
            // 자동로그인에 패스워드 제거
//            self.sos_loginPwTextField.text = [self tempPwd];
            [self.id_textField_imageView setImage:[UIImage imageNamed:@"idpwd_input_on"]];
            [self.pw_textField_imageView setImage:[UIImage imageNamed:@"idpwd_input_on"]];
            
        }else {
            self.sos_loginIdTextField.text = nil;
            self.sos_loginPwTextField.text = nil;
        }
        
        [self.sos_loginView setHidden:NO];
        
        NSLog(@"test 로그인이 필요합니다.(웹뷰 자물쇠)");
        
        NSArray *arrItem = [requestStr componentsSeparatedByString:@"/user/"];
        
        changeMainHomeURLStr = [arrItem objectAtIndex:0];
        
        return NO;
    
    }
    
    NSRange strRange_filedown_webLogout = [requestStr rangeOfString:@"mobilelogout=ok"];
    if (strRange_filedown_webLogout.location != NSNotFound) {
        
        webviewLogoutYN = YES;
        
        [self connectToServer_logout];
        
        NSLog(@"test 웹뷰 로그아웃");
        return NO;
    }
    
    NSRange strRange_filedown_1 = [requestStr rangeOfString:@".jpg"];
    NSRange strRange_filedown_2 = [requestStr rangeOfString:@".jpeg"];
    NSRange strRange_filedown_3 = [requestStr rangeOfString:@".png"];
    NSRange strRange_filedown_4 = [requestStr rangeOfString:@".hwp"];
    NSRange strRange_filedown_5 = [requestStr rangeOfString:@".txt"];
    NSRange strRange_filedown_6 = [requestStr rangeOfString:@".doc"];
    NSRange strRange_filedown_7 = [requestStr rangeOfString:@".docx"];
    NSRange strRange_filedown_8 = [requestStr rangeOfString:@".dotx"];
    NSRange strRange_filedown_9 = [requestStr rangeOfString:@".hwt"];
    NSRange strRange_filedown_10 = [requestStr rangeOfString:@".pdf"];
    NSRange strRange_filedown_11 = [requestStr rangeOfString:@".xls"];
    NSRange strRange_filedown_12 = [requestStr rangeOfString:@".xml"];
    NSRange strRange_filedown_13 = [requestStr rangeOfString:@".xmls"];
    NSRange strRange_filedown_14 = [requestStr rangeOfString:@"download"];
    NSRange strRange_filedown_15 = [requestStr rangeOfString:@"xhtml"];
    
    if (strRange_filedown_1.location != NSNotFound ||
        strRange_filedown_2.location != NSNotFound ||
        strRange_filedown_3.location != NSNotFound ||
        strRange_filedown_4.location != NSNotFound ||
        strRange_filedown_5.location != NSNotFound ||
        strRange_filedown_6.location != NSNotFound ||
        strRange_filedown_7.location != NSNotFound ||
        strRange_filedown_8.location != NSNotFound ||
        strRange_filedown_9.location != NSNotFound ||
        strRange_filedown_10.location != NSNotFound ||
        strRange_filedown_11.location != NSNotFound ||
        strRange_filedown_12.location != NSNotFound ||
        strRange_filedown_13.location != NSNotFound ||
        strRange_filedown_14.location != NSNotFound ||
        strRange_filedown_15.location != NSNotFound)
    {
        NSRange strRange_showFile = [requestStr rangeOfString:@"SynapDocViewServer"];
        
        if (strRange_showFile.location != NSNotFound)
        {
            //알림장인지 확인하기
            self.lastLoadedAlrimJangUrl = [[webView request].URL absoluteString];

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:requestStr]];
            
            if([self.lastLoadedAlrimJangUrl containsString:@"e_know"])
            {
                for(int i = 0; i < 2; i ++)
                    [webView goBack];
            }
            
            else
                self.lastLoadedAlrimJangUrl = nil;
            
            return NO;
        }
//        NSArray *arrItem = [requestStr componentsSeparatedByString:@"/MCD_"];
//        NSString *fileNameStr = [arrItem objectAtIndex:1];
        
        NSArray *arrItem2 = [requestStr componentsSeparatedByString:@"/"];
        NSString *fileNameStr2 = [arrItem2 objectAtIndex:[arrItem2 count] - 1];
        
//        fileNameStr = [fileNameStr stringByReplacingOccurrencesOfString:@"hname=" withString:@""];
//        
//        NSArray *arrItem2 = [fileNameStr componentsSeparatedByString:@"."];
//        NSString *item1 = [arrItem2 objectAtIndex:0];
//        item1 = [item1 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSString *item2 = [arrItem2 objectAtIndex:1];
//        
//        fileNameStr = [NSString stringWithFormat:@"%@.%@",item1,item2];
        
        NSLog(@"test29929139919491249194 -- %@", fileNameStr2);
        
//                NSLog(@"test29292913 -- %@",[NSString stringWithCString:[fileNameStr cStringUsingEncoding:NSISOLatin1StringEncoding] encoding:NSUTF8StringEncoding]);
        
        
//        [self fileDown_inWebView:fileNameStr2 webviewURL:requestStr];
        
        fileDownload_request = requestStr;
        fileDownload_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        
        return NO;
    }
    
    return YES;
}


- (void) fileDown_inWebView:(NSString *)filename webviewURL:(NSString *)urlStr{
    
    
    //////////////////////////////////////////////////////////////////////////////////////////
   
    NSLog(@"test292292929292929 -- %@",urlStr);
    
    NSData *tempData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlStr]]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",filename]];
    
    
    BOOL isWrite = [tempData writeToFile:filePath atomically:YES];
    NSString *tempFilePath;
    
    if (isWrite) {
        tempFilePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", filename]];
    }
    
    NSURL *resultURL = [NSURL fileURLWithPath: tempFilePath];
    
    
    self.documentInteractionController = [[UIDocumentInteractionController alloc] init];
    self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL: resultURL];
    self.documentInteractionController.delegate = self;
    [self.documentInteractionController presentOptionsMenuFromRect:CGRectZero inView:self.view animated:YES];
    
    NSLog(@"test44444 -- ");
    
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == change_mainSchool_AlertView) {
        if (buttonIndex == 1) {
            [self connectToServer_logout_alert];
        }
    }else if (alertView == pushAlertView) {
        if (buttonIndex==1) {
            [self pushAlarmProgress:pushObjectArray_main];
        }
//    }else if (alertView == versionAlertView) {
//        if (buttonIndex==1) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/kr/app/seukulnabi/id893129176?l=ko&ls=1&mt=8"]];
//        }
    }else if (alertView == schoolAdd_noClubAlert) {
        if (buttonIndex==1) {
            NSLog(@"test pass club btn no club -- %@" , schoolAdd_noClubDomainIDStr);
            
            NSString *domainStr = @"";
            NSString *sidStr = @"";
            NSString *infoStr = @"";
            
            domainStr = schoolAdd_noClubDomainIDStr;
            
            //    noValue_mySchool_idxStr = [NSString stringWithFormat:@"%@",[[in_schoolChangeArray objectAtIndex:0] objectForKey:@"IDX"]];
            
            [self connectToServer_schoolAdd:domainStr sidData:sidStr infoData:infoStr];
        }
    }else if (alertView == eventCloseAlert) {
        
        [self.event_View setHidden:YES];
        [self.event_webView stopLoading];
        
        if (buttonIndex==1) {
            
            NSDate *date = [NSDate date];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [dateFormat stringFromDate:date];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:dateString forKey:@"eventShowDate"];
            [defaults synchronize];
        }
    }
    //웹화면 웹뷰일때...
    else if(alertView.tag == 9999)
    {
        NSString *currentWebPageUrl = [reHome_webView.request.URL absoluteString];
        
        if([currentWebPageUrl containsString:@"schoolSetting=ok"])
        {
            if([alertView.message containsString:@"openapi"])   return;
            
            //여기서 학교설정 탭으로 화면전환을 해주면 된다.
            NSLog(@"학교설정 탭으로 화면전환 필요합니다");
            [self.main_homeView setHidden:YES];
            [self.main_sosView setHidden:YES];
            [self.main_schoolSettingView setHidden:NO];
            [self.main_guideView setHidden:YES];
            
            [self.main_searchView setHidden:YES];
            [self.main_changeView setHidden:YES];
            
            [self.main_tabOutlet_1 setBackgroundImage:[UIImage imageNamed:@"bt_menu01"] forState:UIControlStateNormal];
            [self.main_tabOutlet_2 setBackgroundImage:[UIImage imageNamed:@"bt_menu02"] forState:UIControlStateNormal];
            [self.main_tabOutlet_3 setBackgroundImage:[UIImage imageNamed:@"bt_menu03_on"] forState:UIControlStateNormal];
            [self.main_tabOutlet_4 setBackgroundImage:[UIImage imageNamed:@"bt_menu04"] forState:UIControlStateNormal];
        }
    }
}

- (void)pushAlarmGet_ing:(NSArray*)objectArray
{
    [pushAlertView dismissWithClickedButtonIndex:0 animated:YES];
    
    pushObjectArray_main = objectArray;
    
    pushAlertView = [[UIAlertView alloc] initWithTitle:objectArray[1]
                                               message:@"새로운 알림이 있습니다.\n확인 하시겠습니까?"
                                              delegate:self
                                     cancelButtonTitle:@"닫기"
                                     otherButtonTitles:@"확인하기", nil];
    [pushAlertView show];
    
}

- (void)pushAlarmProgress:(NSArray*)objectArray {
    
//    [self.push_showView setHidden:NO];
//    [self.sos_loginView setHidden:YES];

    [self.push_webView stopLoading];
    
    NSString *allDataStr = [objectArray objectAtIndex:0];
    NSArray *arrItem = [allDataStr componentsSeparatedByString:@"|"];
//    bookmarkYNStr = [arrItem objectAtIndex:3];
    
    
    // 자물쇠 예외처리 부분
    
    NSURL *myURL;
    
    for (int i = 0; i < [[mySchoolList_news_re objectForKey:@"dicData"] count]; i++) {
        NSLog(@"test push 메핑 domain id : %@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN"]);
        
        if ([[arrItem objectAtIndex:3] isEqualToString:@""]) {
            if ([[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN"] isEqualToString:[arrItem objectAtIndex:0]]) {
                
                NSString *idxStr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"IDX"]];
                [self connectToServer_mainCheck3:idxStr];
                
            }
        }else {
            if ([[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN"] isEqualToString:[arrItem objectAtIndex:0]] && [[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"INFO_ID"] isEqualToString:[arrItem objectAtIndex:3]]) {
                
                NSString *idxStr = [NSString stringWithFormat:@"%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"IDX"]];
                [self connectToServer_mainCheck3:idxStr];
                
            }
        }
    }
    
    
    push_login_ingYN = YES;
    
    for (int i = 0; i < [[mySchoolList_news_re objectForKey:@"dicData"] count]; i++) {
        NSLog(@"test push 메핑 domain id : %@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN"]);
        if ([[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN"] isEqualToString:[arrItem objectAtIndex:0]]) {
            push_loginDomainIDstr = [[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN_ID"];
            NSLog(@"test push 메핑 domain id : %@",[mySchoolList_news_re objectForKey:@"dicData"]);
            
            [self.login_viewTitleLabel setText:[NSString stringWithFormat:@"%@ 로그인 정보를 입력해 주세요.",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN_NM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            [self.sos_viewTitleLabel setText:[NSString stringWithFormat:@"%@ 신고내용을 입력해 주세요.",[[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN_NM"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            
            changeMainHomeURLStr = [NSString stringWithFormat:@"http://%@",[[[mySchoolList_news_re objectForKey:@"dicData"] objectAtIndex:i] objectForKey:@"DOMAIN"]];
            
        }
    }
    
    [self.push_showView setHidden:NO];
    [self.sos_loginView setHidden:YES];

    if ([arrItem count] == 7)
    {
        if (!ssoKey || [ssoKey isEqualToString:@""])
        {
            myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@/user/board/batch/batchUserView2.do?mobMcd=%@&ssoKey=&dataSid=%@&pushMode=1&pushPage=ok&infoid=%@&batchSid=%@&loginPos=%@&menuCd=%@",[arrItem objectAtIndex:0] ,[arrItem objectAtIndex:1] ,[arrItem objectAtIndex:2], [arrItem objectAtIndex:3],[arrItem objectAtIndex:4],[arrItem objectAtIndex:5],[arrItem objectAtIndex:6]]];
        }
        else
        {
            myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@/user/board/batch/batchUserView2.do?mobMcd=%@&ssoKey=%@&dataSid=%@&pushMode=1&pushPage=ok&infoid=%@&batchSid=%@&loginPos=%@&menuCd=%@",[arrItem objectAtIndex:0] ,[arrItem objectAtIndex:1], ssoKey ,[arrItem objectAtIndex:2], [arrItem objectAtIndex:3],[arrItem objectAtIndex:4],[arrItem objectAtIndex:5],[arrItem objectAtIndex:6]]];
        }
    }
    else
    {
        if (!ssoKey || [ssoKey isEqualToString:@""])
        {
            myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@/user/mobile/board/view.do?mobMcd=%@&ssoKey=&dataSid=%@&pushMode=1&pushPage=ok&infoid=%@",[arrItem objectAtIndex:0] ,[arrItem objectAtIndex:1] ,[arrItem objectAtIndex:2], [arrItem objectAtIndex:3]]];
        }
        else
        {
            myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@/user/mobile/board/view.do?mobMcd=%@&ssoKey=%@&dataSid=%@&pushMode=1&pushPage=ok&infoid=%@",[arrItem objectAtIndex:0] ,[arrItem objectAtIndex:1], ssoKey ,[arrItem objectAtIndex:2], [arrItem objectAtIndex:3]]];
        }
    }
    
    push_login_urlStr = myURL;
    
    NSURLRequest *myURLReq = [NSURLRequest requestWithURL: myURL];
    [self.push_webView loadRequest:myURLReq];
}

- (void) pushLoadingTimerPress {
    
    //    NSLog(@"웹뷰 ??????!!@!@!@!@!@!@!@!@");
    
//    if(!self.reTab1_webView.loading) {
//        [pushLoadingTimer invalidate];
//        
//        [self.reMainView setHidden:YES];
//        [self.reMain_tab1View setHidden:NO];
//        [self.reMain_tab2View setHidden:YES];
//        [self.reMain_tab3View setHidden:YES];
//        [self.reMain_mypageView setHidden:YES];
//        [self.reMain_settingView setHidden:YES];
//        NSLog(@"test202020 ");
//        [self.reMain_tab1_btnOutlet setBackgroundImage:[UIImage imageNamed:@"page1_1"] forState:UIControlStateNormal];
//        [self.reMain_tab2_btnOutlet setBackgroundImage:[UIImage imageNamed:@"page2"] forState:UIControlStateNormal];
//        [self.reMain_tab3_btnOutlet setBackgroundImage:[UIImage imageNamed:@"page3"] forState:UIControlStateNormal];
//        
//        NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//        
//        NSURL *myURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://www.uljin.go.kr%@&uuid=%@",pushClickObjectArray[0],deviceUUID]];
//        NSURLRequest *myURLReq = [NSURLRequest requestWithURL: myURL];
//        [self.reTab1_webView loadRequest:myURLReq];
//        
//        
//    }
}


- (void)didSelectCellRowFirstDo2:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    
    isOpen_subTL = firstDoInsert;
    
    int section = (int)selectIndex_subTL.section;

    int contentCount = (int)[CS_detailArray count];
    
    NSLog(@"test40000 -- %d",section);
    
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    for (NSUInteger i = 1; i < contentCount + 1; i++) {
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
        [rowToInsert addObject:indexPathToInsert];
    }
    NSLog(@"test1234 -- kkk5");
    
    if (firstDoInsert)
    {
        [self.setting_tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    else
    {
        [self.setting_tableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
    NSLog(@"test1234 -- kkk7");
    
    [self.setting_tableView endUpdates];
    if (nextDoInsert) {
        isOpen_subTL = YES;
        selectIndex_subTL = [self.setting_tableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo2:YES nextDo:NO];
    }
    if (isOpen_subTL) [self.setting_tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
}

- (IBAction)event_closeView:(id)sender {
    [self.event_View setHidden:YES];
    [self.event_webView stopLoading];
}

- (void)showPressed_tostAlertLabel:(NSString *)alertStr
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationsEnabled:YES];
    
    [self.tostAlertLabel_new setText:alertStr];
//    [self.tostAlertLabel_new setHidden:NO];
    [self.tostAlertLabel_new setAlpha:0.5];
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(hiddenPressed_tostAlertLabel) withObject:nil afterDelay:1.0];
}

- (void)hiddenPressed_tostAlertLabel
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationsEnabled:YES];
    
//    [self.tostAlertLabel_new setHidden:YES];
    [self.tostAlertLabel_new setAlpha:0.0];
    
    [UIView commitAnimations];
}

#pragma mark - private

-(NSMutableString*)tempPwd
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //비밀번호 자릿수를 알아온다.
    NSInteger pwdLength = [[defaults objectForKey:@"pwdLength"] integerValue];
    NSMutableString *pwdStr = [[NSMutableString alloc] initWithCapacity:pwdLength];
    
    for(int i = 0; i < pwdLength; i ++)
    {
        [pwdStr appendString:@"*"];
    }
    
    return pwdStr;
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    didNewInputPwd = YES;
    
    return YES;
}


@end
