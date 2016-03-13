//
//  FirstViewController.m
//  SignPdfDemo
//
//  Created by shutup on 16/3/11.
//  Copyright © 2016年 shutup. All rights reserved.
//

#import "FirstViewController.h"
#import <Masonry.h>
#import "UIWebView+ToFile.h"

@interface FirstViewController () <UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) UIButton* btn;
@property (nonatomic, strong) UIButton* scrollToSignBtn;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.btn];
    [self.view addSubview:self.scrollToSignBtn];
    [self.view addSubview:self.webView];
    
    [self layoutSubViews];
    [self initEvents];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (void)btnClicked:(UIButton*)btn
{
    UIImage* image = [self.webView imageRepresentation];
    NSData* pdf = [self.webView PDFData];
    NSString* name =[self getFullPathForFileName:@"haha.pdf"];
    [self saveFromPdfData:pdf toFile:name];
    NSLog(@"");
}


- (void)scrollToSignBtnClicked:(UIButton*)btn
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"window.scrollTo(0,0);"];
}
#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSArray* a = [self.webView.scrollView subviews];
    for (UIView* view in a) {
        if ([view isKindOfClass:NSClassFromString(@"UIWebPDFView")]) {
            NSArray* b = view.subviews;
            
            for (int i =0;i<b.count;i++) {
                UIView* subView = b[i];
                if ([subView isKindOfClass:NSClassFromString(@"UIPDFPageView")]) {
//                    subView.layer.shadowOpacity = 0;
                    
                }
            }
        }
    }
}

#pragma mark - getter

- (UIWebView *)webView
{
    if (_webView == nil) {
        _webView = [UIWebView new];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

- (UIButton *)btn
{
    if (_btn == nil) {
        _btn = [UIButton new];
        [_btn setTitle:@"test" forState:UIControlStateNormal];
        [_btn setBackgroundColor:[UIColor greenColor]];
    }
    return _btn;
}

- (UIButton *)scrollToSignBtn
{
    if (_scrollToSignBtn == nil) {
        _scrollToSignBtn = [UIButton new];
        [_scrollToSignBtn setTitle:@"scroll to end" forState:UIControlStateNormal];
        [_scrollToSignBtn setBackgroundColor:[UIColor redColor]];
    }
    return _scrollToSignBtn;
}
#pragma mark - private
- (void)initEvents{
    
    NSURL *pdfURL = [[NSBundle mainBundle] URLForResource:@"just a test" withExtension:@"pdf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:pdfURL];
    //    [self.webView setScalesPageToFit:YES];
    [self.webView loadRequest:request];
    
    
    [self.btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollToSignBtn addTarget:self action:@selector(scrollToSignBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)layoutSubViews{
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.webView.superview).insets(UIEdgeInsetsMake(10, 10, 100, 10));
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.webView.mas_bottom).offset(10);
        make.centerX.equalTo(self.btn.superview);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
        
    }];
    
    [self.scrollToSignBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.webView.mas_bottom).offset(10);
        make.left.equalTo(self.btn.mas_right).offset(-10);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
        
    }];
}


-(void)showPDFFile
{
    NSString* fileName = @"just a test.pdf";
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    NSURL *url = [NSURL fileURLWithPath:pdfFileName];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView setScalesPageToFit:YES];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}


- (NSString*)getFullPathForFileName:(NSString*)fileName
{
    NSString* fileNameStr = fileName ? fileName :@"default.pdf";
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileNameStr];
    return pdfFileName;
}

- (BOOL)saveFromPdfData:(NSData*)pdfData toFile:(NSString*)file
{
    if ([pdfData writeToFile:file atomically:YES]) {
        NSLog(@"save success:%@",file);
        return YES;
    }else{
        NSLog(@"save failed:%@",file);
        return NO;
    }
    return NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
