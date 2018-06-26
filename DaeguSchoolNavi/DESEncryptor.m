//
//  DESEncryptor.m
//  dawgu9
//
//  Created by SKOINFO_MACBOOK on 2015. 12. 5..
//  Copyright (c) 2015년 SKOINFO. All rights reserved.
//

#import "DESEncryptor.h"

#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import <commoncrypto/commoncryptor.h>

#define ENCRYPT_KEY @"4f9641bd"

@implementation DESEncryptor

//- 암호화
//1. 문자열 입력
//2. DES 암호화
//3. 암호화된 문자열을 base64로 인코딩
+ (NSString *) encrypt:(NSString *)str
{
    //NSLog(@"encrypt input string : %@", str);
    //NSLog(@"input length : %d", [str length]);
    NSData *data = [str dataUsingEncoding: NSUTF8StringEncoding];
    //NSLog(@"data : %@", data);
    unsigned char *input = (unsigned char*)[data bytes];
    NSUInteger inLength = [data length];
    NSInteger outLength = ((inLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1));
    unsigned char *output =(unsigned char *)calloc(outLength, sizeof(unsigned char));
    bzero(output, outLength*sizeof(unsigned char));
    size_t additionalNeeded = 0;
    unsigned char *iv = (unsigned char *)calloc(kCCBlockSizeDES, sizeof(unsigned char));
    bzero(iv, kCCBlockSizeDES * sizeof(unsigned char));
    NSString *key = ENCRYPT_KEY;
    const void *vkey = (const void *) [key UTF8String];
    
    CCCryptorStatus err = CCCrypt(kCCEncrypt,
                                  kCCAlgorithmDES,
                                  kCCOptionPKCS7Padding | kCCOptionECBMode,
                                  vkey,
                                  kCCKeySizeDES,
                                  iv,
                                  input,
                                  inLength,
                                  output,
                                  outLength,
                                  &additionalNeeded);
    //NSLog(@"encrypt err: %d", err);
    if(0);
    else if (err == kCCParamError) NSLog(@"PARAM ERROR");
    else if (err == kCCBufferTooSmall) NSLog(@"BUFFER TOO SMALL");
    else if (err == kCCMemoryFailure) NSLog(@"MEMORY FAILURE");
    else if (err == kCCAlignmentError) NSLog(@"ALIGNMENT");
    else if (err == kCCDecodeError) NSLog(@"DECODE ERROR");
    else if (err == kCCUnimplemented) NSLog(@"UNIMPLEMENTED");
    free(iv);
    
    NSString *result;
    //NSData *myData = [NSData dataWithBytesNoCopy:output length:outLength freeWhenDone:YES];
    NSData *myData = [NSData dataWithBytesNoCopy:output length:(NSUInteger)additionalNeeded freeWhenDone:YES];
    //NSLog(@"data : %@", myData);
    //NSLog(@"encrypted string : %s", [myData bytes]);
    //NSLog(@"encrypted length : %d", [myData length]);
    result = [myData base64Encoding];
    
    //NSLog(@"base64encoded : %@", result);
    return result;
}

//- 복호화
//1. 암호화되고 base64로 된 문자열 입력
//2. base64를 UTF8로 암호화만 되어있는 문자열로 디코딩
//3. 복호화
+ (NSString *) decrypt:(NSString *)str
{
    //NSLog(@"decrypt input string : %@", str);
    NSData *decodedData = [NSData dataWithBase64EncodedString:str];
    //NSLog(@"data : %@", decodedData);
    //NSLog(@"base64decoded : %s", [decodedData bytes]);
    unsigned char *input = (unsigned char*)[decodedData bytes];
    NSUInteger inLength = [decodedData length];
    NSInteger outLength = ((inLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1));
    unsigned char *output =(unsigned char *)calloc(outLength, sizeof(unsigned char));
    bzero(output, outLength*sizeof(unsigned char));
    size_t additionalNeeded = 0;
    unsigned char *iv = (unsigned char *)calloc(kCCBlockSizeDES, sizeof(unsigned char));
    bzero(iv, kCCBlockSizeDES * sizeof(unsigned char));
    NSString *key = ENCRYPT_KEY;
    const void *vkey = (const void *) [key UTF8String];
    
    CCCryptorStatus err = CCCrypt(kCCDecrypt,
                                  kCCAlgorithmDES,
                                  kCCOptionPKCS7Padding | kCCOptionECBMode,
                                  vkey,
                                  kCCKeySizeDES,
                                  iv,
                                  input,
                                  inLength,
                                  output,
                                  outLength,
                                  &additionalNeeded);
    //NSLog(@"encrypt err: %d", err);
    
    if(0);
    else if (err == kCCParamError) NSLog(@"PARAM ERROR");
    else if (err == kCCBufferTooSmall) NSLog(@"BUFFER TOO SMALL");
    else if (err == kCCMemoryFailure) NSLog(@"MEMORY FAILURE");
    else if (err == kCCAlignmentError) NSLog(@"ALIGNMENT");
    else if (err == kCCDecodeError) NSLog(@"DECODE ERROR");
    else if (err == kCCUnimplemented) NSLog(@"UNIMPLEMENTED");
    free(iv);
    
    NSString *result;
    //NSData *myData = [NSData dataWithBytes:(const void *)output length:(NSUInteger)additionalNeeded];
    //NSData *myData = [NSData dataWithBytesNoCopy:output length:outLength freeWhenDone:YES];
    NSData *myData = [NSData dataWithBytesNoCopy:output length:(NSUInteger)additionalNeeded freeWhenDone:YES];
    //NSLog(@"data : %@", myData);
    //NSLog(@"decrypted string : %s", [myData bytes]);
    //NSLog(@"decrypted length : %d", [myData length]);
    
    result = [NSString stringWithFormat:@"%.*s",[myData length], [myData bytes]];
    //result = [NSString stringWithUTF8String:[myData bytes]];
    //NSLog(@"output length : %d", [result length]);
    //NSLog(@"result : %@", result);
    
    return result;
}

@end
