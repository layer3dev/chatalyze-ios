//
//  APIVersionControl.swift
//  Chatalyze Autography
//
//  Created by Mansa on 23/11/17.
//  Copyright © 2017 Chatalyze. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class APIVersionControl:NSObject{
    
    var apiVersionInfo:APIVersionInfo?
    
    func checkForAPIVersionControl(completion : @escaping ((_ success : Bool, _ response : APIVersionInfo?)->())){
        
        //UserDefaults.standard.value(forKey: "deprecated_version")
        guard let apiInfo = APIVersionInfo.sharedInstance else{
            
            CheckForAPIVersionRequest().getApiInfo(user_id: "", completion: { (success, response) in
                
                if !(success){
                    return     
                }
                Log.echo(key: "yud", text: "Response that I am getting is \(String(describing: response))")
                guard let responseData = response else {
                    return
                }                
                let currentDate : Date = Date()
                let apiObj = APIVersionInfo.init(info: responseData, lastCheckedDate: currentDate,lastCheckedDateForWarning:nil)
                self.apiVersionInfo = apiObj
                completion(true,self.apiVersionInfo)
            })
            return
        }
        
        CheckForAPIVersionRequest().getApiInfo(user_id: "", completion: { (success, response) in            
            if !(success){
                return
            }
            Log.echo(key: "yud", text: "Response that I am getting is \(String(describing: response))")
            guard let responseData = response else {
                return
            }
            let currentDate : Date = Date()
            APIVersionInfo.sharedInstance?.fillInfo(info: responseData, lastCheckedDate: currentDate,lastCheckedDateForWarning:nil)
            self.apiVersionInfo = APIVersionInfo.sharedInstance
            completion(true,self.apiVersionInfo)
        })
        return
        
    }
    
    
    func checkForDepricateAlert()->(Bool,String,String){
        
        guard let warningVersion = APIVersionInfo.sharedInstance?.warningVersion else{
            return (false,"","")
        }
        guard let m = NumberFormatter().number(from: warningVersion) else {return (false,"","")
        }
        let dv = CGFloat(m)
        guard let l = NumberFormatter().number(from: AppInfoConfig.appversion) else { return (false,"","")
        }
        let av = CGFloat(l)
        Log.echo(key: "yud", text: ("dv is \(dv), av is \(av)"))
        if av <= dv  {
            
            let ud = UserDefaults.standard
            if ((ud.value(forKey: "last_checked_date_for_warning") as? Date) != nil){
                Log.echo(key: "yud", text: "app is going to be depricated")
                let currentDate : Date = Date()
                Log.echo(key: "yud", text: "Current Date is \(currentDate)")
                let dateFormatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
                    formatter.timeZone = TimeZone.current
                    return formatter
                } ()
                //let endingTimeOfCallFromServer = "2017-10-31T12:41:00.000Z"
                guard let last_checked_time = APIVersionInfo.sharedInstance?.lastWarningShowTime else{
                    return (false,"","")
                }
                guard let remainingTimeofDeprication = APIVersionInfo.sharedInstance?.endDateOfDeprication else{
                    return (false,"","")
                }
                
                guard let timeleftForDeprication = dateFormatter.date(from: remainingTimeofDeprication) else{
                    return (false,"","")
                }
                
                //let remainingTimeDiffernce = currentDate.timeOfDayInterval(toDate: timeleftForDeprication)
                
                let timeLeft = timeleftForDeprication.timeIntervalSinceNow
                let (days ,hour , minutes, second) =  secondsToHoursMinutesSeconds(seconds: Int(timeLeft))
                Log.echo(key: "yud", text: "days are \(days) , hours are \(hour) minutes are \(minutes) seconds are \(second)")
                let diff = currentDate.timeIntervalSince(last_checked_time)
                Log.echo(key: "yud", text: "Time Diffrence in seconds are\(diff)")
                
                //172800.0
                if diff >= 172800.0{
                    //self.showDepricateAlert()
                    print("Time exceeds to the forty eight hours")
                    return (true,"Remaining time is  \(days) days \(hour) hours  \(minutes) minutes \(second) seconds ","This version of our app will soon no longer work.Please update to the latest version now to aoid any issues")
                } else if diff < 172800.0{
                    print("Time of the day in the forty eight is greater")
                    return (false,"","")
                }else{
                    print("Times of the day in both dates are equal")
                    return (false,"","")
                }
                
            }else{
                
                let cd = Date()
                let ud = UserDefaults.standard
                /*Below two lines are written because alert will show untill we can click on the ok  button.Even if delay Screen changes.And include the starting time when ok button will present
                 */
                
//                ud.set(cd, forKey: "last_checked_date_for_warning")
//                APIVersionInfo.sharedInstance?.lastWarningShowTime = cd
                
                Log.echo(key: "yud", text: "app is going to be depricated")
                let currentDate : Date = Date()
                Log.echo(key: "yud", text: "Current Date is \(currentDate)")
                let dateFormatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
                    formatter.timeZone = TimeZone.current
                    return formatter
                } ()
                
                guard let remainingTimeofDeprication = APIVersionInfo.sharedInstance?.endDateOfDeprication else{
                    return (false,"","")
                }
                //Dates used for the comparison
                guard let leftTimeOfDeprication = dateFormatter.date(from: remainingTimeofDeprication) else{
                    return (false,"","")
                }
                //let remainingTimeDiffernce = currentDate.timeOfDayInterval(toDate: leftTimeOfDeprication)
                let timeLeft = leftTimeOfDeprication.timeIntervalSinceNow
                let (days ,hour , minutes, second) =  secondsToHoursMinutesSeconds(seconds: Int(timeLeft))
                Log.echo(key: "yud", text: "days are \(days) , hours are \(hour) minutes are \(minutes) seconds are \(second)")
                Log.echo(key: "yud", text: "Remaining time in seconds are \(timeLeft)")
                //self.showDepricateAlert()
                return (true,"Remaining time is \(days) days \(hour) hours  \(minutes) minutes \(second) seconds ","This version of our app will soon no longer work.Please update to the latest version now to aoid any issues")
            }
        }else{
            
            let ud = UserDefaults.standard
            ud.set("", forKey: "last_checked_date_for_warning")
            APIVersionInfo.sharedInstance?.lastWarningShowTime = nil
            return (false,"","")
        }
    }
    
    func checkforUpadteTime()->Bool{
        
        let currentDate : Date = Date()
        Log.echo(key: "yud", text: "Current Date is \(currentDate)")
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.timeZone = TimeZone.current
            return formatter
        }()
        //let endingTimeOfCallFromServer = "2017-10-31T12:41:00.000Z"
        Log.echo(key: "yud", text: "I AM GETTING OOUT OOPS!!()")
        
//        guard let apiInfoDict = APIVersionInfo.sharedInstance?.apiInfo else{
//            return false
//        }
        guard let last_checked_time = APIVersionInfo.sharedInstance?.lastCheckedDate  else{
            return false
        }
        
        Log.echo(key: "yud", text: "I AM GETTING In YES!!\(last_checked_time)")
        //Dates used for the comparison
//        guard let endingTimeOfCallInDesiredFormat = dateFormatter.date(from: endingTimeOfCallFromServer)else{
//            return
//        }
        Log.echo(key: "yud", text: "Date is reached \(String(describing: last_checked_time))")
        let diff = currentDate.timeOfDayInterval(toDate: last_checked_time)
      //  Log.echo(key: "yud", text: "Date Diffrence is checking\(currentDate.timeOfDayInterval(toDate: last_checked_time))")
      //  Log.echo(key: "yud", text: "Date Diffrence is\(diff)")
        // as text
        
        let timeIntervalFormatter = DateComponentsFormatter()
        timeIntervalFormatter.unitsStyle = .abbreviated
        timeIntervalFormatter.allowedUnits = [.hour, .minute, .second]
        print("Difference between times since midnight is", timeIntervalFormatter.string(from: diff) ?? "n/a")
        if diff > 0.0 {
            print("Time of the day in the second date is greater")
            return false
        } else if diff <= 0.0 {
            print("Time of the day in the first date is greater")
            return true
        } else {
             print("Times of the day in both dates are equal")
            return false
        }
    }
    
    func checkForDeprecatedVersion()->Bool{
       
        guard let deprecatedVersion = APIVersionInfo.sharedInstance?.deprecatedVersion else{
            return false
        }
        guard let m = NumberFormatter().number(from: deprecatedVersion) else { return false
        }
        let dv = CGFloat(m)
        guard let l = NumberFormatter().number(from: AppInfoConfig.appversion) else { return false
        }
        let av = CGFloat(l)
        Log.echo(key: "yud", text: ("dv is \(dv), av is \(av)"))
        if av <= dv  {
            Log.echo(key: "yud", text: "app is depricated")
            return true
        }else{
            Log.echo(key: "yud", text: "app version is not deprecated")
            return false
        }
    }
    
    func showDepricateAlert(){
        
        let (success,remainingTimeToDepricate,remainingTimeToShowAlert) = APIVersionControl().checkForDepricateAlert()
        Log.echo(key: "yud", text: "App is going to be depricate logs with success \(success) \(remainingTimeToDepricate)")
        
        if success == true{
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let window = appDelegate?.window
            guard let controller = window?.rootViewController else{
                Log.echo(key: "yud", text: "Root is not set yet")
                return
            }
            guard let depricateController = DeprecateAlertController.instance() else{
                return
            }
            depricateController.modalPresentationStyle = .overCurrentContext
            controller.present(depricateController, animated: true, completion: {
            })
            /*let alert = UIAlertController(title: "Chatalyze Tool",         message: remainingTimeToShowAlert , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                
            }))
            controller.present(alert, animated: true, completion: {
            })*/
            Log.echo(key: "yud", text: "App is going to be depricate in the time \(remainingTimeToDepricate)")
        }else{
            Log.echo(key: "yud", text: "Its not the time to show the warning \(remainingTimeToShowAlert)")
        }
    }

    func checkUpdatetAlert()->(Bool,String,String){
        
        guard let warningVersion = APIVersionInfo.sharedInstance?.warningVersion else{
            return (false,"","")
        }
        guard let m = NumberFormatter().number(from: warningVersion) else {return (false,"","")
        }
        let dv = CGFloat(m)
        guard let l = NumberFormatter().number(from: AppInfoConfig.appversion) else { return (false,"","")
        }
        let av = CGFloat(l)
        
        guard let latestversion = APIVersionInfo.sharedInstance?.currentVersion else{
            return (false,"","")
        }
        guard let n = NumberFormatter().number(from: latestversion) else {return (false,"","")
        }
        let lv = CGFloat(n)
        
        Log.echo(key: "yud", text: ("dv is \(dv), av is \(av)"))
        if av <= dv  {
            let ud = UserDefaults.standard
            let instance = APIVersionInfo.sharedInstance
            instance?.lastUpdateWarning = nil
            ud.set("", forKey: "last_update_warning_time")
            return(false,"","")
        }else{
            if av < lv{
                let ud = UserDefaults.standard
                Log.echo(key: "yud", text: "\(ud.value(forKey: "last_update_warning_time") as? Date)")
                if ((ud.value(forKey: "last_update_warning_time") as? Date) != nil){
                    let currentDate : Date = Date()
                    //let endingTimeOfCallFromServer = "2017-10-31T12:41:00.000Z"
                    Log.echo(key: "yud", text: "\(APIVersionInfo.sharedInstance?.lastUpdateWarning)")
                    guard let last_checked_time = APIVersionInfo.sharedInstance?.lastUpdateWarning else{
                        return (false,"","")
                    }
                    let timeLeft = currentDate.timeIntervalSince(last_checked_time)
                    Log.echo(key: "yud", text: "Time Left in updating alert for update is \(timeLeft)")
                    //172800.0
                    if timeLeft >= 172800.0{
                        //self.showDepricateAlert()
                        print("Time exceeds to the forty eight hours")
                        return (true,"\(timeLeft)","This version of our app is outdated.We recommend updated to latest version")
                    } else if timeLeft < 172800.0{
                        print("Time of the day in the forty eight is greater")
                        return (false,"","")
                    }else{
                        print("Times of the day in both dates are equal")
                        return (false,"","")
                    }
                }else{
                    
                    /*Below commented code is written because alert will show untill we can click on the ok  button.Even if delay Screen changes.And include the starting time when ok button will present
                     */
                    
//                    let cd = Date()
//                    let ud = UserDefaults.standard
//                    let instance = APIVersionInfo.sharedInstance
//                    instance?.lastUpdateWarning = cd
//                    Log.echo(key: "yud", text: "First time I set the value of the Date")
//                    ud.set(cd, forKey: "last_update_warning_time")
                    
                    return(true,"0 Sec.","This version of our app is outdated.We recommend updated to latest version")
                }
            }else{
                
                let ud = UserDefaults.standard
                let instance = APIVersionInfo.sharedInstance
                instance?.lastUpdateWarning = nil
                ud.set("", forKey: "last_update_warning_time")
                return(false,"","")
            }
        }
    }
    
    func showUpdateAlert(){
        
        let (success,remainingTimeAlert,alertMessage) = APIVersionControl().checkUpdatetAlert()
        Log.echo(key: "yud", text: "App is going to show alert after time logs with success \(success) \(remainingTimeAlert)")
        if success == true{
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let window = appDelegate?.window
            guard let controller = window?.rootViewController else{
                Log.echo(key: "yud", text: "Root is not set yet")
                return
            }
            guard let alertController = UpdateAlertController.instance() else{
                return
            }
            alertController.modalPresentationStyle = .overCurrentContext
            controller.present(alertController, animated: true, completion: {
            })
//            let alert = UIAlertController(title: "Chatalyze Tool", message: "\(alertMessage)", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
//
//            }))
//            controller.present(alert, animated: true, completion: {
//
//            })
            Log.echo(key: "yud", text: "App is going to show alert after time logs with success \(success) \(remainingTimeAlert)")
        }else{
            Log.echo(key: "yud", text: "Its not the time to show the alert warning, time pending to show alert is  \(remainingTimeAlert)")
        }
    }
    
    func checkForAgainUpdateWebservice()->Bool{
      
        let currentDate : Date = Date()
        Log.echo(key: "yud", text: "Current Date is \(currentDate)")
        let dateFormatter: DateFormatter = {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.timeZone = TimeZone.current
            return formatter
        } ()
        //let endingTimeOfCallFromServer = "2017-10-31T12:41:00.000Z"
        Log.echo(key: "yud", text: "I AM GETTING OOUT OOPS!!()")
        

        guard let last_checked_time = APIVersionInfo.sharedInstance?.lastCheckedDate else{
            return false
        }
        
        Log.echo(key: "yud", text: "I AM GETTING In YES!!\(last_checked_time)")
        
        Log.echo(key: "yud", text: "Date is reached \(String(describing: last_checked_time))")
        let diff = last_checked_time.timeOfDayInterval(toDate: currentDate)
        
        let timeIntervalFormatter = DateComponentsFormatter()
        timeIntervalFormatter.unitsStyle = .abbreviated
        timeIntervalFormatter.allowedUnits = [.hour, .minute, .second]
        print("Difference between times since midnight is", timeIntervalFormatter.string(from: diff) ?? "n/a")
        //43200.0
        if diff >= 43200.0 {
            print("Time exceeds to the twelve hours")
            return true
        } else if diff < 43200.0 {
            return false
            print("Time of the day in the first date is greater")
        } else {
            return false
            print("Times of the day in both dates are equal")
        }
    }
}

extension APIVersionControl{
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int,Int, Int, Int) {
        return ((seconds / 3600)/24,(seconds / 3600)%24, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
