//
//  TestController.swift
//  Chatalyze
//
//  Created by Mansa on 10/09/18.
//  Copyright © 2018 Mansa Infotech. All rights reserved.
//

import UIKit

class TestController: InterfaceExtendedController{

    @IBOutlet var savedCardsTable:UITableView?
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        initializeVariable()
    }
    
    func initializeVariable(){
        
        savedCardsTable?.dataSource = self
        savedCardsTable?.delegate = self
        savedCardsTable?.reloadData()
    }

    @IBAction func ticketsAction(){
        
        //RootControllerManager().setMyTicketsScreenForNavigation()
    }
    
    
    @IBAction func sessionAction(){
        
        //RootControllerManager().selectEventTabWithEventScreen()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}


extension TestController{
    
    class func instance()->TestController?{
        
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Test") as? TestController
        return controller
    }
}


extension TestController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = savedCardsTable?.dequeueReusableCell(withIdentifier: "SavedCardsCell", for: indexPath) as? SavedCardsCell else{
            return UITableViewCell()
        }
        return cell
    }
}

extension TestController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
