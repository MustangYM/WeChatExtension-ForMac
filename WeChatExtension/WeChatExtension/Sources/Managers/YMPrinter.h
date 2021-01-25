//
//  YMPrinter.h
//  SMS
//
//  Created by Mu on 2019/8/1.
//

#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMPrinter : NSObject

+ (NSString *)printBlock:(id)aBlock;
+ (NSString *)callStackSymbolsLocateInImages:(NSArray <NSString *>*)images;

@end

NS_ASSUME_NONNULL_END


/* block 内存结构
 struct Block_literal_1 {
 void *isa; //16byte initialized to &_NSConcreteStackBlock or &_NSConcreteGlobalBlock
 int flags; //8byte
 int reserved; //8byte
 void (*invoke)(void *, ...); //16byte
 struct Block_descriptor_1 { //16byte
 unsigned long int reserved;         //16byte NULL
 unsigned long int size;         //16byte sizeof(struct Block_literal_1)
 // optional helper functions
 void (*copy_helper)(void *dst, void *src);     //16byte IFF (1<<25)
 void (*dispose_helper)(void *src);             //16byte IFF (1<<25)
 // required ABI.2010.3.16
 const char *signature;                         //16byte IFF (1<<30)
 } *descriptor;
 // imported variables
 };
 
 struct BlockLiteral {
 void *isa;
 int flags;
 int reserved;
 void (*invoke)(void *, ...);
 struct BlockDescriptor *descriptor;
 };
 
 struct BlockDescriptor {
 unsigned long int reserved;
 unsigned long int size;
 void (*copy_helper)(void *dst, void *src);
 void (*dispose_helper)(void *src);
 const char *signature;
 };
 
 */
