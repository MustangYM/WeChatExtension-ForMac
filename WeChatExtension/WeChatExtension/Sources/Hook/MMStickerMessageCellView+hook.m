//
//  MMStickerMessageCellView+hook.m
//  WeChatPlugin
//
//  Created by TK on 2018/2/23.
//  Copyright © 2018年 tk. All rights reserved.
//

#import "MMStickerMessageCellView+hook.h"
#import "WeChatPlugin.h"

@implementation NSObject (MMStickerMessageCellView)

+ (void)hookMMStickerMessageCellView {
    tk_hookMethod(objc_getClass("MMStickerMessageCellView"), @selector(contextMenu), [self class], @selector(hook_contextMenu));
    if (LargerOrEqualVersion(@"2.3.22")) {
         tk_hookMethod(objc_getClass("MMStickerMessageCellView"), @selector(contextMenuExport), [self class], @selector(hook_contextMenuExport));
    }
}

- (id)hook_contextMenu {
    NSMenu *menu = [self hook_contextMenu];
    if ([self.className isEqualToString:@"MMStickerMessageCellView"]) {
        NSMenuItem *copyItem = [[NSMenuItem alloc] initWithTitle:WXLocalizedString(@"Message.Menu.Copy") action:@selector(contextMenuCopyEmoji) keyEquivalent:@""];
        NSMenuItem *exportItem = [[NSMenuItem alloc] initWithTitle:WXLocalizedString(@"Message.Menu.Export") action:@selector(contextMenuExport) keyEquivalent:@""];
        [menu addItem:[NSMenuItem separatorItem]];
        [menu addItem:copyItem];
        [menu addItem:exportItem];
    }
    return menu;
}

- (void)contextMenuExport {
    [self exportEmoji];
}

- (void)hook_contextMenuExport {
    if (![self.className isEqualToString:@"MMStickerMessageCellView"]) {
        [self hook_contextMenu];
        return;
    }
    [self exportEmoji];
}

- (void)exportEmoji {
    MMStickerMessageCellView *currentCellView = (MMStickerMessageCellView *)self;
    MMMessageTableItem *item = currentCellView.messageTableItem;
    if (!item.message || !item.message.m_nsEmoticonMD5) {
        return;
    }
    EmoticonMgr *emoticonMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("EmoticonMgr")];
    NSData *imageData = [emoticonMgr getEmotionDataWithMD5:item.message.m_nsEmoticonMD5];
    if (!imageData) return;
    
    NSSavePanel *savePanel = ({
        NSSavePanel *panel = [NSSavePanel savePanel];
        [panel setDirectoryURL:[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Pictures"]]];
        [panel setNameFieldStringValue:item.message.m_nsEmoticonMD5];
        [panel setAllowedFileTypes:@[[NSObject getTypeForImageData:imageData]]];
        [panel setAllowsOtherFileTypes:YES];
        [panel setExtensionHidden:NO];
        [panel setCanCreateDirectories:YES];
        
        panel;
    });
    [savePanel beginSheetModalForWindow:currentCellView.delegate.view.window completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            [imageData writeToFile:[[savePanel URL] path] atomically:YES];
        }
    }];
}

- (void)contextMenuCopyEmoji {
    if ([self.className isEqualToString:@"MMStickerMessageCellView"]) {
        MMMessageTableItem *item = [self valueForKey:@"messageTableItem"];
        if (!item.message || !item.message.m_nsEmoticonMD5) {
            return;
        }
        EmoticonMgr *emoticonMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("EmoticonMgr")];
        NSData *imageData = [emoticonMgr getEmotionDataWithMD5:item.message.m_nsEmoticonMD5];
        if (!imageData) return;

        NSString *imageType = [NSObject getTypeForImageData:imageData];
        NSString *imageName = [NSString stringWithFormat:@"temp_paste_image_%@.%@", item.message.m_nsEmoticonMD5, imageType];
        NSString *tempImageFilePath = [NSTemporaryDirectory() stringByAppendingString:imageName];
        NSURL *imageUrl = [NSURL fileURLWithPath:tempImageFilePath];
        [imageData writeToURL:imageUrl atomically:YES];
        
        NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
        [pasteboard clearContents];
        [pasteboard declareTypes:@[NSFilenamesPboardType] owner:nil];
        [pasteboard writeObjects:@[imageUrl]];
    }
}

+ (NSString *)getTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        default:
            return @"jpg";
    }
    return nil;
}

@end
