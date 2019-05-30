//
//  DbHtmlView.swift
//  PropzySam
//
//  Created by Dylan Bui on 10/19/18.
//  Copyright © 2018 Dylan Bui. All rights reserved.
//  Basse on : https://github.com/Vugla/PSHTMLView
//  Dung de hien thi text html hay url, ban dau chi co hien html, da sua lai cho hien url va add them UIProgressView


import UIKit
import WebKit

public protocol DbHtmlViewDelegate: class {
    func presentAlert(_ alertController: UIAlertController)
    func heightChanged(height: CGFloat)
    func shouldNavigate(for navigationAction: WKNavigationAction) -> Bool
    func handleScriptMessage(_ message: WKScriptMessage)
    func loadingProgress(progress: Float)
    func didFinishLoad()
}

// -- Define optional protocol --
extension DbHtmlViewDelegate {
    func presentAlert(_ alertController: UIAlertController) { }
    func heightChanged(height: CGFloat) { }
    func shouldNavigate(for navigationAction: WKNavigationAction) -> Bool { return true }
    func handleScriptMessage(_ message: WKScriptMessage) { }
}

public class DbHtmlView: UIView {
    
    private var progressView: UIProgressView!
    let webViewKeyPathsToObserve = ["estimatedProgress"]
    var webViewHeightConstraint: NSLayoutConstraint!
    
    public var baseUrl:URL? = nil {
        didSet {
            webView.loadHTMLString(html ?? "", baseURL: baseUrl)
        }
    }
    
    public var html: String? {
        didSet {
            // -- Allow scroll --
            webView.scrollView.isScrollEnabled = true
            webView.loadHTMLString(html ?? "", baseURL: baseUrl)
        }
    }
    
    public var htmlContent: String? {
        didSet {
            // -- Dont allow scroll --
            webView.scrollView.isScrollEnabled = false
            webView.loadHTMLString(html ?? "", baseURL: baseUrl)
        }
    }

    public var loadUrl:URL! {
        didSet {
            // -- Allow scroll --
            webView.scrollView.isScrollEnabled = true
            webView.load(URLRequest(url: loadUrl))
        }
    }
    
    public var progressBarColor:UIColor! {
        didSet {
            // Set UIColor.clear when hide
            progressView.progressTintColor = progressBarColor
        }
    }
    
    public weak var delegate: DbHtmlViewDelegate?
    public var webView: WKWebView! {
        didSet {
            addSubview(webView)
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            webView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            webView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            webViewHeightConstraint = webView.heightAnchor.constraint(equalToConstant: self.bounds.height)
            webViewHeightConstraint.isActive = true
            webView.scrollView.isScrollEnabled = false
            webView.allowsBackForwardNavigationGestures = false
            webView.contentMode = .scaleToFill
            webView.navigationDelegate = self
            webView.uiDelegate = self
            webView.scrollView.delaysContentTouches = false
            // webView.scrollView.decelerationRate = .normal
            webView.scrollView.delegate = self
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        let controller = WKUserContentController()
        addDefaultScripts(controller: controller)
        
        let config = WKWebViewConfiguration()
        config.userContentController = controller
        
        webView = WKWebView(frame: CGRect.zero, configuration: config)
        
        for keyPath in webViewKeyPathsToObserve {
            webView.addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
        }
        
        // -- DucBui Add UIProgressView --
        progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        progressView.progressTintColor = UIColor.blue
        progressView.trackTintColor = UIColor.clear
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 1.5)
        progressView.progress = 0.0        
        self.addSubview(progressView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        progressView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 1)
    }
    
    deinit {
        for keyPath in webViewKeyPathsToObserve {
            webView.removeObserver(self, forKeyPath: keyPath)
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else { return }
        
        switch keyPath {
            
        case "estimatedProgress":
            // -- Display process view --
            progressView.isHidden = Float(webView.estimatedProgress) == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            // -- Callback delegate --
            delegate?.loadingProgress(progress: Float(webView.estimatedProgress))
            
        default:
            break
        }
    }
    
    private func addDefaultScripts(controller: WKUserContentController) {
        controller.addUserScript(DbHtmlViewScripts.viewportScript)
        controller.addUserScript(DbHtmlViewScripts.disableSelectionScript)
        controller.addUserScript(DbHtmlViewScripts.disableCalloutScript)
        controller.addUserScript(DbHtmlViewScripts.addToOnloadScript)
        
        //add contentHeight script and handler
        controller.add(self, name: DbHtmlViewScriptMessage.HandlerName.onContentHeightChange.rawValue)
        controller.addUserScript(DbHtmlViewScripts.heigthOnLoadScript)
        controller.addUserScript(DbHtmlViewScripts.heigthOnResizeScript)
    }
    
    public func addScript(_ scriptString: String, observeMessageWithName: DbHtmlViewScriptMessage.HandlerName? = nil) {
        webView.configuration.userContentController.addUserScript(WKUserScript(source: scriptString, injectionTime: .atDocumentEnd, forMainFrameOnly: true))
        if let observeMessageWithName = observeMessageWithName {  webView.configuration.userContentController.add(self, name: observeMessageWithName.rawValue)
        }
    }
    
}

extension DbHtmlView: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        delegate?.didFinishLoad()
        // -- Stop proccess view --
        progressView.setProgress(0, animated: false)
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let delegate = delegate {
            return decisionHandler(delegate.shouldNavigate(for: navigationAction) ? .allow : .cancel)
        }
        return decisionHandler(.allow)
    }
}

extension DbHtmlView: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == DbHtmlViewScriptMessage.HandlerName.onContentHeightChange.rawValue {
            guard let responseDict = message.body as? [String:Any], let height = responseDict["height"] as? Float, webViewHeightConstraint.constant != CGFloat(height) else {
                return
            }
            webViewHeightConstraint.constant = CGFloat(height)
            delegate?.heightChanged(height: CGFloat(height))
        }
        delegate?.handleScriptMessage(message)
    }
    
    
}

extension DbHtmlView: WKUIDelegate {
    /// Handle javascript:alert(...)
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
            completionHandler()
        }
        
        alertController.addAction(okAction)
        
        delegate?.presentAlert(alertController)
    }
    
    /// Handle javascript:confirm(...)
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
            completionHandler(true)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
            completionHandler(false)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        delegate?.presentAlert(alertController)
    }
    
    /// Handle javascript:prompt(...)
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        let alertController = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }
        
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { action in
            let textField = alertController.textFields![0] as UITextField
            completionHandler(textField.text)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
            completionHandler(nil)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        delegate?.presentAlert(alertController)
    }
    
    
}

extension DbHtmlView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}

struct DbHtmlViewScripts {
    //strings
    private static let viewportScriptString = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); meta.setAttribute('initial-scale', '1.0'); meta.setAttribute('maximum-scale', '1.0'); meta.setAttribute('minimum-scale', '1.0'); meta.setAttribute('user-scalable', 'no'); document.getElementsByTagName('head')[0].appendChild(meta);"
    private static let disableSelectionScriptString = "document.documentElement.style.webkitUserSelect='none';"
    private static let disableCalloutScriptString = "document.documentElement.style.webkitTouchCallout='none';"
    private static let addToOnloadScriptString = "function addLoadEvent(func) { var oldonload = window.onload; if (typeof window.onload != 'function') { window.onload = func; } else { window.onload = function() { if (oldonload) { oldonload(); } func(); } } } addLoadEvent(nameOfSomeFunctionToRunOnPageLoad); addLoadEvent(function() { }); "
    private static let heigthOnLoadScriptString = "window.onload= function () {window.webkit.messageHandlers.\(DbHtmlViewScriptMessage.HandlerName.onContentHeightChange.rawValue).postMessage({justLoaded:true,height: document.body.offsetHeight});};"
    private static let heigthOnResizeScriptString = "function incrementCounter() {window.webkit.messageHandlers.\(DbHtmlViewScriptMessage.HandlerName.onContentHeightChange.rawValue).postMessage({height: document.body.offsetHeight});}; document.body.onresize = incrementCounter;"
    
    static let getContentHeightScriptString = "document.body.offsetHeight"
    
    
    //scripts
    static let viewportScript = WKUserScript(source: viewportScriptString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    static let disableSelectionScript = WKUserScript(source: disableSelectionScriptString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    static let disableCalloutScript = WKUserScript(source: disableCalloutScriptString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    static let addToOnloadScript = WKUserScript(source: addToOnloadScriptString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    static let heigthOnLoadScript = WKUserScript(source: heigthOnLoadScriptString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    static let heigthOnResizeScript = WKUserScript(source: heigthOnResizeScriptString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    
}

public struct DbHtmlViewScriptMessage {
    public struct HandlerName : RawRepresentable, Equatable, Hashable, Comparable {
        public var rawValue: String
        
        public var hashValue: Int
        
        public static func <(lhs: DbHtmlViewScriptMessage.HandlerName, rhs: DbHtmlViewScriptMessage.HandlerName) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
        
        public init(_ rawValue: String) {
            self.rawValue = rawValue
            self.hashValue = rawValue.hashValue
        }
        public init(rawValue: String) {
            self.rawValue = rawValue
            self.hashValue = rawValue.hashValue
        }
    }
}

extension DbHtmlViewScriptMessage.HandlerName {
    public static let onContentHeightChange = DbHtmlViewScriptMessage.HandlerName("onContentHeightChange")
}
