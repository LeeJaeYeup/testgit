//
//  StoreParser.m
//  StoreParsing
//
//  Created by wizard on 2013. 12. 2..
//  Copyright (c) 2013년 Jelly Works. All rights reserved.
//

#import "StoreParser.h"

@implementation StoreParser

-(void)connect{
	if(!self.receiveData) self.receiveData = [[NSMutableData alloc] init];
	NSURL *url = [[NSURL alloc]initWithString:@"https://itunes.apple.com/kr/app/uljingunjeong-seumateuallimi/id1061039345?l=ko&ls=1&mt=8"];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	[self.receiveData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[self.receiveData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	NSLog(@"Error");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
	NSString *rString = [NSString stringWithUTF8String:[self.receiveData bytes]];
	[self parseWithString:rString];
	//NSLog(@"%@", rString);
}

-(void)parseWithString:(NSString *)string{
    //NSString
    //    	NSRange range = [string rangeOfString:@"Version"];
    NSRange range = [string rangeOfString:@"\"softwareVersion\""];
    //    NSLog(@"test999999999 --  %lu %lu", (unsigned long)range.location , (unsigned long)range.length);
    //    NSLog(@"test291249922 -- %@",string);
    if (range.location != NSNotFound) {
        range.location = range.location+17;
        range.length = 7;
        NSString *ver = [[string substringWithRange:range] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        
        NSString *ver1 = [ver stringByReplacingOccurrencesOfString:@"_"
                                                        withString:@""];
        ver1 = [ver1 stringByReplacingOccurrencesOfString:@">"
                                               withString:@""];
        ver1 = [ver1 stringByReplacingOccurrencesOfString:@"<"
                                               withString:@""];
        self.version = [ver1 stringByReplacingOccurrencesOfString:@" "
                                                       withString:@""];
        NSLog(@"version = %@", self.version);
        
        [self.delegate setStoreVersion:self.version];
    }else {
        NSLog(@"문자열 엄슴 ");
    }
}

@end
