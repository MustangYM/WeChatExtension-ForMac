//
//  ANYMethodLog.m
//  ANYMethodLog
//
//  Created by qiuhaodong on 2019/1/14.
//  Copyright © 2019年 qiuhaodong. All rights reserved.
//
//  https://github.com/qhd/ANYMethodLog.git
//

#import "ANYMethodLog.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <Cocoa/Cocoa.h>

#pragma mark - deep

//调用层次
static int deep = -1;

#pragma mark - Func Define

BOOL qhd_isInBlackList(NSString *methodName);
NSDictionary *qhd_canHandleTypeDic(void);
BOOL qhd_isCanHandle(NSString *typeEncode);
SEL qhd_createNewSelector(SEL originalSelector);
BOOL qhd_isStructType(const char *argumentType);
NSString *qhd_structName(const char *argumentType);
BOOL isCGRect           (const char *type);
BOOL isCGPoint          (const char *type);
BOOL isCGSize           (const char *type);
BOOL isCGVector         (const char *type);
BOOL isUIOffset         (const char *type);
BOOL isUIEdgeInsets     (const char *type);
BOOL isCGAffineTransform(const char *type);
BOOL qhd_isCanHook(Method method, const char *returnType);
id getReturnValue(NSInvocation *invocation);
NSArray *qhd_method_arguments(NSInvocation *invocation);
void qhd_forwardInvocation(id target, SEL selector, NSInvocation *invocation);
BOOL qhd_replaceMethod(Class cls, SEL originSelector, char *returnType);
void qhd_logMethod(Class aClass, BOOL(^condition)(SEL sel));

#pragma mark - AMLBlock

@interface AMLBlock : NSObject

@property (strong, nonatomic) NSString *targetClassName;
@property (copy, nonatomic) ConditionBlock condition;
@property (copy, nonatomic) BeforeBlock before;
@property (copy, nonatomic) AfterBlock  after;

@end

@implementation AMLBlock

- (BOOL)runCondition:(SEL)sel {
    if (self.condition) {
        return self.condition(sel);
    } else {
        return YES;
    }
}

- (void)rundBefore:(id)target sel:(SEL)sel args:(NSArray *)args deep:(int) deep {
    if (self.before) {
        self.before(target, sel, args, deep);
    }
}

- (void)rundAfter:(id)target sel:(SEL)sel args:(NSArray *)args interval:(NSTimeInterval)interval deep:(int)deep retValue:(id)retValue{
    if (self.after) {
        self.after(target, sel, args, interval, deep, retValue);
    }
}

@end


#pragma mark - ANYMethodLog private interface

@interface ANYMethodLog()

@property (strong, nonatomic) NSMutableDictionary *blockCache;

+ (instancetype)sharedANYMethodLog;

- (void)setAMLBlock:(AMLBlock *)block forKey:(NSString *)aKey;

- (AMLBlock *)blockWithTarget:(id)target;

@end


#pragma mark - C function

#define SHARED_ANYMETHODLOG [ANYMethodLog sharedANYMethodLog]

//#define OPEN_TARGET_LOG

#ifdef OPEN_TARGET_LOG
#define TARGET_LOG(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define TARGET_LOG(format, ...)
#endif


//#define OPEN_DEV_LOG

#ifdef OPEN_DEV_LOG
#define DEV_LOG(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define DEV_LOG(format, ...)
#endif

//是否在默认的黑名单中
BOOL qhd_isInBlackList(NSString *methodName) {
    static NSArray *defaultBlackList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultBlackList = @[/*UIViewController的:*/@".cxx_destruct", @"dealloc", @"_isDeallocating", @"release", @"autorelease", @"retain", @"Retain", @"_tryRetain", @"copy", /*UIView的:*/ @"nsis_descriptionOfVariable:", /*NSObject的:*/@"respondsToSelector:", @"class", @"methodSignatureForSelector:", @"allowsWeakReference", @"retainWeakReference", @"init", @"forwardInvocation:"];
    });
    return ([defaultBlackList containsObject:methodName]);
}

/*reference: https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
 经实践发现与文档有差别
 1.在64位时@encode(long)跟@encode(long long)的值一样;
 2.在64位时@encode(unsigned long)跟@encode(unsigned long long)的值一样；
 3.在32位时@encode(BOOL)跟@encode(char)一样。
 +--------------------+-----------+-----------+
 | type               |code(32bit)|code(64bit)|
 |--------------------|-----------|-----------|
 | BOOL               |     c     |    B      |
 |--------------------|-----------|-----------|
 | char               |     c     |    c      |
 |--------------------|-----------|-----------|
 | long               |     l     |    q      |
 |--------------------|-----------|-----------|
 | long long          |     q     |    q      |
 |--------------------|-----------|-----------|
 | unsigned long      |     L     |    Q      |
 |--------------------|-----------|-----------|
 | unsigned long long |     Q     |    Q      |
 +--------------------+-----------+-----------+
 */
NSDictionary *qhd_canHandleTypeDic() {
    static NSDictionary *dic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{[NSString stringWithUTF8String:@encode(char)] : @"(char)",
                [NSString stringWithUTF8String:@encode(int)] : @"(int)",
                [NSString stringWithUTF8String:@encode(short)] : @"(short)",
                [NSString stringWithUTF8String:@encode(long)] : @"(long)",
                [NSString stringWithUTF8String:@encode(long long)] : @"(long long)",
                [NSString stringWithUTF8String:@encode(unsigned char)] : @"(unsigned char))",
                [NSString stringWithUTF8String:@encode(unsigned int)] : @"(unsigned int)",
                [NSString stringWithUTF8String:@encode(unsigned short)] : @"(unsigned short)",
                [NSString stringWithUTF8String:@encode(unsigned long)] : @"(unsigned long)",
                [NSString stringWithUTF8String:@encode(unsigned long long)] : @"(unsigned long long)",
                [NSString stringWithUTF8String:@encode(float)] : @"(float)",
                [NSString stringWithUTF8String:@encode(double)] : @"(double)",
                [NSString stringWithUTF8String:@encode(BOOL)] : @"(BOOL)",
                [NSString stringWithUTF8String:@encode(void)] : @"(void)",
                [NSString stringWithUTF8String:@encode(char *)] : @"(char *)",
                [NSString stringWithUTF8String:@encode(id)] : @"(id)",
                [NSString stringWithUTF8String:@encode(Class)] : @"(Class)",
                [NSString stringWithUTF8String:@encode(SEL)] : @"(SEL)",
                [NSString stringWithUTF8String:@encode(CGRect)] : @"(CGRect)",
                [NSString stringWithUTF8String:@encode(CGPoint)] : @"(CGPoint)",
                [NSString stringWithUTF8String:@encode(CGSize)] : @"(CGSize)",
                [NSString stringWithUTF8String:@encode(CGVector)] : @"(CGVector)",
                [NSString stringWithUTF8String:@encode(CGAffineTransform)] : @"(CGAffineTransform)",
//                [NSString stringWithUTF8String:@encode(UIOffset)] : @"(UIOffset)",
                [NSString stringWithUTF8String:@encode(NSEdgeInsets)] : @"(NSEdgeInsets)",
                @"o^@" : @"(id*)",
                @"@?":@"(block)" // block类型
                };//TODO:添加其他类型
        
        DEV_LOG(@"arg types:%@", dic);
    });
    return dic;
}

//根据定义的类型的判断是否能处理
BOOL qhd_isCanHandle(NSString *typeEncode) {
    return [qhd_canHandleTypeDic().allKeys containsObject:typeEncode];
}

//创建一个新的selector
SEL qhd_createNewSelector(SEL originalSelector) {
    NSString *oldSelectorName = NSStringFromSelector(originalSelector);
    NSString *newSelectorName = [NSString stringWithFormat:@"qhd_%@", oldSelectorName];
    SEL newSelector = NSSelectorFromString(newSelectorName);
    return newSelector;
}

//是否struct类型
BOOL qhd_isStructType(const char *argumentType) {
    NSString *typeString = [NSString stringWithUTF8String:argumentType];
    return ([typeString hasPrefix:@"{"] && [typeString hasSuffix:@"}"]);
}

//struct类型名
NSString *qhd_structName(const char *argumentType) {
    NSString *typeString = [NSString stringWithUTF8String:argumentType];
    NSUInteger start = [typeString rangeOfString:@"{"].location;
    NSUInteger end = [typeString rangeOfString:@"="].location;
    if (end > start) {
        return [typeString substringWithRange:NSMakeRange(start + 1, end - start - 1)];
    } else {
        return nil;
    }
}

BOOL isCGRect           (const char *type) {return [qhd_structName(type) isEqualToString:@"CGRect"];}
BOOL isCGPoint          (const char *type) {return [qhd_structName(type) isEqualToString:@"CGPoint"];}
BOOL isCGSize           (const char *type) {return [qhd_structName(type) isEqualToString:@"CGSize"];}
BOOL isCGVector         (const char *type) {return [qhd_structName(type) isEqualToString:@"CGVector"];}
BOOL isUIOffset         (const char *type) {return [qhd_structName(type) isEqualToString:@"UIOffset"];}
BOOL isUIEdgeInsets     (const char *type) {return [qhd_structName(type) isEqualToString:@"UIEdgeInsets"];}
BOOL isCGAffineTransform(const char *type) {return [qhd_structName(type) isEqualToString:@"CGAffineTransform"];}

//检查是否能处理
BOOL qhd_isCanHook(Method method, const char *returnType) {
    
    //若在黑名单中则不处理
    NSString *selectorName = NSStringFromSelector(method_getName(method));
    if (qhd_isInBlackList(selectorName)) {
        return NO;
    }
    
    if ([selectorName rangeOfString:@"qhd_"].location != NSNotFound) {
        return NO;
    }
    
    NSString *returnTypeString = [NSString stringWithUTF8String:returnType];
    
    BOOL isCanHook = YES;
    if (!qhd_isCanHandle(returnTypeString)) {
        isCanHook = NO;
    }
    for(int k = 2 ; k < method_getNumberOfArguments(method); k ++) {
        char argument[250];
        memset(argument, 0, sizeof(argument));
        method_getArgumentType(method, k, argument, sizeof(argument));
        NSString *argumentString = [NSString stringWithUTF8String:argument];
        if (!qhd_isCanHandle(argumentString)) {
            DEV_LOG(@"unknow arg type:%@", argumentString);
            isCanHook = NO;
            break;
        }
    }
    return isCanHook;
}

//获取方法返回值
id getReturnValue(NSInvocation *invocation){
    const char *returnType = invocation.methodSignature.methodReturnType;
    if (returnType[0] == 'r') {
        returnType++;
    }
    #define WRAP_GET_VALUE(type) \
    do { \
        type val = 0; \
        [invocation getReturnValue:&val]; \
        return @(val); \
    } while (0)
    if (strcmp(returnType, @encode(id)) == 0 || strcmp(returnType, @encode(Class)) == 0 || strcmp(returnType, @encode(void (^)(void))) == 0) {
        __autoreleasing id returnObj;
        [invocation getReturnValue:&returnObj];
        return returnObj;
    } else if (strcmp(returnType, @encode(char)) == 0) {
        WRAP_GET_VALUE(char);
    } else if (strcmp(returnType, @encode(int)) == 0) {
        WRAP_GET_VALUE(int);
    } else if (strcmp(returnType, @encode(short)) == 0) {
        WRAP_GET_VALUE(short);
    } else if (strcmp(returnType, @encode(long)) == 0) {
        WRAP_GET_VALUE(long);
    } else if (strcmp(returnType, @encode(long long)) == 0) {
        WRAP_GET_VALUE(long long);
    } else if (strcmp(returnType, @encode(unsigned char)) == 0) {
        WRAP_GET_VALUE(unsigned char);
    } else if (strcmp(returnType, @encode(unsigned int)) == 0) {
        WRAP_GET_VALUE(unsigned int);
    } else if (strcmp(returnType, @encode(unsigned short)) == 0) {
        WRAP_GET_VALUE(unsigned short);
    } else if (strcmp(returnType, @encode(unsigned long)) == 0) {
        WRAP_GET_VALUE(unsigned long);
    } else if (strcmp(returnType, @encode(unsigned long long)) == 0) {
        WRAP_GET_VALUE(unsigned long long);
    } else if (strcmp(returnType, @encode(float)) == 0) {
        WRAP_GET_VALUE(float);
    } else if (strcmp(returnType, @encode(double)) == 0) {
        WRAP_GET_VALUE(double);
    } else if (strcmp(returnType, @encode(BOOL)) == 0) {
        WRAP_GET_VALUE(BOOL);
    } else if (strcmp(returnType, @encode(char *)) == 0) {
        WRAP_GET_VALUE(const char *);
    } else if (strcmp(returnType, @encode(void)) == 0) {
        return @"void";
    } else {
        NSUInteger valueSize = 0;
        NSGetSizeAndAlignment(returnType, &valueSize, NULL);
        unsigned char valueBytes[valueSize];
        [invocation getReturnValue:valueBytes];
        
        return [NSValue valueWithBytes:valueBytes objCType:returnType];
    }
    return nil;
}

//获取方法参数
NSArray *qhd_method_arguments(NSInvocation *invocation) {
    NSMethodSignature *methodSignature = [invocation methodSignature];
    NSMutableArray *argList = (methodSignature.numberOfArguments > 2 ? [NSMutableArray array] : nil);
    for (NSUInteger i = 2; i < methodSignature.numberOfArguments; i++) {
        const char *argumentType = [methodSignature getArgumentTypeAtIndex:i];
        id arg = nil;
        
        if (qhd_isStructType(argumentType)) {
            #define GET_STRUCT_ARGUMENT(_type)\
                if (is##_type(argumentType)) {\
                    _type arg_temp;\
                    [invocation getArgument:&arg_temp atIndex:i];\
                    arg = NSStringFrom##_type(arg_temp);\
                }
//            GET_STRUCT_ARGUMENT(CGRect)
//            else GET_STRUCT_ARGUMENT(CGPoint)
//            else GET_STRUCT_ARGUMENT(CGSize)
//            else GET_STRUCT_ARGUMENT(CGVector)
//            else GET_STRUCT_ARGUMENT(UIOffset)
//            else GET_STRUCT_ARGUMENT(UIEdgeInsets)
//            else GET_STRUCT_ARGUMENT(CGAffineTransform)
            
            if (arg == nil) {
                arg = @"{unknown}";
            }
        }
        #define GET_ARGUMENT(_type)\
            if (0 == strcmp(argumentType, @encode(_type))) {\
                _type arg_temp;\
                [invocation getArgument:&arg_temp atIndex:i];\
                arg = @(arg_temp);\
            }
        else GET_ARGUMENT(char)
        else GET_ARGUMENT(int)
        else GET_ARGUMENT(short)
        else GET_ARGUMENT(long)
        else GET_ARGUMENT(long long)
        else GET_ARGUMENT(unsigned char)
        else GET_ARGUMENT(unsigned int)
        else GET_ARGUMENT(unsigned short)
        else GET_ARGUMENT(unsigned long)
        else GET_ARGUMENT(unsigned long long)
        else GET_ARGUMENT(float)
        else GET_ARGUMENT(double)
        else GET_ARGUMENT(BOOL)
        else if (0 == strcmp(argumentType, @encode(id))) {
            __unsafe_unretained id arg_temp;
            [invocation getArgument:&arg_temp atIndex:i];
            arg = arg_temp;
            if (!arg) {
                arg = @"nil";
            }
        }
        else if (0 == strcmp(argumentType, "o^@")) {
            void ** arg_temp;
            [invocation getArgument:&arg_temp atIndex:i];
            arg = (__bridge id)(*arg_temp);
            if (!arg) {
                arg = @"*nil";
            }
        }
        else if (0 == strcmp(argumentType, @encode(SEL))) {
            SEL arg_temp;
            [invocation getArgument:&arg_temp atIndex:i];
            arg = NSStringFromSelector(arg_temp);
        }
        else if (0 == strcmp(argumentType, @encode(char *))) {
            char *arg_temp;
            [invocation getArgument:&arg_temp atIndex:i];
            arg = [NSString stringWithUTF8String:arg_temp];
        }
        else if (0 == strcmp(argumentType, @encode(void *))) {
            void *arg_temp;
            [invocation getArgument:&arg_temp atIndex:i];
            arg = (__bridge id _Nonnull)arg_temp;
        }
        else if (0 == strcmp(argumentType, @encode(Class))) {
            Class arg_temp;
            [invocation getArgument:&arg_temp atIndex:i];
            arg = arg_temp;
        }
        
        if (!arg) {
            arg = [NSString stringWithFormat:@"%s:unknown", argumentType];
        }
        [argList addObject:arg];
    }
    return argList;
}

//forwardInvocation:方法的新IMP
void qhd_forwardInvocation(id target, SEL selector, NSInvocation *invocation) {
    NSArray *argList = qhd_method_arguments(invocation);
    
    SEL originSelector = invocation.selector;
    
    NSString *originSelectorString = NSStringFromSelector(originSelector);
    
    //友盟的UMAOCTools会产生问题
    if ([originSelectorString rangeOfString:@"hook_"].location != NSNotFound) {
        return;
    }
    
    [invocation setSelector:qhd_createNewSelector(originSelector)];
    [invocation setTarget:target];
    
    deep++;
    
    AMLBlock *block = [SHARED_ANYMETHODLOG blockWithTarget:target];
    [block rundBefore:target sel:originSelector args:argList deep:deep];
    
    NSDate *start = [NSDate date];
    
    [invocation invoke];
    
    NSDate *end = [NSDate date];
    NSTimeInterval interval = [end timeIntervalSinceDate:start];
    
    [block rundAfter:target sel:originSelector args:argList interval:interval deep:deep retValue:getReturnValue(invocation)];
    
    deep--;
}

//替换方法
BOOL qhd_replaceMethod(Class cls, SEL originSelector, char *returnType) {
    Method originMethod = class_getInstanceMethod(cls, originSelector);
    if (originMethod == nil) {
        return NO;
    }
    const char *originTypes = method_getTypeEncoding(originMethod);
    IMP msgForwardIMP = _objc_msgForward;
#if !defined(__arm64__)
    if (qhd_isStructType(returnType)) {
        //Reference JSPatch:
        //In some cases that returns struct, we should use the '_stret' API:
        //http://sealiesoftware.com/blog/archive/2008/10/30/objc_explain_objc_msgSend_stret.html
        //NSMethodSignature knows the detail but has no API to return, we can only get the info from debugDescription.
        NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:originTypes];
        if ([methodSignature.debugDescription rangeOfString:@"is special struct return? YES"].location != NSNotFound) {
            msgForwardIMP = (IMP)_objc_msgForward_stret;
        }
    }
#endif
    
    IMP originIMP = method_getImplementation(originMethod);
    
    if (originIMP == nil || originIMP == msgForwardIMP) {
        return NO;
    }
    
    //把原方法的IMP换成_objc_msgForward，使之触发forwardInvocation方法
    class_replaceMethod(cls, originSelector, msgForwardIMP, originTypes);
    
    //把方法forwardInvocation的IMP换成qhd_forwardInvocation
    class_replaceMethod(cls, @selector(forwardInvocation:), (IMP)qhd_forwardInvocation, "v@:@");
    
    //创建一个新方法，IMP就是原方法的原来的IMP，那么只要在qhd_forwardInvocation调用新方法即可
    SEL newSelecotr = qhd_createNewSelector(originSelector);
    BOOL isAdd = class_addMethod(cls, newSelecotr, originIMP, originTypes);
    if (!isAdd) {
        DEV_LOG(@"class_addMethod fail");
    }
    
    return YES;
}

void qhd_logMethod(Class aClass, BOOL(^condition)(SEL sel)) {
    unsigned int outCount;
    Method *methods = class_copyMethodList(aClass,&outCount);
    
    for (int i = 0; i < outCount; i ++) {
        Method tempMethod = *(methods + i);
        SEL selector = method_getName(tempMethod);
        char *returnType = method_copyReturnType(tempMethod);
        
        BOOL isCan = qhd_isCanHook(tempMethod, returnType);
        
        if (isCan && condition) {
            isCan = condition(selector);
        }
        
        if (isCan) {
            if (qhd_replaceMethod(aClass, selector, returnType)) {
                DEV_LOG(@"success hook method:%@ types:%s", NSStringFromSelector(selector), method_getDescription(tempMethod)->types);
            } else {
                DEV_LOG(@"fail method:%@ types:%s", NSStringFromSelector(selector), method_getDescription(tempMethod)->types);
            }
        } else {
            DEV_LOG(@"can not hook method:%@ types:%s", NSStringFromSelector(selector), method_getDescription(tempMethod)->types);
        }
        free(returnType);
    }
    free(methods);
}


#pragma mark - ANYMethodLog implementation

@implementation ANYMethodLog

+ (void)logMethodWithClass:(Class)aClass
                 condition:(ConditionBlock) condition
                    before:(BeforeBlock) before
                     after:(AfterBlock) after {
    #ifndef DEBUG
        return;
    #endif
    
    if (aClass) {
        AMLBlock *block = [[AMLBlock alloc] init];
        block.targetClassName = NSStringFromClass(aClass);
        block.condition = condition;
        block.before = before;
        block.after = after;
        [SHARED_ANYMETHODLOG setAMLBlock:block forKey:block.targetClassName];
    }
    
    qhd_logMethod(aClass, condition);
    
    //获取元类，处理类方法。（注意获取元类是用object_getClass，而不是class_getSuperclass）
    Class metaClass = object_getClass(aClass);
    qhd_logMethod(metaClass, condition);
}

+ (instancetype)sharedANYMethodLog {
    static ANYMethodLog *_sharedANYMethodLog = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedANYMethodLog = [[self alloc] init];
        _sharedANYMethodLog.blockCache = [NSMutableDictionary dictionary];
    });
    return _sharedANYMethodLog;
}

- (void)setAMLBlock:(AMLBlock *)block forKey:(NSString *)aKey {
    @synchronized (self) {
        [self.blockCache setObject:block forKey:aKey];
    }
}

- (AMLBlock *)blockWithTarget:(id)target {
    Class class = [target class];
    AMLBlock *block = [self.blockCache objectForKey:NSStringFromClass(class)];
    while (block == nil) {
        class = [class superclass];
        if (class == nil) {
            break;
        }
        block = [self.blockCache objectForKey:NSStringFromClass(class)];
    }
    return block;
}

@end
