#pragma once

typedef struct WebViewCallbacks
{
	void (*onPageFinished)(const char* url);
	void (*onPageStarted)(const char* url);
	void (*onUrlLoading)(const char* url);
	void (*onCloseButtonClicked)();
} WebViewCallbacks;

/**
 * Initializes the WebView system with the provided callbacks.
 *
 * @param callbacks Pointer to a struct containing the WebView-related callbacks.
 */
void WebView_Init(const WebViewCallbacks* callbacks);

/**
 * Opens a new WebView and loads the specified URL.
 *
 * @param url The URL to load. Must be a valid UTF-8 encoded string.
 * @param transparent Whether the WebView should be transparent.
 * @param addCloseButton Whether the WebView should have a close button.
 */
void WebView_OpenWithURL(const char* url, bool transparent, bool addCloseButton);

/**
 * Opens a new WebView and loads HTML or data content directly.
 *
 * @param data The raw HTML or data string to display.
 * @param mimeType The MIME type of the content (e.g., "text/html").
 * @param encoding The character encoding (e.g., "UTF-8").
 * @param transparent Whether the WebView should be transparent.
 * @param addCloseButton Whether the WebView should have a close button.
 */
void WebView_OpenWithData(const char* data, const char* mimeType, const char* encoding, bool transparent, bool addCloseButton);

/**
 * Checks whether the WebView is currently opened.
 * 
 * @return true if the WebView is opened, false otherwise.
 */
bool WebView_IsOpened();

/**
 * Closes and destroys the current WebView instance.
 */
void WebView_Close(void);

/**
 * Loads a new URL in the existing WebView instance.
 *
 * @param url The URL to load.
 */
void WebView_LoadURL(const char* url);

/**
 * Loads data content in the existing WebView instance.
 *
 * @param data The raw HTML or data string to display.
 * @param mimeType The MIME type of the content.
 * @param encoding The character encoding used in the data.
 */
void WebView_LoadData(const char* data, const char* mimeType, const char* encoding);

/**
 * Checks whether the WebView can navigate back in its history.
 *
 * @return `true` if back navigation is possible; otherwise, `false`.
 */
bool WebView_CanGoBack(void);

/**
 * Navigates back in the WebView history, if possible.
 */
void WebView_GoBack(void);

/**
 * Checks whether the WebView can navigate forward in its history.
 *
 * @return `true` if forward navigation is possible; otherwise, `false`.
 */
bool WebView_CanGoForward(void);

/**
 * Navigates forward in the WebView history, if possible.
 */
void WebView_GoForward(void);

/**
 * Reloads the current page in the WebView.
 */
void WebView_Reload(void);

/**
 * Stops loading the current page.
 */
void WebView_StopLoading(void);

/**
 * Clears all cached website data across all WebView instances.
 *
 * This includes memory and disk cache, local storage, and other persistent data used by the web engine.
 */
void WebView_ClearCache(void);

/**
 * Deletes all stored cookies across all WebView instances.
 *
 * This affects the global cookie storage and is not tied to a specific session.
 */
void WebView_ClearCookies(void);
