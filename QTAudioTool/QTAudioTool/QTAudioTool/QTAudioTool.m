//
//  QTAudioTool.m
//  QTCoreMain
//
//  Created by MasterBie on 2019/7/30.
//  Copyright © 2019 MasterBie. All rights reserved.
//

#import "QTAudioTool.h"
#import "lame.h"
@implementation QTAudioTool

// 提取
+(void)getAudioFrom:(NSString *)videoPath outputPath:(NSString *)outputPath
{
    // 1. 获取音频源
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
    
    // 2. 创建一个音频会话, 并且,设置相应的配置
    AVAssetExportSession *session = [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetAppleM4A];
    session.outputFileType = AVFileTypeAppleM4A;
    session.outputURL = [NSURL fileURLWithPath:outputPath];
    
    session.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    
    // 3. 导出
    [session exportAsynchronouslyWithCompletionHandler:^{
        AVAssetExportSessionStatus status = session.status;
        if (status == AVAssetExportSessionStatusCompleted)
        {
            NSLog(@"导出成功");
        }
    }];
 
}

// 拼接

+(void)addAudio:(NSString *)fromPath toAudio:(NSString *)toPath outputPath:(NSString *)outputPath{
    
    // 1. 获取两个音频源
    AVURLAsset *audioAsset1 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:fromPath]];
    AVURLAsset *audioAsset2 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:toPath]];
    
    // 2. 获取两个音频素材中的素材轨道
    AVAssetTrack *audioAssetTrack1 = [[audioAsset1 tracksWithMediaType:AVMediaTypeAudio] firstObject];
    AVAssetTrack *audioAssetTrack2 = [[audioAsset2 tracksWithMediaType:AVMediaTypeAudio] firstObject];
    
    // 3. 向音频合成器, 添加一个空的素材容器
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:0];
    
    // 4. 向素材容器中, 插入音轨素材
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset2.duration) ofTrack:audioAssetTrack2 atTime:kCMTimeZero error:nil];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset1.duration) ofTrack:audioAssetTrack1 atTime:audioAsset2.duration error:nil];
    
    // 5. 根据合成器, 创建一个导出对象, 并设置导出参数
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetAppleM4A];
    session.outputURL = [NSURL fileURLWithPath:outputPath];
    // 导出类型
    session.outputFileType = AVFileTypeAppleM4A;
    
    // 6. 开始导出数据
    [session exportAsynchronouslyWithCompletionHandler:^{
        
        AVAssetExportSessionStatus status = session.status;
        /**
         AVAssetExportSessionStatusUnknown,
         AVAssetExportSessionStatusWaiting,
         AVAssetExportSessionStatusExporting,
         AVAssetExportSessionStatusCompleted,
         AVAssetExportSessionStatusFailed,
         AVAssetExportSessionStatusCancelled
         */
        switch (status) {
            case AVAssetExportSessionStatusUnknown:
                NSLog(@"未知状态");
                break;
            case AVAssetExportSessionStatusWaiting:
                NSLog(@"等待导出");
                break;
            case AVAssetExportSessionStatusExporting:
                NSLog(@"导出中");
                break;
            case AVAssetExportSessionStatusCompleted:{
                
                NSLog(@"导出成功，路径是：%@", outputPath);
            }
                break;
            case AVAssetExportSessionStatusFailed:
                
                NSLog(@"导出失败");
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"取消导出");
                break;
            default:
                break;
        }
    }];
}


// 裁剪音频文件
+(void)cutAudio:(NSString *)audioPath timeRange:(CMTimeRange )timeRange outputPath:(NSString *)outputPath
{
    // 1. 获取音频源
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:audioPath]];
    
    // 2. 创建一个音频会话, 并且,设置相应的配置
    AVAssetExportSession *session = [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetAppleM4A];
    session.outputFileType = AVFileTypeAppleM4A;
    session.outputURL = [NSURL fileURLWithPath:outputPath];
 
    session.timeRange = timeRange;
    
    // 3. 导出
    [session exportAsynchronouslyWithCompletionHandler:^{
        AVAssetExportSessionStatus status = session.status;
        if (status == AVAssetExportSessionStatusCompleted)
        {
            NSLog(@"导出成功");
        }
    }];
}

// caf转码mp3
+ (NSString *)audioToMp3:(NSString *)filePath
{
    NSString *cafFilePath = filePath;
    
    NSString *mp3FileName = @"Mp3File";
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];
        
        @try {
            int read, write;
            //source 被转换的音频文件位置
            FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");
            //skip file header
            fseek(pcm, 4*1024, SEEK_CUR);
            //output 输出生成的Mp3文件位置
            FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");
            
            const int PCM_SIZE = 8192;
            const int MP3_SIZE = 8192;
            short int pcm_buffer[PCM_SIZE*2];
            unsigned char mp3_buffer[MP3_SIZE];
            
//            lame_t lame = lame_init();
//            lame_set_in_samplerate(lame, 11025.0);
//            lame_set_VBR(lame, vbr_default);
//            lame_init_params(lame);
            lame_t lame = lame_init();

            lame_set_VBR(lame, vbr_default);

            lame_set_num_channels(lame,2);//默认为2双通道

            lame_set_in_samplerate(lame, 11025.0);//11025.0

            lame_set_brate(lame,8);

            lame_set_mode(lame,3);
            lame_set_quality(lame,5); /* 2=high 5 = medium 7=low 音质*/
        
            lame_init_params(lame);
          
            
            
            do {
                size_t size = (size_t)(2 * sizeof(short int));
                read = (int)fread(pcm_buffer, size, PCM_SIZE, pcm);
                if (read == 0)
                    write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                else
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                
                fwrite(mp3_buffer, write, 1, mp3);
                
            } while (read != 0);
            
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
        }
        
        @catch (NSException *exception) {
            NSLog(@"%@",[exception description]);
            return @"error";
        }
        
        @finally {
            
            
            NSLog(@"%@",mp3FilePath);
            return mp3FilePath;
        }
    
    return @"";
}


/**
 把.m4a转为.caf格式
 @param originalUrlStr .m4a文件路径
 @param destUrlStr .caf文件路径
 @param completed 转化完成的block
 */
+ (void)convetM4aToWav:(NSString *)originalUrlStr
               destUrl:(NSString *)destUrlStr
             completed:(void (^)(NSError *error)) completed {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:destUrlStr]) {
        [[NSFileManager defaultManager] removeItemAtPath:destUrlStr error:nil];
    }
    NSURL *originalUrl = [NSURL fileURLWithPath:originalUrlStr];
    NSURL *destUrl     = [NSURL fileURLWithPath:destUrlStr];
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:originalUrl options:nil];
    
    //读取原始文件信息
    NSError *error = nil;
    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:songAsset error:&error];
    if (error) {
        NSLog (@"error: %@", error);
        completed(error);
        return;
    }
    AVAssetReaderOutput *assetReaderOutput = [AVAssetReaderAudioMixOutput
                                              assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks
                                              audioSettings: nil];
    if (![assetReader canAddOutput:assetReaderOutput]) {
        NSLog (@"can't add reader output... die!");
        completed(error);
        return;
    }
    [assetReader addOutput:assetReaderOutput];
    
    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:destUrl
                                                          fileType:AVFileTypeCoreAudioFormat
                                                             error:&error];
    if (error) {
        NSLog (@"error: %@", error);
        completed(error);
        return;
    }
    AudioChannelLayout channelLayout;
    memset(&channelLayout, 0, sizeof(AudioChannelLayout));
    channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
    NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                    [NSNumber numberWithFloat:11025.0], AVSampleRateKey,
                                    [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
                                    [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                    [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                    
                                    nil];
    
    AVAssetWriterInput *assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio
                                                                              outputSettings:outputSettings];
    if ([assetWriter canAddInput:assetWriterInput]) {
        [assetWriter addInput:assetWriterInput];
    } else {
        NSLog (@"can't add asset writer input... die!");
        completed(error);
        return;
    }
    
    assetWriterInput.expectsMediaDataInRealTime = NO;
    
    [assetWriter startWriting];
    [assetReader startReading];
    
    AVAssetTrack *soundTrack = [songAsset.tracks objectAtIndex:0];
    CMTime startTime = CMTimeMake (0, soundTrack.naturalTimeScale);
    [assetWriter startSessionAtSourceTime:startTime];
    
    __block UInt64 convertedByteCount = 0;
    
    dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
    [assetWriterInput requestMediaDataWhenReadyOnQueue:mediaInputQueue
                                            usingBlock: ^
     {
         while (assetWriterInput.readyForMoreMediaData) {
             CMSampleBufferRef nextBuffer = [assetReaderOutput copyNextSampleBuffer];
             if (nextBuffer) {
                 // append buffer
                 [assetWriterInput appendSampleBuffer: nextBuffer];
                 NSLog (@"appended a buffer (%zu bytes)",
                           CMSampleBufferGetTotalSampleSize (nextBuffer));
                 convertedByteCount += CMSampleBufferGetTotalSampleSize (nextBuffer);
                 
                 
             } else {
                 [assetWriterInput markAsFinished];
                 [assetWriter finishWritingWithCompletionHandler:^{
                     
                 }];
                 [assetReader cancelReading];
                 NSDictionary *outputFileAttributes = [[NSFileManager defaultManager]
                                                       attributesOfItemAtPath:[destUrl path]
                                                       error:nil];
                 NSLog (@"FlyElephant %lld",[outputFileAttributes fileSize]);
                 break;
             }
         }
         NSLog(@"转换结束");
         // 删除临时temprecordAudio.m4a文件
         NSError *removeError = nil;
         if ([[NSFileManager defaultManager] fileExistsAtPath:originalUrlStr]) {
             BOOL success = [[NSFileManager defaultManager] removeItemAtPath:originalUrlStr error:&removeError];
             if (!success) {
                 NSLog(@"删除临时temprecordAudio.m4a文件失败:%@",removeError);
                 completed(removeError);
             }else{
                 NSLog(@"删除临时temprecordAudio.m4a文件:%@成功",originalUrlStr);
                 completed(removeError);
             }
         }
         
     }];
}


/**
把.caf转为.m4a格式
@param cafUrlStr .m4a文件路径
@param m4aUrlStr .caf文件路径
@param completed 转化完成的block
*/
+ (void)convetCafToM4a:(NSString *)cafUrlStr
               destUrl:(NSString *)m4aUrlStr
             completed:(void (^)(NSError *error)) completed {
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    //  音频插入的开始时间
    CMTime beginTime = kCMTimeZero;
    //  获取音频合并音轨
    AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //  用于记录错误的对象
    NSError *error = nil;
    //  音频原文件资源
    AVURLAsset *cafAsset = [[AVURLAsset alloc]initWithURL:[NSURL fileURLWithPath:cafUrlStr] options:nil];
    //  原音频需要合并的音频文件的区间
    CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero, cafAsset.duration);
    BOOL success = [compositionAudioTrack insertTimeRange:audio_timeRange ofTrack:[[cafAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:beginTime error:&error];
    if (!success) {
        NSLog(@"插入原音频失败: %@",error);
    }else {
        NSLog(@"插入原音频成功");
    }
    // 创建一个导入M4A格式的音频的导出对象
    AVAssetExportSession* assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetAppleM4A];
    // 导入音视频的URL
    assetExport.outputURL = [NSURL fileURLWithPath:m4aUrlStr];
    // 导出音视频的文件格式
    assetExport.outputFileType = @"com.apple.m4a-audio";
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        // 分发到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            int exportStatus = assetExport.status;
            if (exportStatus == AVAssetExportSessionStatusCompleted) {
                // 合成成功
                completed(nil);
                NSError *removeError = nil;
                if([cafUrlStr hasSuffix:@"caf"]) {
                    // 删除老录音caf文件
                    if ([[NSFileManager defaultManager] fileExistsAtPath:cafUrlStr]) {
                        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:cafUrlStr error:&removeError];
                        if (!success) {
                            NSLog(@"删除老录音caf文件失败:%@",removeError);
                        }else{
                            NSLog(@"删除老录音caf文件:%@成功",cafUrlStr);
                        }
                    }
                }
                
            }else {
                completed(assetExport.error);
            }
            
        });
    }];
    
    
}

// 混音

+ (void)mixAudio:(NSString *)fromPath toAudio:(NSString *)toPath outputPath:(NSString *)outputPath
{
    // 1. 获取两个音频源
    AVURLAsset *audioAsset1 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:fromPath]];
    AVURLAsset *audioAsset2 = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:toPath]];
    
    // 2. 获取两个音频素材中的素材轨道
    AVAssetTrack *audioAssetTrack1 = [[audioAsset1 tracksWithMediaType:AVMediaTypeAudio] firstObject];
    AVAssetTrack *audioAssetTrack2 = [[audioAsset2 tracksWithMediaType:AVMediaTypeAudio] firstObject];
   
    // 3. 向音频合成器, 添加一个空的素材容器
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:0];
    
    // 4. 向素材容器中, 插入音轨素材
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset1.duration) ofTrack:audioAssetTrack2 atTime:kCMTimeZero error:nil];
    
    AVMutableCompositionTrack *audioTrack2 = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    [audioTrack2 insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset2.duration) ofTrack:audioAssetTrack1 atTime:kCMTimeInvalid error:nil];
    
  
    
    
    AVMutableAudioMix *mutableAudioMix = [AVMutableAudioMix audioMix];
    // Create the audio mix input parameters object.
    AVMutableAudioMixInputParameters *mixParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioTrack];
    // Set the volume ramp to slowly fade the audio out over the duration of the composition.
    [mixParameters setVolumeRampFromStartVolume:0.f toEndVolume:1.f timeRange:CMTimeRangeMake(kCMTimeZero, audioAsset1.duration)];
    
    AVMutableAudioMixInputParameters *mixParameters2 = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioTrack2];
    // Set the volume ramp to slowly fade the audio out over the duration of the composition.
    [mixParameters2 setVolumeRampFromStartVolume:1.f toEndVolume:0.f timeRange:CMTimeRangeMake(kCMTimeZero, audioAsset2.duration)];
    // Attach the input parameters to the audio mix.
    mutableAudioMix.inputParameters = @[mixParameters,mixParameters2];
    
    // 5. 根据合成器, 创建一个导出对象, 并设置导出参数
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetAppleM4A];
    session.outputURL = [NSURL fileURLWithPath:outputPath];
    // 导出类型
    session.outputFileType = AVFileTypeAppleM4A;
    session.audioMix = mutableAudioMix ;
    // 6. 开始导出数据
    [session exportAsynchronouslyWithCompletionHandler:^{
        
        AVAssetExportSessionStatus status = session.status;
        /**
         AVAssetExportSessionStatusUnknown,
         AVAssetExportSessionStatusWaiting,
         AVAssetExportSessionStatusExporting,
         AVAssetExportSessionStatusCompleted,
         AVAssetExportSessionStatusFailed,
         AVAssetExportSessionStatusCancelled
         */
        switch (status) {
            case AVAssetExportSessionStatusUnknown:
                NSLog(@"未知状态");
                break;
            case AVAssetExportSessionStatusWaiting:
                NSLog(@"等待导出");
                break;
            case AVAssetExportSessionStatusExporting:
                NSLog(@"导出中");
                break;
            case AVAssetExportSessionStatusCompleted:{
                
                NSLog(@"导出成功，路径是：%@", outputPath);
            }
                break;
            case AVAssetExportSessionStatusFailed:
                
                NSLog(@"导出失败");
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"取消导出");
                break;
            default:
                break;
        }
    }];
}
@end
