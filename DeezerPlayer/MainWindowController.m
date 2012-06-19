//
//  MainWindowController.m
//  DeezerPlayer
//
//  Created by Bernard Potocki on 19.06.2012.
//  Copyright (c) 2012 Rebased. All rights reserved.
//

#import "MainWindowController.h"
#import "AppDelegate.h"

@implementation MainWindowController

@synthesize webView;

- (void)awakeFromNib {
    [self setUserAgent];
    [[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://deezer.com/"]]];
}

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame {
    if (frame == [sender mainFrame])
        [[self window] setTitle:title];
}

- (void) setUserAgent {
    NSString *safariVersion = @"5.1.7";
    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"WebKit\\/([\\d.]+)" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:userAgent options:0 range:NSMakeRange(0, [userAgent length])];
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match rangeAtIndex:1];
        NSString *webKitVersion = [userAgent substringWithRange:matchRange];
        
        userAgent = [NSString stringWithFormat:@"%@ Version/%@ Safari/%@", userAgent, safariVersion, webKitVersion];
        [webView setCustomUserAgent:userAgent];
    }
}

- (void)webView:(WebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame {
	NSRunInformationalAlertPanel(NSLocalizedString(@"JavaScript", @""),	// title
								 message,								// message
								 NSLocalizedString(@"OK", @""),			// default button
								 nil,									// alt button
								 nil);									// other button	
}


- (BOOL)webView:(WebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame {
	NSInteger result = NSRunInformationalAlertPanel(NSLocalizedString(@"JavaScript", @""),	// title
													message,								// message
													NSLocalizedString(@"OK", @""),			// default button
													NSLocalizedString(@"Cancel", @""),		// alt button
													nil);
	return NSAlertDefaultReturn == result;	
}

- (void)webView:(WebView *)sender runOpenPanelForFileButtonWithResultListener:(id < WebOpenPanelResultListener >)resultListener {       
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:NO];
    [openDlg setAllowsMultipleSelection:YES];
    
    if ( [openDlg runModal] == NSOKButton )
    {
        NSArray* files = [[openDlg URLs]valueForKey:@"relativePath"];
        [resultListener chooseFilenames:files];
    }
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    if(frame == [sender mainFrame])
        [webView stringByEvaluatingJavaScriptFromString:@"if (typeof live === 'object' && typeof live.hideLiveBar === 'function') live.hideLiveBar();"]; 
}

- (void)togglePlayPause {
    [webView stringByEvaluatingJavaScriptFromString:@"playercontrol.$btnPause.css('display') === 'none' ? playercontrol.doAction('play') : playercontrol.doAction('pause');"];
}

- (void)playNext {
    [webView stringByEvaluatingJavaScriptFromString:@"playercontrol.doAction('next');"];
}

- (void)playPrev {
    [webView stringByEvaluatingJavaScriptFromString:@"playercontrol.doAction('prev');"];
}


@end