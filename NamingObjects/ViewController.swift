//
//  ViewController.swift
//  NamingObjects
//
//  Created by Chintan Puri on 10/11/17.
//  Copyright © 2017 Chintan Puri. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    //UI ELEMENTS :
    
    let startButton : UIButton = {
        
        let btn = UIButton()
        btn.setTitle("Start", for: UIControlState())
        btn.setTitleColor(UIColor.black, for: UIControlState())
        btn.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.masksToBounds = true
        return btn
    }()
    
    let imageView : UIImageView = {
        
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
        
    }()
    
    
    //Entry Point :
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(displayP3Red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        self.view.addSubview(self.imageView)
        imageView.image = #imageLiteral(resourceName: "mainImage")
        imageView.contentMode = .scaleAspectFit
        
        imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
    
    
    @objc func startGame() {
        let mainController = MainController()
        let navController = UINavigationController(rootViewController: mainController)
        present(navController, animated: true, completion: nil)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startGame()
    }
}
