#include "webview_core.hpp"

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

static UIButton* closeButton = nil;
static WKWebView* webView = nil;
static WebViewCallbacks gWebViewCallbacksCopy = {};
static WebViewCallbacks* gWebViewCallbacks = nullptr;

@interface WebViewDelegate : NSObject <WKNavigationDelegate, WKUIDelegate>
@end

@implementation WebViewDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
	if (gWebViewCallbacks && gWebViewCallbacks->onPageStarted && webView.URL.absoluteString)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			gWebViewCallbacks->onPageStarted(webView.URL.absoluteString.UTF8String);
		});
	}
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
	if (gWebViewCallbacks && gWebViewCallbacks->onPageFinished && webView.URL.absoluteString)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			gWebViewCallbacks->onPageFinished(webView.URL.absoluteString.UTF8String);
		});
	}
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
	if (gWebViewCallbacks && gWebViewCallbacks->onUrlLoading && navigationAction.request.URL.absoluteString)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			gWebViewCallbacks->onUrlLoading(navigationAction.request.URL.absoluteString.UTF8String);
		});
	}

	decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)onCloseButtonClicked
{
	if (gWebViewCallbacks && gWebViewCallbacks->onUrlLoading)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			gWebViewCallbacks->onCloseButtonClicked();
		});
	}
}

@end

static WebViewDelegate* delegate = nil;

void WebView_Init(const WebViewCallbacks* callbacks)
{
    if (callbacks)
        gWebViewCallbacksCopy = (*callbacks);

    gWebViewCallbacks = &gWebViewCallbacksCopy;

    if (!delegate)
        delegate = [[WebViewDelegate alloc] init];
}

void WebView_OpenWithURL(const char* url, bool transparent, bool addCloseButton)
{
	if (url && !webView)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];

			config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
			config.allowsInlineMediaPlayback = YES;

			webView = [[WKWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds] configuration:config];

			if (transparent)
			{
				webView.opaque = NO;
				webView.backgroundColor = [UIColor clearColor];
				webView.scrollView.backgroundColor = [UIColor clearColor];
			}

			webView.scrollView.bounces = NO;

			webView.navigationDelegate = delegate;
	
			webView.UIDelegate = delegate;

			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithUTF8String:url]]]];

			[[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:webView];

			if (addCloseButton)
			{
				closeButton = [UIButton buttonWithType:UIButtonTypeCustom];

				NSString *dpi = @"mdpi";

				if ([UIScreen mainScreen].scale > 1.0)
					dpi = @"xhdpi";

				[closeButton setImage:[[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: [NSString stringWithFormat:@"assets/webview/close_%@.png", dpi] ofType: nil]] forState:UIControlStateNormal];

				closeButton.adjustsImageWhenHighlighted = NO;
				closeButton.translatesAutoresizingMaskIntoConstraints = NO;

				UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;

				[keyWindow.rootViewController.view addSubview:closeButton];

				CGFloat padding = 8 * [UIScreen mainScreen].scale;

				[NSLayoutConstraint activateConstraints:@[
					[closeButton.topAnchor constraintEqualToAnchor:keyWindow.topAnchor constant:padding],
					[closeButton.trailingAnchor constraintEqualToAnchor:keyWindow.trailingAnchor constant:-padding],
					[closeButton.widthAnchor constraintEqualToConstant:padding * 2],
					[closeButton.heightAnchor constraintEqualToConstant:padding * 2],
				]];

				[closeButton addTarget:delegate action:@selector(onCloseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
			}
		});
	}
}

void WebView_OpenWithData(const char* data, const char* mimeType, const char* encoding, bool transparent, bool addCloseButton)
{
	if (data && !webView)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
			config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
			config.allowsInlineMediaPlayback = YES;

			webView = [[WKWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds] configuration:config];

			if (transparent)
			{
				webView.opaque = NO;
				webView.backgroundColor = [UIColor clearColor];
				webView.scrollView.backgroundColor = [UIColor clearColor];
			}

			webView.scrollView.bounces = NO;

			webView.navigationDelegate = delegate;
			webView.UIDelegate = delegate;

			[webView loadData:[[NSString stringWithUTF8String:data] dataUsingEncoding:NSUTF8StringEncoding] MIMEType:[NSString stringWithUTF8String:mimeType] characterEncodingName:[NSString stringWithUTF8String:encoding] baseURL:[NSURL URLWithString:@"about:blank"]];

			[[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:webView];

			if (addCloseButton)
			{
				closeButton = [UIButton buttonWithType:UIButtonTypeCustom];

				NSString *dpi = @"mdpi";

				if ([UIScreen mainScreen].scale > 1.0)
					dpi = @"xhdpi";

				[closeButton setImage:[[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: [NSString stringWithFormat:@"assets/webview/close_%@.png", dpi] ofType: nil]] forState:UIControlStateNormal];

				closeButton.adjustsImageWhenHighlighted = NO;
				closeButton.translatesAutoresizingMaskIntoConstraints = NO;

				UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;

				[keyWindow.rootViewController.view addSubview:closeButton];

				CGFloat padding = 8 * [UIScreen mainScreen].scale;

				[NSLayoutConstraint activateConstraints:@[
					[closeButton.topAnchor constraintEqualToAnchor:keyWindow.topAnchor constant:padding],
					[closeButton.trailingAnchor constraintEqualToAnchor:keyWindow.trailingAnchor constant:-padding],
					[closeButton.widthAnchor constraintEqualToConstant:padding * 2],
					[closeButton.heightAnchor constraintEqualToConstant:padding * 2],
				]];

				[closeButton addTarget:delegate action:@selector(onCloseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
			}
		});
	}
}

bool WebView_IsOpened()
{
	return webView != nil;
}

void WebView_Close()
{
	if (webView)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			[webView removeFromSuperview];
			webView.navigationDelegate = nil;
			webView.UIDelegate = nil;
			webView = nil;
		});
	}
}

void WebView_LoadURL(const char* url)
{
	if (webView && url)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithUTF8String:url]]]];
		});
	}
}

void WebView_LoadData(const char* data, const char* mimeType, const char* encoding)
{
	if (webView && data)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			[webView loadData:[[NSString stringWithUTF8String:data] dataUsingEncoding:NSUTF8StringEncoding] MIMEType:[NSString stringWithUTF8String:mimeType] characterEncodingName:[NSString stringWithUTF8String:encoding] baseURL:[NSURL URLWithString:@"about:blank"]];
		});
	}
}

bool WebView_CanGoBack()
{
    return webView ? [webView canGoBack] : false;
}

void WebView_GoBack()
{
	if (webView)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			[webView goBack];
		});
	}
}

bool WebView_CanGoForward()
{
    return webView ? [webView canGoForward] : false;
}

void WebView_GoForward()
{
	if (webView)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			[webView goForward];
		});
	}
}

void WebView_Reload()
{
	if (webView)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			[webView reload];
		});
	}
}

void WebView_StopLoading()
{
	if (webView)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			[webView stopLoading];
		});
	}
}

void WebView_ClearCache()
{
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:[WKWebsiteDataStore allWebsiteDataTypes] modifiedSince:[NSDate dateWithTimeIntervalSince1970:0] completionHandler:^{}];
	});
}

void WebView_ClearCookies()
{
	if (@available(iOS 11.0, *))
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			WKHTTPCookieStore* store = WKWebsiteDataStore.defaultDataStore.httpCookieStore;

			[store getAllCookies:^(NSArray<NSHTTPCookie *> *cookies)
			{
				for (NSHTTPCookie *cookie in cookies)
					[store deleteCookie:cookie completionHandler:nil];
			}];
		});
	}
}
