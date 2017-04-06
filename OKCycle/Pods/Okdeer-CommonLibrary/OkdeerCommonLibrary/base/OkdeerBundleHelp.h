//
//  OkdeerBundleHelp.h
//  OkdeerCommonLibrary
//
//  Created by zichen0422 on 17/1/5.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OkdeerBundleHelp : NSObject

/********
 *
 *  根据名称获取对应的bundle,适用于存放在,resources_bundles中的
 *
 ********/
NSBundle *bundleForPod(NSString *podName);

/********
 *
 *  根据xib 名称获取对应的UINib 名称,适用于存放在,resources_bundles中的
 *
 ********/
UIStoryboard *GetStoryBoardFromPodName(NSString *podName, NSString *storyName);

/********
 *
 *  根据xib 名称获取对应的UINib 名称,适用于存放在,resources_bundles中的
 *
 ********/
UINib *GetNibFromPodName(NSString *podName, NSString *xibName);


/********
 *
 *  获取 imagebundle下的图片，适用于存放在,resources_bundles中的
 *
 ********/
UIImage *GetUIImageInPodeName(NSString *podName, NSString *imageName);

/**
 *
 *  获取bundle中的图片, 适用于存在某个bundle中的
 */
UIImage * GetImagefrombundle(NSString * bundleName, NSString *inDirectory, NSString *imageName);

@end
