//
//  YoutubeContainerView.swift
//  Chatalyze
//
//  Created by Gunjot Singh on 19/05/20.
//  Copyright © 2020 Mansa Infotech. All rights reserved.
//

import Foundation
import YoutubePlayer_in_WKWebView

class YoutubeContainerView : ExtendedView {
    
    @IBOutlet private var youtubePlayerView : WKYTPlayerView?
    @IBOutlet private var heightConstraint : NSLayoutConstraint?
    private var isActive = false
    @IBOutlet private var topPortraitConstraint : NSLayoutConstraint?
    @IBOutlet private var topLandscapeConstraint : NSLayoutConstraint?
    
    @IBOutlet private var leftConstraint : NSLayoutConstraint?
    @IBOutlet private var rightConstraint : NSLayoutConstraint?
    
    private var playerConfiguration = [String : Any]()
    
    override func viewDidLayout() {
        
        super.viewDidLayout()
        
        initialization()
    }
    
    private func listenToRotation(){
        NotificationCenter.default.addObserver(self, selector: #selector(didRotate), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func didRotate(){
        
        updateLayoutRotation()
    }
    
    func updateLayoutRotation() {
        
        if(UIDevice.current.orientation.isFlat){
            if UIApplication.shared.statusBarOrientation.isLandscape{
                updateForLandscape()
            }else{
                updateForPortrait()
            }
            return
        }

        if (UIDevice.current.orientation.isLandscape) {
            updateForLandscape()
            return
        }
        if(UIDevice.current.orientation.isPortrait) {
            updateForPortrait()
            return
        }
    }
    
    
    func updateForPortrait(){
        
        topPortraitConstraint?.isActive = true
        topLandscapeConstraint?.isActive = false
        leftConstraint?.constant = 0
        rightConstraint?.constant = 0
    }
    
    var isIPad : Bool{
        get{
            return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
        }
    }
    
    func updateForLandscape(){
       
        topPortraitConstraint?.isActive = false
        topLandscapeConstraint?.isActive = true
        
        var padding = CGFloat(128 + 30)
        if(isIPad){
            padding = CGFloat(224 + 30)
        }
        
        leftConstraint?.constant = padding
        rightConstraint?.constant = padding
    }
    
    private func initialization(){
        updateLayoutRotation()
        listenToRotation()
        
        
        var params = [String : Any]()
        params["playsinline"]  = 1
        params["allowsInlineMediaPlayback"]=1
        params["controls"] = 1
        params["fs"] = 0
        params["iv_load_policy"] = 0
        params["loop"] = 1
        params["modestbranding"] = 1
        params["rel"] = 0
        params["showInfo"] = 0
        
        
        playerConfiguration = params
        
        youtubePlayerView?.webView?.backgroundColor = UIColor.black
        youtubePlayerView?.backgroundColor = UIColor.black
        youtubePlayerView?.delegate = self
    }
    
    private func parseVideoId(rawUrl : String) -> String{
        let parsedPrefix = rawUrl.replacingOccurrences(of: "https://www.youtube.com/embed/", with: "")
        let parsedSuffix = parsedPrefix.replacingOccurrences(of: "?autoplay=0", with: "")
        return parsedSuffix
    }
    
    //https://www.youtube.com/watch?v=-KXGw9J5n1o
    func load(rawUrl : String){
        
        Log.echo(key: "YoutubeContainerView", text: "rawUrl -> \(rawUrl)")
        
        if(isActive){
            return
        }
        
        isActive = true
        
        let videoId = parseVideoId(rawUrl: rawUrl)
        
        Log.echo(key: "YoutubeContainerView", text: "videoId -> \(videoId)")
        youtubePlayerView?.load(withVideoId: videoId, playerVars : playerConfiguration)
    }
    
    func show(){
        
        if(!isActive){
            return
        }
        guard let heightConstraint = heightConstraint
            else{
                return
        }
        if(heightConstraint.priority.rawValue == 1){
            return
        }
        
        heightConstraint.priority = UILayoutPriority.init(rawValue: 1)
    }
    
    func hide(){
        
        if(!isActive){
            return
        }
        guard let heightConstraint = heightConstraint
            else{
                return
        }
        if(heightConstraint.priority.rawValue == 999){
            return
        }
        
        heightConstraint.priority = UILayoutPriority.init(rawValue: 999)
        youtubePlayerView?.pauseVideo()
        youtubePlayerView?.removeWebView()
    }
}

extension YoutubeContainerView : WKYTPlayerViewDelegate{
    
    func playerViewPreferredWebViewBackgroundColor(_ playerView: WKYTPlayerView) -> UIColor {
        return .black
    }
    
    func playerViewPreferredInitialLoading(_ playerView: WKYTPlayerView) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }
    
    
    func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
        
        if state == .ended{
            
            self.youtubePlayerView?.playVideo()
            self.youtubePlayerView?.stopVideo()
        }
    }
}
