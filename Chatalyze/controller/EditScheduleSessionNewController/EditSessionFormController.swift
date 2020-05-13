//
//  EditSessionFormController.swift
//  Chatalyze
//
//  Created by mansa infotech on 19/03/19.
//  Copyright © 2019 Mansa Infotech. All rights reserved.
//
import UIKit

class EditSessionFormController: InterfaceExtendedController {
    
    var eventInfo:EventInfo?
    @IBOutlet var scrollViewCustom:FieldManagingScrollView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
    
    }
    
    @IBAction func moreDetailTitleAction(sender:UIButton){
        
        guard let controller = SingleSessionPageMoreDetailAlertController.instance() else {
            return
        }
        controller.currentInfo = .title
        controller.controller = self
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true) {
        }
        
    }
    
    @IBAction func bookingStyleMoreAction(sender:UIButton){
        
        guard let controller = SingleSessionPageMoreDetailAlertController.instance() else {
            return
        }
        controller.currentInfo = .bookingStyle
        controller.controller = self
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true) {
        }
    }
    
    @IBAction func moreDetailDateAction(sender:UIButton){
        
        guard let controller = SingleSessionPageMoreDetailAlertController.instance() else {
            return
        }
        controller.currentInfo = .date
        controller.controller = self
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true) {
        }
    }
    
    @IBAction func moreDetailTimeAction(sender:UIButton){
        
        guard let controller = SingleSessionPageMoreDetailAlertController.instance() else {
            return
        }
        controller.currentInfo = .time
        controller.controller = self
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true) {
        }
    }
    
    
    @IBAction func moreDetailSessionLengthAction(sender:UIButton){
        
        guard let controller = SingleSessionPageMoreDetailAlertController.instance() else {
            return
        }
        controller.currentInfo = .sessionLength
        controller.controller = self
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true) {
        }
    }
    
    @IBAction func moreDetailSponsorAction(sender:UIButton){
        
        guard let controller = SingleSessionPageMoreDetailAlertController.instance() else {
            return
        }
        controller.currentInfo = .sponsor
        controller.controller = self
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true) {
        }
    }
  
    
    @IBAction func moreDetailChatLengthAction(sender:UIButton){
        
        guard let controller = SingleSessionPageMoreDetailAlertController.instance() else {
            return
        }
        controller.currentInfo = .singleChatLength
        controller.controller = self
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true) {
        }
    }
    
    @IBAction func moreDetailChatTypeAction(sender:UIButton){
        
        guard let controller = SingleSessionPageMoreDetailAlertController.instance() else {
            return
        }
        controller.currentInfo = .chatPrice
        controller.controller = self
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true) {
        }
    }
    
    @IBAction func moreDetaildonationAction(sender:UIButton){
        
        guard let controller = SingleSessionPageMoreDetailAlertController.instance() else {
            return
        }
        controller.currentInfo = .donation
        controller.controller = self
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true) {
        }
    }
    
    @IBAction func screenShotAction(sender:UIButton){
        
        guard let controller = SingleSessionPageMoreDetailAlertController.instance() else {
            return
        }
        controller.currentInfo = .screenShot
        controller.controller = self
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true) {
        }
    }
    
    @IBAction func autographMoreInfoAction(sender:UIButton){
        
        guard let controller = SingleSessionPageMoreDetailAlertController.instance() else {
            return
        }
        controller.currentInfo = .autograph
        controller.controller = self
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true) {
        }
    }
    
    @IBAction func moreDetailBreakAction(sender:UIButton){
        
        guard let controller = SingleSessionPageMoreDetailAlertController.instance() else {
            return
        }
        controller.currentInfo = .breakScroll
        controller.controller = self
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true) {
        }
    }
    
    func load(){
       
        self.rootView?.controller = self
        fetchMinimumPlanPriceToScheuleIfExists()
        paintInterface()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func rootInitialization() {
        
        DispatchQueue.main.async {
            
            self.rootView?.initializeVariable()
            self.rootView?.fillInfo(info:self.eventInfo)
        }
    }
    
    func paintInterface(){
        
        rootView?.paintInteface()
        paintBackButton()
        paintNavigationTitle(text: "Edit Session")
        showNavigationBar()
      
    }

    var rootView:EditSessionFormRootView?{
        
        return self.view as? EditSessionFormRootView
    }
    
    func fetchMinimumPlanPriceToScheuleIfExists() {
        
        self.showLoader()
        GetPlanRequestProcessor().fetch { (success,error,response) in
            
            self.fetchSupportedChats()
            
            if !success {
                return
            }
            
            guard let response = response else{
                return
            }
            
            let info = PlanInfo(info: response)
            self.rootView?.scheduleInfo?.minimumPlanPriceToSchedule = info.minPrice ?? 0.0
            self.rootView?.planInfo = info
            
            Log.echo(key: "Earning Screen", text: "id of plan is \(String(describing: info.id)) name of the plan is \(String(describing: info.name)) min. price is \(String(describing: info.minPrice)) and the plan fee is \(String(describing: info.chatalyzeFee))")
        }
    }
    
    func fetchNewInfo(){
        
        guard let id = self.eventInfo?.id else{
            return
        }
        
        CallEventInfo().fetchInfo(eventId:"\(id)") { (success, info) in
            
            DispatchQueue.main.async {
                
                self.stopLoader()
                if let newInfo = info{
                    self.eventInfo = newInfo
                }
                self.rootInitialization()
                return
            }
        }
    }
    
    func fetchSupportedChats(){
        
        FetchSupportedChats().fetch { (success,error,response) in
            
            DispatchQueue.main.async {
                
                self.fetchNewInfo()
                if !success{
                    return
                }
                guard let info = response else {
                    return
                }
                let supportedChatsJSONArray = info.arrayValue
                var requiredChats = [String]()
                for info in supportedChatsJSONArray{
                    if let existInfo = info.string{
                        requiredChats.append(existInfo)
                    }
                }
                self.rootView?.chatLengthArray = requiredChats
            }
        }
    }
    
    
    func cancelSession(){
        
        guard let id = self.eventInfo?.id else{
            return
        }
        self.showLoader()
        CancelSessionProcessor().cancel(id: "\(id)") {(success, response) in
            
            DispatchQueue.main.async {
                
                self.stopLoader()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    class func instance()->EditSessionFormController?{
        
        let storyboard = UIStoryboard(name: "EditScheduleSession", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EditSessionForm") as? EditSessionFormController
        return controller
    }
}
