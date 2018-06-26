//
//  StoreParser.m
//  StoreParsing
//
//  Created by wizard on 2013. 12. 2..
//  Copyright (c) 2013년 Jelly Works. All rights reserved.
//

#import "StoreParser.h"

@implementation StoreParser

-(void)connect
{
	if(!self.receiveData) self.receiveData = [[NSMutableData alloc] init];
	NSURL *url = [[NSURL alloc]initWithString:@"https://itunes.apple.com/kr/app/seukulnabi/id893129176?l=ko&ls=1&mt=8"];
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

-(void)parseWithString:(NSString *)string
{
    NSRange range = [string rangeOfString:@"\"softwareVersion\""];
    
    if (range.location != NSNotFound) {
        range.location = range.location+17;
        range.length = 7;
        //        NSString *ver = [[string substringWithRange:range] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        NSString *ver = [[string substringFromIndex:range.location+1] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        //        NSLog(@"version first = %@", ver);
        NSArray *verArray = [ver componentsSeparatedByString:@"<"];
        NSString *ver1 = [verArray objectAtIndex:0];
        self.version = [ver1 stringByReplacingOccurrencesOfString:@" "
                                                       withString:@""];
        NSLog(@"version = %@", self.version);
        
        [self.delegate setStoreVersion:self.version];
    }else {
        NSLog(@"문자열 엄슴 ");
    }
}

@end
