//
//  GenPdfViewController.m
//  SignPdfDemo
//
//  Created by shutup on 16/3/13.
//  Copyright © 2016年 shutup. All rights reserved.
//

#import "GenPdfViewController.h"
#import "BNHtmlPdfKit.h"
#import <Masonry.h>
#import "SignPdfViewController.h"

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
    NSString* fullPath = [self getFullPathForFileName:@"hello.pdf"];
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
    [self presentViewController:signVC animated:YES completion:nil];
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
        [_genPdfBtn setTitle:@"gen pdf from html" forState:UIControlStateNormal];
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
    
    self.htmlStr = @"<html><head><title>我的第一个 HTML 页面</title></head><body><p style=""text-align: center;""><strong>　　租房合同范本一</strong></p><p>　　出租方：______(以下简称甲方)</p><p>　　身份证：_________________</p><p>　　承租方：______(以下简称乙方)</p><p>　　身份证：_________________</p><p>　　根据甲、乙双方在自愿、平等、互利的基础上，经协商一致，为明确双方之间的权利义务关系，就甲方将其合法拥有的房屋出租给乙方使用，乙方承租甲方房屋事宜，订立本合同。</p><p>　　<strong>一、房屋地址：</strong>塘南新村北区120幢401室内的一间单间。用于普通住房。</p><p>　<strong>　二、租赁期限及约定</strong></p><p>　　1、该房屋租赁期共一年。自_____年_____月_____日起至_____年_____月_____日止。</p><p>　　2、房屋租金：每月_____元。按月付款，每月提前五天付款。另付押金_____元，共计______元.</p><p>　　(大写：_____万_____仟_____佰_____拾_____元整)</p><p>　　房屋终止，甲方验收无误后，将押金退还乙方，不计利息。</p><p>　　3、乙方向甲方承诺，租赁该房屋仅作为普通住房使用。</p><p>　　4、租赁期满，甲方有权收回出租房屋，乙方应如期交还。乙方如要求续租，则必须在租赁期满前一个月内通知甲方，经甲方同意后，重新签订租赁合同。</p><p><strong>　　三、房屋修缮与使用</strong></p><p>　　1、在租赁期内，甲方应保证出租房屋的使用安全。乙方应合理使用其所承租的房屋及其附属设施。如乙方因使用不当造成房屋及设施损坏的，乙方应负责修复或给予经济赔偿。</p><p>　　2、该房屋及所属设施的维修责任除双方在本合同及补充条款中约定外，均由甲方负责(但乙方使用不当除外)。甲方进行维修须提前七天通知乙方，乙方应积极协助配合。</p><p>　　3、乙方因使用需要，在不影响房屋结构的前提下，可以对房屋进行装修装饰，但其设计规模、范围、工艺、用料等方案应事先征得甲方的同意后方可施工。租赁期满后，依附于房屋的装修归甲方所有。对乙方的装修装饰部分甲方不负有修缮的义务。</p><p><strong>　　四、房屋的转让与转租</strong></p><p>　　1、租赁期间，未经甲方书面同意，乙方不得擅自转租、转借承租房屋。</p><p>　　2、甲方同意乙方转租房屋的，应当单独订立补充协议，乙方应当依据与甲方的书面协议转租房屋。</p><p><strong>　　五、乙方违约的处理规定</strong></p><p>　　在租赁期内，乙方有下列行为之一的，甲方有权终止合同，收回该房屋，乙方应向甲方支付合同总租金20%的违约金，若支付的违约金不足弥补甲方损失的，乙方还应负责赔偿直至达到弥补全部损失为止。</p><p>　　(1) 未经甲方书面同意，擅自将房屋转租、转借给他人使用的;</p><p>　　(2) 未经甲方同意，擅自拆改变动房屋结构或损坏房屋，且经甲方通知，在规定期限内仍未纠正并修复的;</p><p>　　(3) 擅自改变本合同规定的租赁用途或利用该房屋进行违法活动的;</p><p>　　(4) 拖欠房租累计一个月以上的。</p><p><strong>　　六</strong>、本协议一式两份，甲.乙各执一份，签字后即行生效。</p><p>　<strong>　七</strong>、其他说明：水电数字由甲乙双方与其他承租方平均分配</p><p>　　(入住时的水电数字：电________，水________，)</p><p>　　甲方签字：　　　　　　乙方签字：</p><p>　　联系方式：　　　　　　联系方式：</p><p style=""text-align: center;""><strong>　　简单个人租房合同范本二</strong></p><p>　　出租方：(以下简称甲方)____________</p><p>　　承租方：(以下简称乙方)____________</p><p>　　甲、乙双方就房屋租赁事宜，达成如下协议：</p><p>　　一、甲方将位于____市____街道____小区__号楼________号的房屋出租给乙方居住使用，租赁期限自____年____月____日至____年____月____日，计__个月。</p><p>　　二、本房屋月租金为人民币____元，按月/季度/年结算。每月___月初/每季___季初/每年___年初__日内，乙方向甲方支付___全月/季/年租金。</p><p>　　三、乙方租赁期间，水费、电费、取暖费、燃气费、电话费、物业费以及其它由乙方居住而产生的费用由乙方负担。租赁结束时，乙方须交清欠费。</p><p>　　四、乙方同意预交元作为保证金，合同终止时，当作房租冲抵。</p><p>　　五、房屋租赁期为，从__年__月__日至__年__月__日。在此期间，任何一方要求终止合同，须提前三个月通知对方，并偿付对方总租金___的违约金;如果甲方转让该房屋，乙方有优先购买权。</p><p>　　六、因租用该房屋所发生的除土地费、大修费以外的其它费用，由乙方承担。</p><p>　　七、在承租期间，未经甲方同意，乙方无权转租或转借该房屋;不得改变房屋结构及其用途，由于乙方人为原因造成该房屋及其配套设施损坏的，由乙方承担赔偿责任。</p><p>　　八、甲方保证该房屋无产权纠纷;乙方因经营需要，要求甲方提供房屋产权证明或其它有关证明材料的，甲方应予以协助。</p><p>　　九、就本合同发生纠纷，双方协商解决，协商不成，任何一方均有权向天津开发区人民法院提起诉讼，请求司法解决。</p><p>　　十、本合同连一式__份，甲、乙双方各执__份，自双方签字之日起生效。</p><p>　　甲方：_____________　　电话：_____________</p><p>　　身份证：___________</p><p>　　乙方：_____________　　电话：_____________</p><p>　　身份证：___________</p><p>　　___年___月___日<br /><br />&nbsp;</p></body></html>";
    
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
#pragma mark - private
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
