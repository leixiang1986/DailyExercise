//
//  NSObject+OKAnalysis.h
//  Pods
//
//  Created by 雷祥 on 2017/3/7.
//
//

/**
 *  解析相关
 */

#import <Foundation/Foundation.h>



@interface NSObject (OKAnalysis)

/**
 * 是否是指定类型,不包含子类
 */
- (BOOL)ok_isClass:(NSString *)className;

/**
 * 转化为字符串，不为空直接格式化为字符串,数组和字典的同名分类方法是通过序列化得到对应的字符串
 */
+ (NSString *)ok_toString:(id)obj;

/**
 * 是字典返回字典，不是字典或是空字典返回nil
 */
- (NSDictionary *)ok_dictionary;

/**
 * 是数组返回数组，不是数组或数组返回nil
 */
- (NSArray *)ok_array;

/**
 * 是否是有效的请求数据
 */
- (BOOL)ok_validRequestObject;

/**
 * json序列化为数组,内部做了类型判断，非数组为nil
 */
- (NSArray *)ok_toJsonObjOfArray;

/**
 * json序列化为字典,内部做了类型判断，非字典为nil
 */
- (NSDictionary *)ok_toJsonObjOfDictionary;


/**
 * dictionary 对应key下是否是指定的类型(className)，若是返回对应的实例，不是返回nil
 */
- (id)ok_dictionaryValueForKey:(NSString *)key isClass:(NSString *)className;

/**
 * dictionary 对应key的值(内部判断了是否是字典)
 */
- (id)ok_dictionaryValueForKey:(NSString *)key;

/**
 * 数组对应index的值，判断该是值是否是指定类型
 */
- (id)ok_arrayItemAtIndex:(NSInteger)index isClass:(NSString *)className;

/**
 * 数组对应index的值，内部判断是否是数组
 */
- (id)ok_arrayItemAtIndex:(NSInteger)index;

/**
 * 数组的元素个数,判断是否是数组
 */
- (NSInteger)ok_arrayCount;

/**
 * 字符串的长度，判断了是否是字符串
 */
- (NSInteger)ok_stringLength;

@end
