//
//  SecondViewController.m
//  SignPdfDemo
//
//  Created by shutup on 16/3/14.
//  Copyright © 2016年 shutup. All rights reserved.
//

#import "SecondViewController.h"
#import "GenPdfViewController.h"

#import <Masonry.h>

@interface SecondViewController ()
@property (nonatomic, strong) UITextField* textField;
@property (nonatomic, strong) UIButton* btn;
@end

@implementation SecondViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.btn];
    
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
    NSString* nameStr = self.textField.text;
    GenPdfViewController* genPdfVC = [[GenPdfViewController alloc] init];
    genPdfVC.nameStr = nameStr;
    [self.navigationController pushViewController:genPdfVC animated:YES];
}

#pragma mark - private
- (void)initEvents{
    
    [self.btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)layoutSubViews{
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.textField.superview);
        make.centerY.equalTo(self.textField.superview);
        make.width.equalTo(self.textField.superview);
        make.height.equalTo(@50);
    }];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(10);
        make.centerX.equalTo(self.btn.superview);
        make.width.equalTo(@200);
        make.height.equalTo(@50);
    }];
    
}

#pragma mark - getter
- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = [UITextField new];
        [_textField setBackgroundColor:[UIColor grayColor]];
        [_textField setPlaceholder:@"enter name"];
    }
    return _textField;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
