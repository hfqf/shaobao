//
//  NSString+string.h
//  SocialNetwork
//
//  Created by morris on 13-9-23.
//  Copyright (c) 2013年 xintong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (string)

- (NSString *)substringToFirstAppearanceOf:(unichar)target;
- (NSString *)substringToFirstAppearanceOfSet:(NSCharacterSet *)charset;
- (NSString *)substringToFirstAppearanceOfSet:(NSCharacterSet *)charset location:(NSUInteger *)location;
- (NSString *)substringFromFirstAppearanceOf:(unichar)target;
- (NSString *)substringFromFirstAppearanceOf:(unichar)target1 ToFirstAppearanceOf:(unichar)target2 FromIndex:(NSUInteger)beginIndex LastLocation:(NSUInteger *)lastLocation;
- (NSUInteger)locationOfFirstAppearanceOfSet:(NSCharacterSet *)charset from:(NSUInteger)location;
- (NSArray *)seperateByCharacter:(unichar)separate;
- (NSArray *)seperateByCharacters:(NSCharacterSet *)charset;
- (NSUInteger)findLastAppearanceOfSet:(NSCharacterSet *)charset ToIndex:(NSUInteger)endIndex;
- (BOOL)isSubstringOf:(NSString *)source CaseSensitive:(BOOL)casesensitive;
- (NSDictionary *)makeDictionary;
- (NSString *)substringFromLastAppearanceOf:(unichar)target;
- (NSString *)substringToLastAppearanceOf:(unichar)target;
- (BOOL)IsWhiteSpaceString;
- (NSString *)removeBlankSpace:(NSString *)currentStr;
+ (NSString *)changNilData:(NSString *)str;
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

@end
