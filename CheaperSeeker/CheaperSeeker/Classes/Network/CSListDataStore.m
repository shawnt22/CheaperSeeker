//
//  CSListDataStore.m
//  CheaperSeeker
//
//  Created by 滕 松 on 12-9-8.
//  Copyright (c) 2012年 shawnt22@gmail.com. All rights reserved.
//

#import "CSListDataStore.h"


#pragma mark - Home
@implementation CSHomeDataStore

- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy {
    [self refreshItemsWithCachePolicy:cachePolicy URL:[SURLProxy getHomeCouponsWithCursor:kListDataStoreRefreshCursor Count:self.limitCount]];
}
- (void)loadmoreItems {
    [self refreshItemsWithCachePolicy:ASIDoNotReadFromCacheCachePolicy URL:[SURLProxy getHomeCouponsWithCursor:self.cursorID Count:self.limitCount]];
}

@end

#pragma mark - Search
@implementation CSSearchDataStore
@synthesize key;

- (void)dealloc {
    self.key = nil;
    [super dealloc];
}
- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy {
    [self refreshItemsWithCachePolicy:cachePolicy URL:[SURLProxy searchCouponsWithKey:self.key Cursor:kListDataStoreRefreshCursor Count:self.limitCount]];
}
- (void)loadmoreItems {
    [self refreshItemsWithCachePolicy:ASIDoNotReadFromCacheCachePolicy URL:[SURLProxy searchCouponsWithKey:self.key Cursor:self.cursorID Count:self.limitCount]];
}

@end

#import "JSONKit.h"
@implementation CSMerchantsDataStore

- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy {
    [self refreshItemsWithCachePolicy:cachePolicy URL:[SURLProxy getMerchantsWithCursor:kListDataStoreRefreshCursor Count:self.limitCount]];
}
- (void)loadmoreItems {
    [self refreshItemsWithCachePolicy:ASIDoNotReadFromCacheCachePolicy URL:[SURLProxy getMerchantsWithCursor:self.cursorID Count:self.limitCount]];
}
- (SURLRequest *)prepareRequest:(SURLRequest *)request {
    id _fmdResponse = [[self testString] objectFromJSONString];
    NSString *_state = [_fmdResponse objectForKey:@"status"];
    if (_state) {
        if ([_state isEqualToString:@"success"]) {
            request.formatedResponse = [_fmdResponse objectForKey:@"value"];
        } else if ([_state isEqualToString:@"fail"]) {
            request.error = [SUtil errorWithCode:SErrorResponseParserFail];
        } else {
            request.error = [SUtil errorWithCode:SErrorResponseParserFail];
        }
    } else {
        request.error = [SUtil errorWithCode:SErrorResponseParserFail];
    }
    return request;
}
- (NSString *)testString {
    return @"{\"status\":\"success\",\"value\":{\"count\":21,\"cursor\":0,\"items\":[{\"id\":6604,\"name\":\"Karate Joe's\",\"description\":\"description\",\"categories\":[{\"category_id\":50,\"name\":\"Sporting Goods\"},{\"category_id\":94,\"name\":\"Sports &amp; Recreation\"}],\"homepage_url\":\"http://www.shareasale.com/u.cfm?d=84443&amp;m=32180&amp;u=617541\",\"banner\":\"http://upload.cheaperseeker.com/2012/08/karatejoes_logo.png\",\"snapshot\":\"http://upload.cheaperseeker.com/2012/09/2164.gif\"},{\"id\":6604,\"name\":\"Karate Joe's\",\"description\":\"description\",\"categories\":[{\"category_id\":50,\"name\":\"Sporting Goods\"},{\"category_id\":94,\"name\":\"Sports &amp; Recreation\"}],\"homepage_url\":\"http://www.shareasale.com/u.cfm?d=84443&amp;m=32180&amp;u=617541\",\"banner\":\"http://upload.cheaperseeker.com/2012/08/karatejoes_logo.png\",\"snapshot\":\"http://upload.cheaperseeker.com/2012/09/2164.gif\"},{\"id\":6604,\"name\":\"Karate Joe's\",\"description\":\"description\",\"categories\":[{\"category_id\":50,\"name\":\"Sporting Goods\"},{\"category_id\":94,\"name\":\"Sports &amp; Recreation\"}],\"homepage_url\":\"http://www.shareasale.com/u.cfm?d=84443&amp;m=32180&amp;u=617541\",\"banner\":\"http://upload.cheaperseeker.com/2012/08/karatejoes_logo.png\",\"snapshot\":\"http://upload.cheaperseeker.com/2012/09/2164.gif\"},{\"id\":6604,\"name\":\"Karate Joe's\",\"description\":\"description\",\"categories\":[{\"category_id\":50,\"name\":\"Sporting Goods\"},{\"category_id\":94,\"name\":\"Sports &amp; Recreation\"}],\"homepage_url\":\"http://www.shareasale.com/u.cfm?d=84443&amp;m=32180&amp;u=617541\",\"banner\":\"http://upload.cheaperseeker.com/2012/08/karatejoes_logo.png\",\"snapshot\":\"http://upload.cheaperseeker.com/2012/09/2164.gif\"},{\"id\":6604,\"name\":\"Karate Joe's\",\"description\":\"description\",\"categories\":[{\"category_id\":50,\"name\":\"Sporting Goods\"},{\"category_id\":94,\"name\":\"Sports &amp; Recreation\"}],\"homepage_url\":\"http://www.shareasale.com/u.cfm?d=84443&amp;m=32180&amp;u=617541\",\"banner\":\"http://upload.cheaperseeker.com/2012/08/karatejoes_logo.png\",\"snapshot\":\"http://upload.cheaperseeker.com/2012/09/2164.gif\"},{\"id\":6604,\"name\":\"Karate Joe's\",\"description\":\"description\",\"categories\":[{\"category_id\":50,\"name\":\"Sporting Goods\"},{\"category_id\":94,\"name\":\"Sports &amp; Recreation\"}],\"homepage_url\":\"http://www.shareasale.com/u.cfm?d=84443&amp;m=32180&amp;u=617541\",\"banner\":\"http://upload.cheaperseeker.com/2012/08/karatejoes_logo.png\",\"snapshot\":\"http://upload.cheaperseeker.com/2012/09/2164.gif\"},{\"id\":6604,\"name\":\"Karate Joe's\",\"description\":\"description\",\"categories\":[{\"category_id\":50,\"name\":\"Sporting Goods\"},{\"category_id\":94,\"name\":\"Sports &amp; Recreation\"}],\"homepage_url\":\"http://www.shareasale.com/u.cfm?d=84443&amp;m=32180&amp;u=617541\",\"banner\":\"http://upload.cheaperseeker.com/2012/08/karatejoes_logo.png\",\"snapshot\":\"http://upload.cheaperseeker.com/2012/09/2164.gif\"},{\"id\":6604,\"name\":\"Karate Joe's\",\"description\":\"description\",\"categories\":[{\"category_id\":50,\"name\":\"Sporting Goods\"},{\"category_id\":94,\"name\":\"Sports &amp; Recreation\"}],\"homepage_url\":\"http://www.shareasale.com/u.cfm?d=84443&amp;m=32180&amp;u=617541\",\"banner\":\"http://upload.cheaperseeker.com/2012/08/karatejoes_logo.png\",\"snapshot\":\"http://upload.cheaperseeker.com/2012/09/2164.gif\"},{\"id\":6604,\"name\":\"Karate Joe's\",\"description\":\"description\",\"categories\":[{\"category_id\":50,\"name\":\"Sporting Goods\"},{\"category_id\":94,\"name\":\"Sports &amp; Recreation\"}],\"homepage_url\":\"http://www.shareasale.com/u.cfm?d=84443&amp;m=32180&amp;u=617541\",\"banner\":\"http://upload.cheaperseeker.com/2012/08/karatejoes_logo.png\",\"snapshot\":\"http://upload.cheaperseeker.com/2012/09/2164.gif\"},{\"id\":6604,\"name\":\"Karate Joe's\",\"description\":\"description\",\"categories\":[{\"category_id\":50,\"name\":\"Sporting Goods\"},{\"category_id\":94,\"name\":\"Sports &amp; Recreation\"}],\"homepage_url\":\"http://www.shareasale.com/u.cfm?d=84443&amp;m=32180&amp;u=617541\",\"banner\":\"http://upload.cheaperseeker.com/2012/08/karatejoes_logo.png\",\"snapshot\":\"http://upload.cheaperseeker.com/2012/09/2164.gif\"},{\"id\":6604,\"name\":\"Karate Joe's\",\"description\":\"description\",\"categories\":[{\"category_id\":50,\"name\":\"Sporting Goods\"},{\"category_id\":94,\"name\":\"Sports &amp; Recreation\"}],\"homepage_url\":\"http://www.shareasale.com/u.cfm?d=84443&amp;m=32180&amp;u=617541\",\"banner\":\"http://upload.cheaperseeker.com/2012/08/karatejoes_logo.png\",\"snapshot\":\"http://upload.cheaperseeker.com/2012/09/2164.gif\"},{\"id\":6604,\"name\":\"Karate Joe's\",\"description\":\"description\",\"categories\":[{\"category_id\":50,\"name\":\"Sporting Goods\"},{\"category_id\":94,\"name\":\"Sports &amp; Recreation\"}],\"homepage_url\":\"http://www.shareasale.com/u.cfm?d=84443&amp;m=32180&amp;u=617541\",\"banner\":\"http://upload.cheaperseeker.com/2012/08/karatejoes_logo.png\",\"snapshot\":\"http://upload.cheaperseeker.com/2012/09/2164.gif\"},{\"id\":6604,\"name\":\"Karate Joe's\",\"description\":\"description\",\"categories\":[{\"category_id\":50,\"name\":\"Sporting Goods\"},{\"category_id\":94,\"name\":\"Sports &amp; Recreation\"}],\"homepage_url\":\"http://www.shareasale.com/u.cfm?d=84443&amp;m=32180&amp;u=617541\",\"banner\":\"http://upload.cheaperseeker.com/2012/08/karatejoes_logo.png\",\"snapshot\":\"http://upload.cheaperseeker.com/2012/09/2164.gif\"},{\"id\":6604,\"name\":\"Karate Joe's\",\"description\":\"description\",\"categories\":[{\"category_id\":50,\"name\":\"Sporting Goods\"},{\"category_id\":94,\"name\":\"Sports &amp; Recreation\"}],\"homepage_url\":\"http://www.shareasale.com/u.cfm?d=84443&amp;m=32180&amp;u=617541\",\"banner\":\"http://upload.cheaperseeker.com/2012/08/karatejoes_logo.png\",\"snapshot\":\"http://upload.cheaperseeker.com/2012/09/2164.gif\"},{\"id\":6604,\"name\":\"Karate Joe's\",\"description\":\"description\",\"categories\":[{\"category_id\":50,\"name\":\"Sporting Goods\"},{\"category_id\":94,\"name\":\"Sports &amp; Recreation\"}],\"homepage_url\":\"http://www.shareasale.com/u.cfm?d=84443&amp;m=32180&amp;u=617541\",\"banner\":\"http://upload.cheaperseeker.com/2012/08/karatejoes_logo.png\",\"snapshot\":\"http://upload.cheaperseeker.com/2012/09/2164.gif\"},{\"id\":6604,\"name\":\"Karate Joe's\",\"description\":\"description\",\"categories\":[{\"category_id\":50,\"name\":\"Sporting Goods\"},{\"category_id\":94,\"name\":\"Sports &amp; Recreation\"}],\"homepage_url\":\"http://www.shareasale.com/u.cfm?d=84443&amp;m=32180&amp;u=617541\",\"banner\":\"http://upload.cheaperseeker.com/2012/08/karatejoes_logo.png\",\"snapshot\":\"http://upload.cheaperseeker.com/2012/09/2164.gif\"},{\"id\":6604,\"name\":\"Karate Joe's\",\"description\":\"description\",\"categories\":[{\"category_id\":50,\"name\":\"Sporting Goods\"},{\"category_id\":94,\"name\":\"Sports &amp; Recreation\"}],\"homepage_url\":\"http://www.shareasale.com/u.cfm?d=84443&amp;m=32180&amp;u=617541\",\"banner\":\"http://upload.cheaperseeker.com/2012/08/karatejoes_logo.png\",\"snapshot\":\"http://upload.cheaperseeker.com/2012/09/2164.gif\"},{\"id\":6604,\"name\":\"Karate Joe's\",\"description\":\"description\",\"categories\":[{\"category_id\":50,\"name\":\"Sporting Goods\"},{\"category_id\":94,\"name\":\"Sports &amp; Recreation\"}],\"homepage_url\":\"http://www.shareasale.com/u.cfm?d=84443&amp;m=32180&amp;u=617541\",\"banner\":\"http://upload.cheaperseeker.com/2012/08/karatejoes_logo.png\",\"snapshot\":\"http://upload.cheaperseeker.com/2012/09/2164.gif\"},{\"id\":6604,\"name\":\"Karate Joe's\",\"description\":\"description\",\"categories\":[{\"category_id\":50,\"name\":\"Sporting Goods\"},{\"category_id\":94,\"name\":\"Sports &amp; Recreation\"}],\"homepage_url\":\"http://www.shareasale.com/u.cfm?d=84443&amp;m=32180&amp;u=617541\",\"banner\":\"http://upload.cheaperseeker.com/2012/08/karatejoes_logo.png\",\"snapshot\":\"http://upload.cheaperseeker.com/2012/09/2164.gif\"},{\"id\":6604,\"name\":\"Karate Joe's\",\"description\":\"description\",\"categories\":[{\"category_id\":50,\"name\":\"Sporting Goods\"},{\"category_id\":94,\"name\":\"Sports &amp; Recreation\"}],\"homepage_url\":\"http://www.shareasale.com/u.cfm?d=84443&amp;m=32180&amp;u=617541\",\"banner\":\"http://upload.cheaperseeker.com/2012/08/karatejoes_logo.png\",\"snapshot\":\"http://upload.cheaperseeker.com/2012/09/2164.gif\"}]}}";
}

@end

@implementation CSMerchantCouponsDataStore
@synthesize merchant;

- (void)dealloc {
    self.merchant = nil;
    [super dealloc];
}
- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy {
    
}
- (void)loadmoreItems {
    
}

@end

@implementation CSCategoriesDataStore

- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy {
    [self refreshItemsWithCachePolicy:cachePolicy URL:[SURLProxy getCategoriesWithCursor:kListDataStoreRefreshCursor Count:self.limitCount]];
}
- (void)loadmoreItems {
    [self refreshItemsWithCachePolicy:ASIDoNotReadFromCacheCachePolicy URL:[SURLProxy getCategoriesWithCursor:self.cursorID Count:self.limitCount]];
}

@end

@implementation CSCategoryCouponsDataStore
@synthesize category;

- (void)dealloc {
    self.category = nil;
    [super dealloc];
}
- (void)refreshItemsWithCachePolicy:(ASICachePolicy)cachePolicy {
    
}
- (void)loadmoreItems {
    
}

@end
