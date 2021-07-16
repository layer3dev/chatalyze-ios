//
//  PageScrollerController.swift
//  Chatalyze
//
//  Created by Mansa on 04/10/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class PageScrollerController: InterfaceExtendedController,UIScrollViewDelegate {
    
    private var scrollImageOne:UIImageView = UIImageView()
    private var xofTheImage:CGFloat = 0.0
    @IBOutlet private var pageScroller:UIScrollView?
    private var zoomView:UIImageView?
    private let mySingleView:UIView = UIView()
    private var scrollViewWidth:CGFloat = CGFloat()
    private var scrollViewHeight:CGFloat  = CGFloat()
    @IBOutlet private var pagerView:UIView?
    @IBOutlet private var pager:UIPageControl?
    var showingImage:UIImage?
    var deleteCell:(()->())?
    var info:MemoriesInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializePaging()
        initializeTapGestureForZoomingImage()
        paintInterFace()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.dismiss(animated: true) {
            Log.echo(key: "identifier", text: "I am hiding in the ViewWillDisappear")
        }
    }
    
    
    
    @IBAction func twitterShareAction(sender:UIButton){
        
        guard let memoryImage = self.showingImage else{
            return
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            let activityItem: [AnyObject] = [memoryImage]
            let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
            avc.popoverPresentationController?.sourceView = self.view
            avc.popoverPresentationController?.sourceRect = sender.frame
            self.present(avc, animated: true, completion: nil)
            
        }else{
            
            let activityItem: [AnyObject] = [memoryImage]
            let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
            self.present(avc, animated: true, completion: nil)
            
        }
    }
    
    private func  paintInterFace(){
        
        self.pagerView?.layer.cornerRadius = 12.5
        self.pagerView?.clipsToBounds = true
    }
    
    private func  initializeTapGestureForZoomingImage(){
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap(gestureRecognizer:)))
        tapRecognizer.numberOfTapsRequired = 2
        self.pageScroller?.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func onDoubleTap(gestureRecognizer: UITapGestureRecognizer) {
        
        guard let zoomScale = self.pageScroller?.zoomScale else {
            return
        }
        guard let minZoomScale = self.pageScroller?.minimumZoomScale else {
            return
        }
        if zoomScale > minZoomScale {
            self.pageScroller?.setZoomScale(minZoomScale, animated: true)
        }
        else{
            self.pageScroller?.setZoomScale(2.0, animated: true)
        }
    }
    @IBAction private func closeController(){
        self.dismiss(animated: true) {
        }
    }
    
    private func initializePaging(){
        
        self.pager?.currentPage = 0
        self.view.layoutIfNeeded()
        xofTheImage = 0.0
        guard let superViewHeight = self.pageScroller?.bounds.size.height else{
            return
        }
        guard let superViewWidth = self.pageScroller?.bounds.size.width else{
            return
        }
        scrollViewWidth = superViewWidth
        scrollViewHeight = superViewHeight - 60
        self.pageScroller?.minimumZoomScale = 1.0
        self.pageScroller?.maximumZoomScale = 5.0
        self.scrollImageOne = UIImageView(frame: CGRect(x:(xofTheImage*scrollViewWidth), y:0,width:scrollViewWidth, height:scrollViewHeight))
        
            if let image = self.showingImage{
                
                scrollImageOne.image = image
                xofTheImage = xofTheImage + 1
                mySingleView.frame = CGRect(x: 0, y: 0, width: scrollViewWidth * xofTheImage, height: scrollViewHeight)
                mySingleView.addSubview(scrollImageOne)
            }
        
        self.pageScroller?.addSubview(mySingleView)
        self.pager?.numberOfPages = Int(xofTheImage)
        scrollImageOne.contentMode = .scaleAspectFit
        scrollImageOne.clipsToBounds = true
        self.pageScroller?.clipsToBounds = true
        self.pageScroller?.contentSize = CGSize(width:scrollViewWidth * xofTheImage, height:scrollViewHeight)
        self.pageScroller?.delegate = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.view.layoutIfNeeded()
        guard let zoomScale = self.pageScroller?.zoomScale else{
            return
        }
        if zoomScale > 1.0{
            UIView.animate(withDuration: 0.45, animations: {
                self.pagerView?.alpha = 0
            })
        }else{
            UIView.animate(withDuration: 0.45, animations: {
                self.pagerView?.alpha = 1
            })
        }
        let contentOffset = scrollView.contentOffset.x
        let currentPage:Int = Int(floor((contentOffset-scrollViewWidth/2)/scrollViewWidth)+1)
        if currentPage != self.pager?.currentPage{
            self.pager?.currentPage = currentPage
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mySingleView
    }
    
    
    //Delete memory Cell
    
    @IBAction func deleteMemory(sender:UIButton){
        
        self.alert(withTitle: "Delete Image", message: "Are you sure you want to delete this image?".localized() ?? "", successTitle: "Yes".localized() ?? "", rejectTitle: "No".localized() ?? "", showCancel: true) { (success) in
            
            if !success{
                return
            }
            self.deleteImage()
        }
    }
    
    func deleteImage(){
        
        guard let memoryId = self.info?.id else {
            return
        }
        
        self.showLoader()
        DeleteMemory().delete(id: memoryId) { (success, response) in
           
            self.stopLoader()
            if !success{
                return
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    if let delete = self.deleteCell{
                        delete()
                    }
                }
            }
        }
    }
    
    class func instance()->PageScrollerController?{
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PageScrollerController") as? PageScrollerController
        return controller
    }
}


extension PageScrollerController{
    
    
}
