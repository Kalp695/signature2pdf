//
//  NSString+Common.h
//  SignPdfDemo
//
//  Created by shutup on 16/3/14.
//  Copyright © 2016年 shutup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)

//the demo html Str
+ (NSString*)htmlStr;
//the demo html Str that can be replace some content
+ (NSString *)htmlStrWithIdentify;


//get full path to the file
+ (NSString*)getFullPathForFileName:(NSString*)fileName;
@end
