//
//  StoreParser.h
//  StoreParsing
//
//  Created by wizard on 2013. 12. 2..
//  Copyright (c) 2013년 Jelly Works. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StoreParserDelegate;

@interface StoreParser : NSObject<NSURLConnectionDataDelegate>
@property  (retain) NSMutableData *receiveData;
@property  (retain) NSString *version;
@property  (assign) id<StoreParserDelegate> delegate;

-(void)connect;
-(void)parseWithString:(NSString*)string;
@end

@protocol StoreParserDelegate
-(void)setStoreVersion:(NSString *)version;
@end
