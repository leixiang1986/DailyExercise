//
//  NSObject+OKAnalysis.m
//  Pods
//
//  Created by 雷祥 on 2017/3/7.
//
//

#import "NSObject+OKAnalysis.h"
#import "NSObject+OKRuntime.h"
#import "NSMutableArray+OKExtension.h"
#import "NSArray+OKExtention.h"
#import "NSMutableDictionary+OKExtension.h"

@implementation NSObject (OKAnalysis)

/**
 * 是否是指定类型
 */
- (BOOL)ok_isClass:(NSString *)className {
    BOOL ret = NO;
    if (className.length) {
        Class myClass = NSClassFromString(className);
        if (!myClass) {
            ret = NO;
        }else{
            ret = [self isKindOfClass:myClass] ? YES : NO;
        }
    }else{
        ret = NO;
    }
    return ret;
}


/**
 * 转化为字符串，不为空直接格式化为字符串,数组和字典的同名分类方法是通过序列化得到对应的字符串
 */
+ (NSString *)ok_toString:(id)obj; {
    if (obj) {
        if ([obj isKindOfClass:[NSString class]]) {
            return obj;
        }

        if (![obj isKindOfClass:[NSNull class]] && ![obj isEqual:nil] && ![obj isEqual:[NSNull null]]) {
            NSString *result = [NSString stringWithFormat:@"%@",obj];
            if (result && result.length > 0) {
                return result;
            }
            else{
                return @"";
            }
        }
        else{
            return @"";
        }
    }
    else{
        return @"";
    }
}

/**
 * 是字典返回字典，不是字典或是空字典返回nil
 */
- (NSDictionary *)ok_dictionary {
    if (self && [self isKindOfClass:[NSDictionary class]]) {
        NSDictionary *resultDic = self;
        if (resultDic && resultDic.allKeys.count > 0) {
            return resultDic;
        }
        else{
            return nil;
        }
    }
    else{
        return nil;
    }
}

/**
 * 是数组返回数组，不是数组或数组返回nil
 */
- (NSArray *)ok_array {
    if (self && [self isKindOfClass:[NSArray class]]) {
        NSArray *resultArr = self;
        if (resultArr && resultArr.count > 0) {
            return resultArr;
        }
        else{
            return nil;
        }
    }
    else{
        return nil;
    }
}

/**
 * 是否是有效的请求数据
 */
- (BOOL)ok_validRequestObject {
    BOOL ret = NO ;
    if (self && ![self isKindOfClass:[NSError class]]) {
        ret = YES;
    }else{
        ret = NO ;
    }
    return ret ;
}

/**
 * json序列化为数组,内部做了类型判断，非数组为nil
 */
- (NSArray *)ok_toJsonObjOfArray {
    NSArray *array = nil;
    if ([self isKindOfClass:[NSData class]]) {
        array = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:nil];
    }
    else if ([self isKindOfClass:[NSString class]]){
        NSString *string = self;
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    else{
        array = self;
    }

    return [array ok_array];
}

/**
 * json序列化为字典,内部做了类型判断，非字典为nil
 */
- (NSDictionary *)ok_toJsonObjOfDictionary {
    NSDictionary *dic = nil;
    if ([self isKindOfClass:[NSData class]]) {
        dic = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:nil];
    }
    else if ([self isKindOfClass:[NSString class]]) {
        NSString *string = self;
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        [data ok_toJsonObjOfDictionary];
    }
    else {
        dic = self;
    }

    return [dic ok_dictionary];
}



/**
 * dictionary 对应key下是否是指定的类型(className)，若是返回对应的实例，不是返回nil
 */
- (id)ok_dictionaryValueForKey:(NSString *)key isClass:(NSString *)className {
    if (![self isKindOfClass:[NSDictionary class]] || !key.length) {
        if ([className isEqualToString:NSStringFromClass([NSString class])]) {
            return @"";
        }

        return nil;
    }

    id obj = [(NSDictionary *)self objectForKey:key];
    if (className.length) {
        Class class = NSClassFromString(className);
        if ([obj isKindOfClass:class]) {
            return obj;
        }
        else if ([className isEqualToString:NSStringFromClass([NSString class])]){
            if ([obj isKindOfClass:[NSNumber class]]) {    //如果想要的是字符串，而实际是NSNumber，则转化为字符串
                return [NSString stringWithFormat:@"%@",obj];
            }
            return @"";
        }
        else {
            return nil;
        }
    }
    else {
        return obj;
    }
}

/**
 * dictionary 对应key的值(内部判断了是否是字典)
 */
- (id)ok_dictionaryValueForKey:(NSString *)key {
    return [self ok_dictionaryValueForKey:key isClass:nil];
}

/**
 * 数组对应index的值，判断该是值是否是指定类型
 */
- (id)ok_arrayItemAtIndex:(NSInteger)index isClass:(NSString *)className {
    if (![self isKindOfClass:[NSArray class]]) {
        if ([className isEqualToString:NSStringFromClass([NSString class])]) {
            return @"";
        }
        return nil;
    }
    NSArray *array = self;
    if (index >= array.count && index < 0) {
        if ([className isEqualToString:NSStringFromClass([NSString class])]) {
            return @"";
        }
        return nil;
    }

    id item = array[index];
    if (className.length) {
        if ([item isKindOfClass:NSClassFromString(className)]) {
            return item;
        }
        else if ([className isEqualToString:NSStringFromClass([NSString class])]){
            if ([item isKindOfClass:[NSNumber class]]) {    //如果想要的是字符串，而实际是NSNumber，则转化为字符串
                return [NSString stringWithFormat:@"%@",item];
            }
            return @"";
        }
        else {
            return nil;
        }
    }
    else {
        return item;
    }
}

/**
 * 数组对应index的值，内部判断是否是数组
 */
- (id)ok_arrayItemAtIndex:(NSInteger)index {
    return [self ok_arrayItemAtIndex:index isClass:nil];
}

/**
 * 数组的元素个数,判断是否是数组
 */
- (NSInteger)ok_arrayCount {
    if ([self isKindOfClass:[NSArray class]]) {
        NSArray *array = self;
        return array.count;
    }
    else {
        return 0;
    }
}

/**
 * 字符串的长度，判断了是否是字符串
 */
- (NSInteger)ok_stringLength {
    if ([self isKindOfClass:[NSString class]]) {
        NSString *string = self;
        return string.length;
    }
    else {
        return 0;
    }
}

@end
