//
//  QTAudioTool.h
//  QTCoreMain
//
//  Created by MasterBie on 2019/7/30.
//  Copyright © 2019 MasterBie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface QTAudioTool : NSObject

// 从视频文件提取声音
+(void)getAudioFrom:(NSString *)videoPath outputPath:(NSString *)outputPath;

// 拼接两个音频文件
+(void)addAudio:(NSString *)fromPath toAudio:(NSString *)toPath outputPath:(NSString *)outputPath;

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
