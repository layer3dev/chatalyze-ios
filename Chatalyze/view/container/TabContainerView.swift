//
//  TabContainerView.swift
//  Chatalyze Autography
//
//  Created by Sumant Handa on 29/04/17.
//  Copyright © 2017 Chatalyze. All rights reserved.
//

import UIKit

class TabContainerView: ExtendedView {
    
    enum tabType : Int {
        case event = 0
        case greeting = 1
        case account = 2
        case contact = 3
    }
    
    @IBOutlet fileprivate var eventTab : TabElementView?
    @IBOutlet fileprivate var greetingTab : TabElementView?
    @IBOutlet fileprivate var accountTab : TabElementView?
    @IBOutlet fileprivate var contactTab : TabElementView?
    var delegate : TabContainerViewInterface?    
    
    override func viewDidLayout(){
        super.viewDidLayout()
        initialization()
    }
    private func initialization(){
        initializeChild()
    }
    private func initializeChild(){
        
        eventTab?.type = .event
        greetingTab?.type = .greeting
        accountTab?.type = .account
        contactTab?.type = .contact
        eventTab?.delegate = self
        greetingTab?.delegate = self
        accountTab?.delegate = self
        contactTab?.delegate = self
    }
}

extension TabContainerView : TabElementInterface{
    
    func elementSelected(type : TabContainerView.tabType){
        
        selectTab(type : type)
        delegate?.elementSelected(type: type)
    }
    
    func selectTab(type : TabContainerView.tabType){
        
        resetTab()
        switch type {
            
        case .event:
            eventTab?.setTab()
        case .greeting:
            greetingTab?.setTab()
        case .account:
            accountTab?.setTab()
        case .contact:
            contactTab?.setTab()
        }
    }
    
    private func resetTab(){
        
        eventTab?.resetTab()
        greetingTab?.resetTab()
        accountTab?.resetTab()
        contactTab?.resetTab()
    }
    
    private func getElement(type : TabContainerView.tabType)->TabElementView?{
        switch type {
        case .event:
            return eventTab
        case .greeting:
            return greetingTab
        case .account:
            return accountTab
        case .contact:
            return contactTab
        }
    }
    
    func setActionPending(isPending : Bool, type : TabContainerView.tabType){
        let element = getElement(type: type)
        element?.isActionPending = isPending
    }    
}

