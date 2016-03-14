//
//  UIWebView+ToFile.h
//  SignPdfDemo
//
//  Created by shutup on 16/3/12.
//  Copyright © 2016年 shutup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (ToFile)

- (UIImage *)imageRepresentation;

- (NSData *)PDFData;

@end
