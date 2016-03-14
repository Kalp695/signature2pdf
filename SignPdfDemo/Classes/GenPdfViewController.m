//
//  GenPdfViewController.m
//  SignPdfDemo
//
//  Created by shutup on 16/3/13.
//  Copyright © 2016年 shutup. All rights reserved.
//

#import "GenPdfViewController.h"
#import "NSString+Common.h"
#import "BNHtmlPdfKit.h"
#import "SignPdfViewController.h"
#import <Masonry.h>

@interface GenPdfViewController () <UIWebViewDelegate,BNHtmlPdfKitDelegate>

@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) UIButton* genPdfBtn;
@property (nonatomic, strong) BNHtmlPdfKit* pdfKit;
@property (nonatomic, strong) NSString* htmlStr;

@end

@implementation GenPdfViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self pdfKit];
    
    [self.view addSubview:self.genPdfBtn];
    [self.view addSubview:self.webView];
    
    [self layoutSubViews];
    [self initEvents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (void)genPdfBtnClicked:(UIButton*)btn
{
    NSString* fullPath = [NSString getFullPathForFileName:@"unsigned_pdf.pdf"];
    [self.pdfKit saveHtmlAsPdf:self.htmlStr toFile:fullPath];
    NSLog(@"%@",fullPath);
}
#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.genPdfBtn setEnabled:YES];
    [self.genPdfBtn setBackgroundColor:[UIColor greenColor]];
}

#pragma mark - BNHtmlPdfKitDelegate
- (void)htmlPdfKit:(BNHtmlPdfKit *)htmlPdfKit didSavePdfFile:(NSString *)file
{
    NSLog(@"save success:%@",file);
    SignPdfViewController* signVC = [[SignPdfViewController alloc] init];
    signVC.fileName = file;
    [self.navigationController pushViewController:signVC animated:YES];
}

- (void)htmlPdfKit:(BNHtmlPdfKit *)htmlPdfKit didFailWithError:(NSError *)error
{
    NSLog(@"save failed:%@",error);
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

- (UIButton *)genPdfBtn
{
    if (_genPdfBtn == nil) {
        _genPdfBtn = [UIButton new];
        [_genPdfBtn setEnabled:NO];
        [_genPdfBtn setTitle:@"gen pdf" forState:UIControlStateNormal];
        [_genPdfBtn setBackgroundColor:[UIColor grayColor]];
    }
    return _genPdfBtn;
}

- (BNHtmlPdfKit *)pdfKit
{
    if (_pdfKit == nil) {
        _pdfKit = [[BNHtmlPdfKit alloc] initWithPageSize:BNPageSizeA4];
        _pdfKit.delegate = self;
    }
    return _pdfKit;
}
#pragma mark - private
- (void)initEvents{
    if (self.nameStr) {
        self.htmlStr = [NSString htmlStrWithIdentify];
        self.htmlStr = [self.htmlStr stringByReplacingOccurrencesOfString:@"%name%" withString:self.nameStr];
    }else{
        self.htmlStr = [NSString htmlStr];
    }
    
    
    [self.webView loadHTMLString:self.htmlStr baseURL:[NSURL URLWithString:@"http://localhost"]];
    
    [self.genPdfBtn addTarget:self action:@selector(genPdfBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)layoutSubViews{
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.webView.superview).insets(UIEdgeInsetsMake(10, 10, 100, 10));
    }];
    
    [self.genPdfBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.webView.mas_bottom).offset(10);
        make.centerX.equalTo(self.genPdfBtn.superview);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
        
    }];
    
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
