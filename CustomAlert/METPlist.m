//
//  METPlist.m
//  MET
//
//  Created by Colin Kennedy on 5/29/13.
//  Copyright (c) 2013 Colin Kennedy. All rights reserved.
//

#import "METPlist.h"

@implementation METPlist
+ (NSDictionary *) loadData:(NSString *)dataPath {
	return [[NSDictionary alloc] initWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:dataPath]];
}

@end
