//
//  OkdeerCommonLibrary.h
//  OkdeerCommonLibrary
//
//  Created by Mac on 16/12/28.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#if __has_include(<Okdeer-CommonLibrary/OkdeerCommonLibrary.h>)

// --- headerFile
#import <Okdeer-CommonLibrary/OkdeerCommDefine.h>
#import <Okdeer-CommonLibrary/OkdeerNumberEnum.h>
#import <Okdeer-CommonLibrary/OkdeerTextColorHeader.h>

// --- base
#import <Okdeer-CommonLibrary/OkdeerCrashHandle.h>
#import <Okdeer-CommonLibrary/OkdeerLoggerHandle.h>
#import <Okdeer-CommonLibrary/OkdeerTimer.h>

// --- extension
#import <Okdeer-CommonLibrary/UIColor+OKHexValue.h>
#import <Okdeer-CommonLibrary/NSString+OKExtension.h>
#import <Okdeer-CommonLibrary/UIViewController+Okdeer.h>

// --- view
//#import <Okdeer-CommonLibrary/OkdeerMMPickerView.h>
//#import <Okdeer-CommonLibrary/OkdeerPointAddView.h>
//#import <Okdeer-CommonLibrary/OkdeerSearchRecordView.h>

#else

// --- headerFile
#import "OkdeerCommDefine.h"
#import "OkdeerNumberEnum.h"
#import "OkdeerTextColorHeader.h"

// --- base
#import "OkdeerCrashHandle.h"
#import "OkdeerLoggerHandle.h"
#import "OkdeerTimer.h"

// --- extension
#import "UIColor+OKHexValue.h"
#import "UIViewController+Okdeer.h"

// --- View
#import "OkdeerMMPickerView.h"
#import "OkdeerPointAddView.h"
#import "OkdeerSearchRecordView.h"


#endif

