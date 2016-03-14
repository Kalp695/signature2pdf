//
//  FirstViewController.m
//  SignPdfDemo
//
//  Created by shutup on 16/3/11.
//  Copyright © 2016年 shutup. All rights reserved.
//

#import "FirstViewController.h"
#import "NSString+Common.h"
#import "SecondViewController.h"

#import <Masonry.h>

@interface FirstViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) UIButton* btn;
@property (nonatomic, strong) UILabel* info;
@end

@implementation FirstViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.info];
    [self.view addSubview:self.btn];
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
    SecondViewController* secondVC = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:secondVC animated:YES];
}



#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSArray* a = [webView.scrollView subviews];
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
        [_btn setTitle:@"next" forState:UIControlStateNormal];
        [_btn setBackgroundColor:[UIColor greenColor]];
    }
    return _btn;
}

- (UILabel *)info
{
    if (_info == nil) {
        _info = [UILabel new];
        [_info setText:@"the empty html Str that before replace name"];
        [_info setTextAlignment:NSTextAlignmentCenter];
    }
    return _info;
}

#pragma mark - private
- (void)initEvents{
    
    NSString* htmlStr = [NSString htmlStr];
    [self.webView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:@"http://localhost"]];
    
    
    [self.btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)layoutSubViews{
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.webView.superview);
        make.left.equalTo(self.webView.superview).offset(10);
        make.right.equalTo(self.webView.superview).offset(-10);
        
    }];
    
    [self.info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.webView.mas_bottom).offset(10);
        make.centerX.equalTo(self.info.superview);
        make.width.equalTo(self.info.superview);
        make.height.equalTo(@50);
    }];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.info.mas_bottom).offset(10);
        make.centerX.equalTo(self.btn.superview);
        make.width.equalTo(@200);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.btn.superview).offset(-10);
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
