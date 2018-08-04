//
//  EventAdapter.swift
//  Chatalyze
//
//  Created by Mansa on 04/05/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import Foundation

class EventAdapter: NSObject {
    //Take the array of the data model Class
    var eventArray = [EventInfo]()
    var root:EventRootView?
}

extension EventAdapter:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventcell", for: indexPath) as? EventCell else {
            return UITableViewCell()
        }
        if indexPath.row < self.eventArray.count{
            
            cell.fillInfo(info:self.eventArray[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }    
}

extension EventAdapter:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {       
        return 378.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let role = SignedUserInfo.sharedInstance?.role else{
            return
        }
        if role == .analyst{
            
            let alert = UIAlertController(title: AppInfoConfig.appName, message: "Only user can book for the session!", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: { (action) in
            }))
            self.root?.controller?.present(alert, animated: true, completion: {
            })            
            return
        }
        
        
        guard let controller = EventLandingController.instance() else {
            return
        }
        controller.info = self.eventArray[indexPath.row]
        controller.dismissListener = {(success) in
            Log.echo(key: "yud", text: "result payment is \(success)")
            
            if success {
                RootControllerManager().getCurrentController()?.selectAccountTabWithTicketScreen()
            }
        }
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.root?.controller?.navigationController?.pushViewController(controller, animated: true)
        
//        guard let controller = SystemTestController.instance() else {
//            return
//        }
//        controller.info = self.eventArray[indexPath.row]
//        controller.presentingControllerObj = root?.controller
//        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        controller.dismissListner = {
//            DispatchQueue.main.async {
//                Log.echo(key: "yud", text: "I got dismiss call")
//                self.root?.controller?.dismiss(animated: false, completion: {
//                })
//            }
//        }
//        self.root?.controller?.present(controller, animated: true, completion: {
//        })
    }
}

