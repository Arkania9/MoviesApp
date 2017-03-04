//
//  Test.swift
//  MoviesApp
//
//  Created by Kamil Zajac on 22.02.2017.
//  Copyright © 2017 Kamil Zajac. All rights reserved.
//

import UIKit
import Alamofire

class AuthenticationVC: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var menuBar: UIButton!
    
    var requestToken: String?
    var sessionId: String?
    var userId: Int?
    var userName: String?
    var success: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBar.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for:UIControlEvents.touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func getRequestToken(completed: @escaping DownloadCompleted) {
        let requestURL = URL(string: requestString)
        Alamofire.request(requestURL!).responseJSON { (response) in
            let result = response.result
            if let jsonData = result.value as? Dictionary<String, AnyObject> {
                if let token = jsonData["request_token"] as? String {
                    self.requestToken = token
                }
            }
            completed()
        }
    }
    
    func loginWithToken(requestToken: String, completed: @escaping DownloadCompleted) {
        if let userName = loginTextField.text {
            if let password = pwdTextField.text {
                let urlString = "\(validateRequestP1)\(userName)\(validateRequestP2)\(password)\(validateRequestP3)\(requestToken)"
                let mainURL = URL(string: urlString)
                Alamofire.request(mainURL!).responseJSON(completionHandler: { (response) in
                    let result = response.result
                    if let jsonData = result.value as? Dictionary<String, AnyObject> {
                        if let success = jsonData["success"] as? Bool {
                            self.success = success
                        }
                    }
                    completed()
                })
            }
        }
    }
    
    func getSessionID(requestToken: String,completed: @escaping DownloadCompleted) {
        let sessionLink = "\(sessionString)\(requestToken)"
        let sessionURL = URL(string: sessionLink)
        Alamofire.request(sessionURL!).responseJSON { (response) in
            let result = response.result
            if let jsonData = result.value as? Dictionary<String, AnyObject> {
                if let id = jsonData["session_id"] as? String {
                    self.sessionId = id
                }
            }
            completed()
        }
    }
    
    func getUserDetails(sessionId: String, completed: @escaping DownloadCompleted) {
        let accountLink = "\(accountDetails)\(sessionId)"
        let accountURL = URL(string: accountLink)
        Alamofire.request(accountURL!).responseJSON { (response) in
            let result = response.result
            if let jsonData = result.value as? Dictionary<String, AnyObject> {
                if let accountId = jsonData["id"] as? Int {
                    self.userId = accountId
                }
                if let username = jsonData["username"] as? String {
                    self.userName = username
                }
            }
            completed()
        }
    }
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        getRequestToken {
            self.loginWithToken(requestToken: self.requestToken!, completed: { 
                if self.success == true {
                    self.getSessionID(requestToken: self.requestToken!, completed: {
                        UserDefaults.standard.set(self.sessionId, forKey: "SessionId")
                        self.getUserDetails(sessionId: self.sessionId!, completed: {
                            UserDefaults.standard.set(self.userId, forKey: "UserId")
                        })
                    })
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! SWRevealViewController!
                    self.present(next!, animated: true, completion: nil)
                    Shared.shared.isLogged = true
                } else {
                    self.errorLbl.alpha = 1.0
                }
            })

        }
    }
}
