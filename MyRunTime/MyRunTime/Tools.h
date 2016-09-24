//
//  Tools.h
//  MyRunTime
//
//  Created by kefoqing on 16/9/23.
//  Copyright © 2016年 kefoqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject
+ (NSArray*)getClassIVarNames:(Class)kClass;
+ (NSArray*)getClassMethodList:(Class)kClass;
+ (NSArray*)getClassPropertyList:(Class)kClass;
+ (NSArray*)getClassProtocolList:(Class)kClass;
@end
