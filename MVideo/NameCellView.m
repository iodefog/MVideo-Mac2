//
//  NameCellView.m
//  MVideo
//
//  Created by LiHongli on 2017/4/28.
//  Copyright © 2017年 lihongli. All rights reserved.
//

#import "NameCellView.h"
#import "MMovieModel.h"
#import <AVFoundation/AVFoundation.h>

@implementation NameCellView

- (void)setObject:(MMovieModel *)object{
    self.textField.cell.title = object.title;
    NSImage *image = [NameCellView getThumbnailImage:object.url];
//    NSImage *image = [NameCellView thumbnailImageForVideo:[NSURL URLWithString:object.url] atTime:0];
    self.imageView.image = image;
    
}

+ (NSImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    
    NSImage *thumbnailImage = thumbnailImageRef ? [[NSImage alloc] initWithCGImage:thumbnailImageRef size:CGSizeMake(40, 40)] : nil;
    
    return thumbnailImage;
}

+(NSImage *)getThumbnailImage:(NSString *)videoURL

{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    NSImage *thumb = [[NSImage alloc] initWithCGImage:image size:CGSizeMake(40, 40)];
    
    CGImageRelease(image);
    
    return thumb;
}

@end
