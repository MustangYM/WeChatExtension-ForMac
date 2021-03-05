//
//  YMPrinter.m
//  SMS
//
//  Created by Mu on 2019/8/1.
//

#import "YMPrinter.h"

@implementation YMPrinter

+ (NSString *)callStackSymbolsLocateInImages:(NSArray <NSString *>*)images{
    
    NSArray <NSString *>*preSetImages = [@[
                                           @"libdyld.dylib",
                                           @"UIKit",
                                           @"GraphicsServices",
                                           @"CoreFoundation",
                                           @"Foundation",
                                           ] mutableCopy];
    
    NSMutableDictionary <NSString *, NSNumber *>*baseAddrDic = [[NSMutableDictionary alloc]init];
    
    for(int i = 0; i < _dyld_image_count(); i++)
    {
        intptr_t  base_addr = _dyld_get_image_vmaddr_slide(i);
        const char *name = _dyld_get_image_name(i);
        NSString *nameStr = [NSString stringWithUTF8String:name];
        
        if ([images containsObject:[nameStr lastPathComponent]] ||
            [preSetImages containsObject:[nameStr lastPathComponent]]) {
            [baseAddrDic setObject:@(base_addr) forKey:[nameStr lastPathComponent]];
        }
    }
    
    NSArray <NSString *>*syms = [NSThread  callStackSymbols];
    
    NSMutableString *retStr = [[NSMutableString alloc]init];
    [retStr appendString:@"\n\n/***ZLJ CallStackSymbols Start***/\n"];
    for (NSString *sym in syms) {
        
        NSMutableArray <NSString *>*symUnits = [[sym componentsSeparatedByString:@" "] mutableCopy];
        while ([symUnits containsObject:@""]) {
            [symUnits removeObject:@""];
        }
        
        if (symUnits.count >= 3 && [symUnits[2] hasPrefix:@"0x"]) {
            
            char *symVMAddrStr = (char *)symUnits[2].UTF8String;
            char *endPtr;
            NSInteger symVMAddr = strtol(symVMAddrStr, &endPtr, 16);
            
            if ([baseAddrDic.allKeys containsObject:symUnits[1]]) {
                NSInteger symFileAddr = symVMAddr - [baseAddrDic objectForKey:symUnits[1]].integerValue;
                [retStr appendFormat:@"%@  symFileAddr 0x%lx\n", sym, symFileAddr];
            }else{
                [retStr appendFormat:@"%@\n", sym];
            }
            
        }else{
            [retStr appendFormat:@"%@\n", sym];
        }
    }
    [retStr appendString:@"/***ZLJ CallStackSymbols End***/\n\n"];
    
    NSLog(@"%@",retStr);
    
    return retStr;
}


+ (NSString *)printBlock:(id)aBlock{
    
    if (!([aBlock isKindOfClass:NSClassFromString(@"__NSGlobalBlock__")] ||
          [aBlock isKindOfClass:NSClassFromString(@"__NSMallocBlock__")] ||
          [aBlock isKindOfClass:NSClassFromString(@"__NSStackBlock__")]    )) {
        return @"ZLJBlockPrinter Error: Not A Block!";
    }
    
    uint64_t blockInMemory[4];      //block 在内存中的前4个uint64_t
    uint64_t descriptor[5];         //block的descriptor 在内存中的前5个uint64_t
    char *signatureCStr;
    NSMethodSignature *blockSignature;
    
    void *aBlockPtr = (__bridge void *)(aBlock);
    memcpy(blockInMemory, (void *)aBlockPtr, sizeof(blockInMemory));
    memcpy(descriptor, (void *)blockInMemory[3], sizeof(descriptor));
    
    BOOL hasSignature = ((blockInMemory[1] & 0x00000000FFFFFFFF)  & (1 << 30)) != 0;
    if (!hasSignature) {
        return @"ZLJBlockPrinter: Block Do Not Have Signature!";
    }
    
    BOOL hasCopyDisposeHelper = ((blockInMemory[1] & 0x00000000FFFFFFFF)  & (1 << 25)) != 0;
    
    if (hasCopyDisposeHelper) {
        signatureCStr = (char *)descriptor[4];
    }else{
        signatureCStr = (char *)descriptor[2];
    }
    blockSignature = [NSMethodSignature signatureWithObjCTypes:signatureCStr];
    
    NSString *retStr = [NSString stringWithFormat:@"\n%@\nBlockVmaddrSlide:0x%llx\nBlockSignature:%@",
                        aBlock,
                        blockInMemory[2],
                        blockSignature.debugDescription];
    NSLog(@"%@",retStr);
    
    return retStr;
}

//+ (NSString *)printBlock:(id)aBlock inImage:(nullable NSString *)imageName{
//
//    if (!([aBlock isKindOfClass:NSClassFromString(@"__NSGlobalBlock__")] ||
//          [aBlock isKindOfClass:NSClassFromString(@"__NSMallocBlock__")] ||
//          [aBlock isKindOfClass:NSClassFromString(@"__NSStackBlock__")]    )) {
//        return @"ZLJBlockPrinter Error: Not A Block!";
//    }
//
//    uint64_t blockInMemory[4];      //block 在内存中的前4个uint64_t
//    uint64_t descriptor[5];         //block的descriptor 在内存中的前5个uint64_t
//    char *signatureCStr;
//    NSMethodSignature *blockSignature;
//
//    void *aBlockPtr = (__bridge void *)(aBlock);
//    memcpy(blockInMemory, (void *)aBlockPtr, sizeof(blockInMemory));
//    memcpy(descriptor, (void *)blockInMemory[3], sizeof(descriptor));
//
//    BOOL hasSignature = ((blockInMemory[1] & 0x00000000FFFFFFFF)  & (1 << 30)) != 0;
//    if (!hasSignature) {
//        return @"ZLJBlockPrinter: Block Do Not Have Signature!";
//    }
//
//
//    BOOL hasCopyDisposeHelper = ((blockInMemory[1] & 0x00000000FFFFFFFF)  & (1 << 25)) != 0;
//
//    if (hasCopyDisposeHelper) {
//        signatureCStr = (char *)descriptor[4];
//    }else{
//        signatureCStr = (char *)descriptor[2];
//    }
//    blockSignature = [NSMethodSignature signatureWithObjCTypes:signatureCStr];
//
//
//    uint64_t block_file_slide = 0;
//    if (imageName.length && [aBlock isKindOfClass:NSClassFromString(@"__NSGlobalBlock__")]) {
//        NSInteger image_vmaddr_slide = 0;
//        for(int i = 0; i < _dyld_image_count(); i++)
//        {
//            const char *name = _dyld_get_image_name(i);
//            NSString *nameStr = [NSString stringWithUTF8String:name];
//            if ([nameStr containsString:imageName]) {
//                image_vmaddr_slide = _dyld_get_image_vmaddr_slide(i);
//                break;
//            }
//        }
//        block_file_slide = blockInMemory[2] - image_vmaddr_slide;
//    }
//
//    NSString *ret = nil;
//    if (imageName.length && [aBlock isKindOfClass:NSClassFromString(@"__NSGlobalBlock__")]) {
//        ret = [NSString stringWithFormat:@"\n%@\nBlockVmaddrSlide(Check This Address In LLDB):0x%llx\nBlockFileSlide(Jump To This Address In IDA):0x%llx\nBlockSignature:%@", [aBlock class], blockInMemory[2], block_file_slide, blockSignature.debugDescription];
//    }else{
//        ret = [NSString stringWithFormat:@"\n%@\nBlockVmaddrSlide(Check This Address In LLDB):0x%llx\nBlockSignature:%@", aBlock, blockInMemory[2], blockSignature.debugDescription];
//    }
//
//    return ret;
//}


@end
