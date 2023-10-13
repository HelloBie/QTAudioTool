//
//  QTAudioTool.h
//  QTCoreMain
//
//  Created by MasterBie on 2019/7/30.
//  Copyright © 2019 MasterBie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


typedef void(^QtAudioCallBack)(BOOL status, NSString *result, NSString *msg);
NS_ASSUME_NONNULL_BEGIN

/// 音频文件处理相关工具
@interface QTAudioTool : NSObject

/// 从视频提取音频文件
/// - Parameters:
///   - videoPath: 视频文件地址
///   - outputFilePath: 音频文件输出地址
///   - audioType: 导出的音频文件格式 默认m4a
///   - callBack: 结果回调
+ (void)qt_getAudioFromVideo:(NSString *)videoPath
              outputFilePath:(NSString *)outputFilePath
             outPutAudioType:(AVFileType)audioType
                appendResult:(QtAudioCallBack)callBack;

/// 音频拼接
/// - Parameters:
///   - paths: 需要拼接的音频文件路径,会按照数组顺序从头到尾拼接
///   - outPutFilePath: 拼接文件的保存路径,包含文件名
///   - audioType: 导出的文件格式,默认m4a
///   - callBack: 结果回调
+ (void)qt_AudioAppendWithPaths:(NSArray *)paths
                 outPutFilePath:(NSString *)outPutFilePath
                outPutAudioType:(AVFileType)audioType
                   appendResult:(QtAudioCallBack)callBack;

// 裁剪音频文件
+(void)cutAudio:(NSString *)audioPath timeRange:(CMTimeRange )timeRange outputPath:(NSString *)outputPath;

// caf转码到MP3 
+ (NSString *)audioToMp3:(NSString *)filePath;

// m4a转码到caf
+ (void)convetM4aToWav:(NSString *)originalUrlStr
               destUrl:(NSString *)destUrlStr
             completed:(void (^)(NSError *error)) completed;

// caf转为m4a
+ (void)convetCafToM4a:(NSString *)cafUrlStr
               destUrl:(NSString *)m4aUrlStr
             completed:(void (^)(NSError *error)) completed ;

// 混音
+ (void)mixAudio:(NSString *)fromPath toAudio:(NSString *)toPath outputPath:(NSString *)outputPath;

@end

NS_ASSUME_NONNULL_END
