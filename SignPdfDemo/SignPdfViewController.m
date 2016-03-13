//
//  SignPdfViewController.m
//  SignPdfDemo
//
//  Created by shutup on 16/3/13.
//  Copyright © 2016年 shutup. All rights reserved.
//

#import "SignPdfViewController.h"
#import "SignatureViewQuartzQuadratic.h"
#import "BNHtmlPdfKit.h"
#import <Masonry.h>
@interface SignPdfViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) UIButton* signPdfBtn;
@property (nonatomic, strong) UIButton* okBtn;

@property (nonatomic, strong) SignatureViewQuartzQuadratic* signView;
@property (assign) CGFloat content_hetght;
@property (assign) NSInteger content_num;
@property (assign) CGFloat page_height;
@end

@implementation SignPdfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    [self.view addSubview:self.signPdfBtn];
    [self.view addSubview:self.okBtn];
    
    [self layoutSubViews];
    [self initEvents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSArray* a = [self.webView.scrollView subviews];
    for (UIView* view in a) {
        if ([view isKindOfClass:NSClassFromString(@"UIWebPDFView")]) {
            NSArray* b = view.subviews;
            
            UIView* last = [b firstObject];
            if ([last isKindOfClass:NSClassFromString(@"UIPDFPageView")]) {
                //                last.layer.shadowOpacity = 0;
                CGRect newRect = [view convertRect:last.bounds fromView:last];
                [self.signView setFrame:newRect];
                [view addSubview:self.signView];
            }
        }
    }
    
    [self.okBtn setEnabled:YES];
    [self.signPdfBtn setEnabled:YES];
    self.content_hetght = webView.scrollView.contentSize.height;
    self.content_num = [self getTotalPDFPages:self.fileName];
    self.page_height = self.content_hetght / self.content_num;
}

#pragma mark - action

- (void)okBtnClicked:(UIButton*)btn
{
    NSURL *pdfUrl = [NSURL fileURLWithPath:self.fileName];
    CGPDFDocumentRef doc = CGPDFDocumentCreateWithURL((CFURLRef)pdfUrl);
    
    
    NSString *tempPath = [NSTemporaryDirectory() stringByAppendingString:@"annotated.pdf"];
    //CGRectZero means the default page size is 8.5x11
    //We don't care about the default anyway, because we set each page to be a specific size
    UIGraphicsBeginPDFContextToFile(tempPath, CGRectZero, nil);
    
    //Iterate over each page - 1-based indexing (obnoxious...)
    NSInteger pages = [self getTotalPDFPages:self.fileName];
    for (int i = 1; i <= pages; i++) {
        CGPDFPageRef page = CGPDFDocumentGetPage (doc, i); // grab page i of the PDF
        CGRect cropBoxRect = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
        CGRect mediaBoxRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
        CGRect effectiveRect = CGRectIntersection(cropBoxRect, mediaBoxRect);
        NSLog(@"effective frame is %@",NSStringFromCGRect(effectiveRect));
        CGSize size = [BNHtmlPdfKit sizeForPageSize:BNPageSizeA4];
        CGRect bounds = CGRectMake(0, 0, size.width, size.height);
        NSLog(@"A4 frame is %@",NSStringFromCGRect(bounds));
        //Create a new page
        UIGraphicsBeginPDFPageWithInfo(bounds, nil);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        // flip context so page is right way up
        CGContextTranslateCTM(context, 0, bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawPDFPage (context, page); // draw the page into graphics context
        
        
        //Annotations
        if (self.signView.path && i==pages) {
            NSLog(@"Writing annotations");
            CGFloat scale_width = size.width / self.signView.bounds.size.width;
            CGFloat scale_height = size.height / self.signView.bounds.size.height;
//            [self.signView.path ]
            CGAffineTransform transform = CGAffineTransformMakeScale(scale_width, scale_height);
            CGPathRef intermediatePath = CGPathCreateCopyByTransformingPath(self.signView.path.CGPath,
                                                                            &transform);
            self.signView.path.CGPath = intermediatePath;
            //Flip back right-side up
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextTranslateCTM(context, 0, -bounds.size.height);
            CGContextAddPath(context, self.signView.path.CGPath);
            CGContextSetLineWidth(context, 3.0f);
            CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextStrokePath(context);
        }
    }
    
    UIGraphicsEndPDFContext();
    
    CGPDFDocumentRelease (doc);
    NSLog(@"the temp path:%@",tempPath);
    
}
- (void)signPdfBtnClicked:(UIButton*)btn
{
    [self.webView.scrollView setContentOffset:CGPointMake(0, (self.content_num-1)*(self.page_height) - 110) animated:YES];
    //    [self.webView.scrollView setScrollEnabled:NO];
    [self.signView setUserInteractionEnabled:YES];
}

#pragma mark - private
- (void)initEvents{
    
    NSURL *pdfURL = [NSURL fileURLWithPath:self.fileName];
    NSURLRequest *request = [NSURLRequest requestWithURL:pdfURL];
    [self.webView setScalesPageToFit:YES];
    [self.webView loadRequest:request];
    
    
    [self.okBtn addTarget:self action:@selector(okBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.signPdfBtn addTarget:self action:@selector(signPdfBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)layoutSubViews{
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.webView.superview).insets(UIEdgeInsetsMake(10, 10, 100, 10));
    }];
    
    [self.signPdfBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.webView.mas_bottom).offset(10);
        make.left.equalTo(self.signPdfBtn.superview).offset(10);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
        
    }];
    
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.webView.mas_bottom).offset(10);
        make.right.equalTo(self.okBtn.superview).offset(-10);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
        
    }];
}

#pragma mark - getter
- (SignatureViewQuartzQuadratic *)signView
{
    if (_signView == nil) {
        _signView = [[SignatureViewQuartzQuadratic alloc] init];
        [_signView setBackgroundColor:[UIColor clearColor]];
        [_signView setUserInteractionEnabled:NO];
    }
    return _signView;
}

- (UIWebView *)webView
{
    if (_webView == nil) {
        _webView = [UIWebView new];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

- (UIButton *)signPdfBtn
{
    if (_signPdfBtn == nil) {
        _signPdfBtn = [UIButton new];
        [_signPdfBtn setEnabled:NO];
        [_signPdfBtn setTitle:@"sign" forState:UIControlStateNormal];
        [_signPdfBtn setBackgroundColor:[UIColor greenColor]];
    }
    return _signPdfBtn;
}

- (UIButton *)okBtn
{
    if (_okBtn == nil) {
        _okBtn = [UIButton new];
        [_okBtn setEnabled:NO];
        [_okBtn setTitle:@"ok" forState:UIControlStateNormal];
        [_okBtn setBackgroundColor:[UIColor redColor]];
    }
    return _okBtn;
}

#pragma mark - private
-(NSInteger)getTotalPDFPages:(NSString *)strPDFFilePath
{
    NSURL *pdfUrl = [NSURL fileURLWithPath:strPDFFilePath];
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL((CFURLRef)pdfUrl);
    size_t pageCount = CGPDFDocumentGetNumberOfPages(document);
    CGPDFDocumentRelease(document);
    return pageCount;
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
