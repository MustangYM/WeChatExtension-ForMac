//
//  TCBlobDownloader.h
//
//  Created by Thibault Charbonnier on 15/04/13.
//  Copyright (c) 2013 Thibault Charbonnier. All rights reserved.
//

#define NO_LOG
#if defined(DEBUG) && !defined(NO_LOG)
    #define TCLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
    #define TCLog(format, ...)
#endif

#import <Foundation/Foundation.h>

/**
 When a download fails because of an HTTP error, the HTTP status code is transmitted as an `NSNumber` via the provided `NSError` parameter of the corresponding block or delegate method. Access to `error.userInfos[TCBlobDownloadErrorHTTPStatusKey]`
 
 @see -download:didStopWithError:
 
 @since 1.5.0
 */
extern NSString * const TCBlobDownloadErrorHTTPStatusKey;

/**
 TCBlobDownload specific errors
 
 @since 2.1.0
*/
extern NSString * const TCBlobDownloadErrorDomain;

/**
 The possible error codes for a `TCBlobDownloader` operation. When an error block or the corresponding delegate method are called, an `NSError` instance is passed as parameter. If the domain of this `NSError` is TCBlobDownload's, the `code` parameter will be set to one of these values.
 
 @since 1.5.0
 */
typedef NS_ENUM(NSUInteger, TCBlobDownloadError) {
    /** `NSURLConnection` was unable to handle the provided request. */
    TCBlobDownloadErrorInvalidURL = 0,
    /** The connection encountered an HTTP error. Please refer to `TCHTTPStatusCode` documentation for further details on how to handle such errors. */
    TCBlobDownloadErrorHTTPError,
    /** The device has not enough free disk space to download the file. */
    TCBlobDownloadErrorNotEnoughFreeDiskSpace
};

/**
 The current state of the download.
 
 @since 1.5.2
 */
typedef NS_ENUM(NSUInteger, TCBlobDownloadState) {
    /** The download is instanciated but has not been started yet. */
    TCBlobDownloadStateReady = 0,
    /** The download has started the HTTP connection to retrieve the file. */
    TCBlobDownloadStateDownloading,
    /** The download has been completed successfully. */
    TCBlobDownloadStateDone,
    /** The download has been cancelled manually. */
    TCBlobDownloadStateCancelled,
    /** The download failed, probably because of an error. It is possible to access the error in the appropriate delegate method or block property. */
    TCBlobDownloadStateFailed
};

@protocol TCBlobDownloaderDelegate;


#pragma mark - TCBlobDownloader


/**
 `TCBlobDownloader` is a subclass of Cocoa's `NSOperation`. It's purpose is to be executed by the `TCBlobDownloaderManager` singleton to download large files in background threads.
 
 Each `TCBlobDownloader` instance will run in a background thread and will download files via an `NSURLConnection`. Each `TCBlobDownloader` can depend (or not) of a `TCBlobDownloaderDelegate` or use blocks to notify your UI from its status.
 
 @see TCBlobDownloaderDelegate protocol
 
 @since 1.0
 */
@interface TCBlobDownloader : NSOperation <NSURLConnectionDelegate>

/**
 The delegate property of a `TCBlobDownloader` instance. Can be `nil`.
 
 @since 1.0
 */
@property (nonatomic, unsafe_unretained) id<TCBlobDownloaderDelegate> delegate;

/**
 The directory where the file is being downloaded.

 @since 1.0
 */
@property (nonatomic, copy, readonly) NSString *pathToDownloadDirectory;

/**
 The path to the downloaded file, including the file name.
 
 @warning You should not set this property directly as the file name is managed by the library.
 
 @since 1.0
 */
@property (nonatomic, copy, readonly, getter = pathToFile) NSString *pathToFile;

/**
 The URL of the file to download.
 
 @warning You should not set this property directly, as it is managed by the initialization method.
 
 @since 1.0
 */
@property (nonatomic, copy, readonly) NSURL *downloadURL;

/**
 The NSMutableURLRequest that will be performed by the NSURLConnection. Use this object to pass custom headers to your request if needed.
 
 @since 1.6.0
 */
@property (nonatomic, strong, readonly) NSMutableURLRequest *fileRequest;

/**
 If not manually set, the file name, which is by default based on the last path component of the download URL.
 
 ## Note
 
 You should not change the file name during the download process. The file name of a file downloaded by TCBlobDownload is the last part of the URL used to download it. This allow TCBlobDownload to check if a part of that file has already been downloaded and if so, retrieve the downloaded from where it has previously stopped. It is up to you to manage your download paths to avoid downloading 2 files with the same name.

 You can change the file name once the file has been downloaded in the completion block or the appropriate delegate method.
 
 @see TCBlobDownloaderDelegate protocol
 
 @warning It is not recommended to set this property directly, as it is retrieved from the download URL and will allow you to resume a download from where it stopped.
 
 @since 1.0
 */
@property (nonatomic, copy, getter = fileName) NSString *fileName;

/**
 The current speed of the download in bits/sec. This property updates itself regularly so you can retrieve it on a regular interval to update your UI.
 
 @since 1.5.0
 */
@property (nonatomic, assign, readonly) NSInteger speedRate;

/**
 The estimated number of seconds before the download completes.
 
 `-1` if the remaining time has not been calculated yet.
 
 @since 1.5.0
 */
@property (nonatomic, assign, readonly, getter = remainingTime) NSInteger remainingTime;

/**
 Current progress of the download.
 
 Value between 0 and 1
 */
@property (nonatomic, assign, readonly, getter = progress) float progress;

/**
 Current state of the download.
 */
@property (nonatomic, assign, readonly) TCBlobDownloadState state;

/**
 Instanciates a `TCBlobDownloader` object with delegate. `TCBlobDownloader` objects instanciated this way will not be executed until they are passed to the `TCBlobDownloaderManager` singleton.
 
 @see startDownload:
 
 @param url  The URL from where to download the file.
 @param pathToDLOrNil  An optional path to override the default download path of the `TCBlobDownloaderManager` instance. Can be `nil`.
 @param delegateOrNil  An optional delegate. Can be `nil`.
 @return The newly created `TCBlobDownloader`.
 
 @since 1.0
 */
- (instancetype)initWithURL:(NSURL *)url
               downloadPath:(NSString *)pathToDL
                   delegate:(id<TCBlobDownloaderDelegate>)delegateOrNil;

/**
 Instanciates a `TCBlobDownloader` object with response blocks. `TCBlobDownloader` objects instanciated this way will not be executed until they are passed to the `TCBlobDownloaderManager` singleton.
 
 @see startDownload:
 
 @param url  The URL of the file to download.
 @param customPathOrNil  An optional path to override the default download path of the `TCBlobDownloaderManager` instance. Can be `nil`.
 @param firstResponseBlock  This block is called when receiving the first response from the server. Can be `nil`.
 @param progressBlock  This block is called on each response from the server while the download is occurring. Can be `nil`. If the remaining time has not been calculated yet, the value is `-1`.
 @param errorBlock  Called when an error occur during the download. If this block is called, the download will be cancelled just after. Can be `nil`.
 @param completeBlock  Called when the download is completed or cancelled. Can be `nil`. If the download has been cancelled with the parameter `removeFile` set to `YES`, then the `pathToFile` parameter is `nil`. The `TCBlobDownloader` operation will be removed from `TCBlobDownloadManager` just after this block is called.
 @return The newly created `TCBlobDownloader`.
 
 @since 1.3
 */
- (instancetype)initWithURL:(NSURL *)url
               downloadPath:(NSString *)pathToDL
              firstResponse:(void (^)(NSURLResponse *response))firstResponseBlock
                   progress:(void (^)(uint64_t receivedLength, uint64_t totalLength, NSInteger remainingTime, float progress))progressBlock
                      error:(void (^)(NSError *error))errorBlock
                   complete:(void (^)(BOOL downloadFinished, NSString *pathToFile))completeBlock;

/**
 Cancels the download. Remove already downloaded parts of the file from the disk is asked.
 
 @param remove  If `YES`, this method will remove the downloaded file parts from the disk. File parts are left untouched if set to `NO`. This will allow TCBlobDownload to restart the download from where it has ended in a future operation.
 
 @since 1.0
 */
- (void)cancelDownloadAndRemoveFile:(BOOL)remove;

/**
 Makes the receiver download dependent of the given download. The receiver download will not execute itself until the given download has finished.
 
 @param download  The TCBlobDownloader on which to depend.
 
 @since 1.2
 */
- (void)addDependentDownload:(TCBlobDownloader *)download;

@end


#pragma mark - TCBlobDownloader Delegate


/**
 The `TCBlobDownloaderDelegate` protocol defines the methods supported by `TCBlobDownloader` to notify you of the state of the download.
 */
@protocol TCBlobDownloaderDelegate <NSObject>
@optional
/**
 Optional. Called when the `TCBlobDownloader` object has received the first response from the server.
 
 @param blobDownload  The `TCBlobDownloader` object receiving the first response.
 @param response  The `NSURLResponse` from the server.
 
 @since 1.0
 */
- (void)download:(TCBlobDownloader *)blobDownload didReceiveFirstResponse:(NSURLResponse *)response;

/**
 Optional. Called on each response from the server while the download is occurring.
 
 @param blobDownload  The `TCBlobDownloader` object which received data.
 @param receivedLength  The total number of already received bytes.
 @param totalLength  The total number of bytes of the file.
 @param progress  A value between 0 and 1 defining the progress of the download.
 
 ## Note
 
 If you pause and restart later a download, the new `TCBlobDownloader` will resume it from where it has stopped (see `fileName` property for more explanations). Therefore, you might want to track yourself the total size of the file when you first tried to download it, otherwise the `totalLength` is the actual remaining length to download and might not suit your needs if you do something such as a progress bar.
 
 @since 1.0
 */
- (void)download:(TCBlobDownloader *)blobDownload
  didReceiveData:(uint64_t)receivedLength
         onTotal:(uint64_t)totalLength
        progress:(float)progress;

/**
 Optional. Called when an error occur during the download. If this method is called, the `TCBlobDownloader` will be automatically cancelled just after, without deleting the the already downloaded parts of the file. This is done by calling `cancelDownloadAndRemoveFile:`
 
 @see cancelDownloadAndRemoveFile:
 
 @param blobDownload  The `TCBlobDownloader` object which triggered an error.
 @param error  The triggered error.
 
 @since 1.0
 */
- (void)download:(TCBlobDownloader *)blobDownload
didStopWithError:(NSError *)error;

/**
 Optional. Called when the download is finished or when the operation has been cancelled. The `TCBlobDownloader` operation will be removed from `TCBlobDownloadManager` just after this method is called.
 
 @param blobDownload  The `TCBlobDownloader` object whose execution is finished.
 @param downloadFinished  `YES` if the file has been downloaded, `NO` if not.
 @param pathToFile  The path where the file has been downloaded.
 
 @since 1.3
 */
- (void)download:(TCBlobDownloader *)blobDownload
didFinishWithSuccess:(BOOL)downloadFinished
          atPath:(NSString *)pathToFile;

@end
