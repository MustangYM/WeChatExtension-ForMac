//
//  YMDownloadManager.h
//
//  Created by MustangYM on 2019/2/20.
//  Copyright © 2019 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMDownloadManager : NSObject
- (void)downloadImageWithMsg:(MessageData *)msg;
- (void)downloadVideoWithMsg:(MessageData *)msg;
@end

