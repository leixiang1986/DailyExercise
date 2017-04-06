//
//  OkdeerBundleHelp.m
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 17/1/5.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "OkdeerBundleHelp.h"

@implementation OkdeerBundleHelp

/********
 *
 *  根据名称获取对应的bundle,适用于存放在,resources_bundles中的
 *
 ********/
NSBundle *bundleForPod(NSString *podName)
{
    NSString* bundlePath = bundlePathForPod(podName);
    if (bundlePath) {
        return [NSBundle bundleWithPath:bundlePath];
    }
    
    return nil;
}

/********
 *
 *  根据xib 名称获取对应的UINib 名称,适用于存放在,resources_bundles中的
 *
 ********/
UIStoryboard *GetStoryBoardFromPodName(NSString *podName, NSString *storyName)
{
    NSString* bundlePath =bundlePathForPod(podName);
    if (bundlePath) {
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        if (bundle) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyName bundle:bundle];
            if (storyBoard) {
                return storyBoard;
            }
        }
    }
    
    return nil;
}

/********
 *
 *  根据xib 名称获取对应的UINib 名称,适用于存放在,resources_bundles中的
 *
 ********/
UINib *GetNibFromPodName(NSString *podName, NSString *xibName)
{
    NSString* bundlePath = bundlePathForPod(podName);
    if (bundlePath) {
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        if (!bundle) {
            return nil;
        }
        UINib *nib = [UINib nibWithNibName:xibName bundle:bundle];
        if (nib) {
            return nib;
        }
    }
    
    return nil;
}

/********
 *
 *  获取 imagebundle下的图片，适用于存放在,resources_bundles中的
 *
 ********/
UIImage *GetUIImageInPodeName(NSString *podName, NSString *imageName)
{
    NSString* bundlePath = bundlePathForPod(podName);
    if (bundlePath) {
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        NSString *imagePath = [bundle pathForResource:imageName ofType:@"png" inDirectory:nil];
        //图片路径是nil
        if (!imagePath.length) {
            if (imageName.length) {
                return [UIImage imageNamed:imageName];
            }
            return nil;
        }
        
        UIImage *image = [UIImage imageNamed:imagePath];
        if (image) {
            return image;
        }
    }
    
    return nil;
}

/**
 *
 *  获取bundle中的图片, 适用于存在某个bundle中的
 */
UIImage * GetImagefrombundle(NSString * bundleName, NSString *inDirectory, NSString *imageName)
{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"]];
    //没有找到bundle
    if (!bundle) {
        if (imageName.length) {
            return [UIImage imageNamed:imageName];
        }
        return nil;
    }
    
    NSString *imagePath = [bundle pathForResource:imageName ofType:@"png" inDirectory:inDirectory];
    //图片路径是nil
    if (!imagePath.length) {
        if (imageName.length) {
            return [UIImage imageNamed:imageName];
        }
        return nil;
    }
    
    UIImage *image = [UIImage imageNamed:imagePath];
    return image;
}

#pragma mark - /*** private ***/
NSArray *recursivePathsForResourcesOfType(NSString *type, NSString *name, NSString *directoryPath)
{    
    NSMutableArray *filePaths = [[NSMutableArray alloc] init];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:directoryPath];
    
    NSString *filePath;
    
    while ((filePath = [enumerator nextObject]) != nil){
        if (!type || [[filePath pathExtension] isEqualToString:type]){
            if (!name || [[[filePath lastPathComponent] stringByDeletingPathExtension] isEqualToString:name]){
                [filePaths addObject:[directoryPath stringByAppendingPathComponent:filePath]];
            }
        }
    }
    
    return filePaths;
}

NSBundle *bundleContainsPod(NSString *podName)
{
    // search all bundles
    for (NSBundle* bundle in [NSBundle allBundles]) {
        NSString* bundlePath = [bundle pathForResource:podName ofType:@"bundle"];
        if (bundlePath) { return bundle; }
    }
    
    // search all frameworks
    for (NSBundle* bundle in [NSBundle allBundles]) {
        NSArray* bundles = recursivePathsForResourcesOfType(@"bundle", podName ,[bundle bundlePath]);
        if (bundles.count > 0) {
            return bundle;
        }
    }
    
    // some pods do not use "resource_bundles"
    // please check the pod's podspec
    return nil;
}

NSString *bundlePathForPod(NSString *podName)
{
    // search all bundles
    for (NSBundle* bundle in [NSBundle allBundles]) {
        NSString* bundlePath = [bundle pathForResource:podName ofType:@"bundle"];
        if (bundlePath) { return bundlePath; }
    }
    
    // search all frameworks
    for (NSBundle* bundle in [NSBundle allBundles]) {
        NSArray* bundles = recursivePathsForResourcesOfType(@"bundle", podName ,[bundle bundlePath]);
        if (bundles.count > 0) {
            return bundles.firstObject;
        }
    }
    // some pods do not use "resource_bundles"
    // please check the pod's podspec
    return nil;
}

@end
