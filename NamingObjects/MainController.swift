//
//  MainController.swift
//  NamingObjects
//
//  Created by Chintan Puri on 10/11/17.
//  Copyright © 2017 Chintan Puri. All rights reserved.
//

import UIKit
import CoreML
import Vision

class MainController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //CoreML Model :
    let model = Resnet50()
    
    //UI Elements :
    
    var answerTextField: UITextField = {
       
        let textField = UITextField()
        textField.placeholder = "enter your answer here..."
        textField.backgroundColor = UIColor.white
        textField.tintColor = UIColor.black
        textField.autocorrectionType = .no
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.masksToBounds = true
        return textField
        
        
    }()
    
    var firstLetterLabel : UILabel = {
        let label = UILabel()
        label.text = "First Letter :      "
        label.textColor = UIColor.black
        let fontSize = label.font.pointSize
        label.font = UIFont(name: "Futura", size: fontSize)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        
        return label
    }()
    
    var lastLetterLabel : UILabel = {
        let label = UILabel()
        label.text = "Last Letter :      "
        label.textColor = UIColor.darkGray
        let fontSize = label.font.pointSize
        label.font = UIFont(name: "Futura", size: fontSize)
    
    
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        
        return label
    }()
    
    var resultsLabel: UILabel! = {
       let label = UILabel()
       label.text = ""
       label.translatesAutoresizingMaskIntoConstraints = false
       label.layer.masksToBounds = true
       label.adjustsFontSizeToFitWidth = true
       label.textAlignment = .center
       let fontSize = label.font.pointSize
       label.font = UIFont.boldSystemFont(ofSize: fontSize )
       label.isHidden = true
        return label
    }()
    
    var correctLabel: UILabel! = {
        let label = UILabel()
        label.text = "Incorrect"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        let fontSize = label.font.pointSize
        label.font = UIFont.boldSystemFont(ofSize: fontSize )
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    let imageView : UIImageView = {
        
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        
        imgView.translatesAutoresizingMaskIntoConstraints  = false
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    
    let checkAnswerButton : UIButton = {
        
        let btn = UIButton()
        btn.setTitle("Submit Answer", for: UIControlState())
        btn.setTitleColor(UIColor.white, for: UIControlState())
        btn.backgroundColor = UIColor(displayP3Red: 66/255, green: 194/255, blue: 244/255, alpha: 1)
        let fontSize = btn.titleLabel?.font.pointSize
        btn.titleLabel?.font = UIFont(name: "Futura", size: fontSize!)
        btn.layer.cornerRadius = 8
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.addTarget(self, action: #selector(checkAnswer), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.masksToBounds = true
        return btn
        
        
    }()
    
    let viewAnswerButton : UIButton = {
        
        let btn = UIButton()
        btn.setTitle("Reveal Answer", for: UIControlState())
        let fontSize = btn.titleLabel?.font.pointSize
        btn.titleLabel?.font = UIFont(name: "Futura", size: fontSize!)
        btn.setTitleColor(UIColor.white, for: UIControlState())
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.backgroundColor = UIColor(displayP3Red: 66/255, green: 244/255, blue: 223/255, alpha: 1)
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(viewAnswer), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.masksToBounds = true
        return btn
        
    }()
    
    //image picker :
    
    var picker = UIImagePickerController()
    

    //Entry Point :
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        picker.delegate = self
        
        
        setupElements()
        navigationItem.title = "Whats in the Picture ?"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera") , style: .plain, target: self, action: #selector(openCamera))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.darkGray
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "library"), style: .plain, target: self, action: #selector(openPhotoLibrary))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.darkGray
        
        
    }
    
    func setupElements() {
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.answerTextField)
        self.view.addSubview(self.firstLetterLabel)
        self.view.addSubview(self.lastLetterLabel)
        self.view.addSubview(self.resultsLabel)
        self.view.addSubview(self.correctLabel)
        self.view.addSubview(self.checkAnswerButton)
        self.view.addSubview(self.viewAnswerButton)
        
        imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        // If iPhone SE or 5S
        if (UIScreen.main.nativeBounds.height == 1136) {
        imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4).isActive = true
        }else {
             imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
        }
        
        
        
        answerTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        answerTextField.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant : 20).isActive = true
        answerTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/2).isActive = true
        
        firstLetterLabel.topAnchor.constraint(equalTo: self.answerTextField.bottomAnchor, constant: 20).isActive = true
        firstLetterLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        firstLetterLabel.widthAnchor.constraint(equalTo: self.answerTextField.widthAnchor).isActive = true
        firstLetterLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        lastLetterLabel.topAnchor.constraint(equalTo: self.firstLetterLabel.bottomAnchor, constant: 20).isActive = true
        lastLetterLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        lastLetterLabel.widthAnchor.constraint(equalTo: self.answerTextField.widthAnchor).isActive = true
        lastLetterLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        resultsLabel.topAnchor.constraint(equalTo: self.lastLetterLabel.bottomAnchor, constant: 20).isActive = true
        resultsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        resultsLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier : 0.75).isActive = true
        resultsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        correctLabel.topAnchor.constraint(equalTo: self.resultsLabel.bottomAnchor, constant: 20).isActive = true
        correctLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        correctLabel.widthAnchor.constraint(equalTo: self.answerTextField.widthAnchor, multiplier : 0.75).isActive = true
        correctLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    
        
        checkAnswerButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        checkAnswerButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        checkAnswerButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3).isActive = true
        checkAnswerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        viewAnswerButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        viewAnswerButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        viewAnswerButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/3).isActive = true
        viewAnswerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }
    
    
    @objc func openCamera() {
        print("OPEN CAMERA")
        picker.sourceType = .camera
        picker.allowsEditing = true
        
        self.present(picker, animated: true, completion: nil)
    }
    
    
    @objc func openPhotoLibrary() {
        print("OPEN Library")
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func checkAnswer() {
        
        if (self.resultsLabel.text?.isEmpty)! {
            return
        }
        
        if (self.answerTextField.text!.lowercased() == self.resultsLabel.text!.lowercased()) {
            self.resultsLabel.isHidden = false
            self.correctLabel.backgroundColor = UIColor(displayP3Red: 155/255, green: 244/255, blue: 66/255, alpha: 1)
            self.correctLabel.text = "Correct"
            self.answerTextField.isUserInteractionEnabled = false
        
        
        } else {
            self.correctLabel.backgroundColor = UIColor(displayP3Red: 244/255, green: 66/255, blue: 116/255, alpha: 1)
            self.correctLabel.text = "Incorrect"
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                
                self.answerTextField.text = nil
                self.correctLabel.isHidden = true
            })
        }
        
        self.correctLabel.isHidden = false
       
    }
    
    
    
    @objc func viewAnswer() {
        
        self.resultsLabel.isHidden = false
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            print("IMAGE SELECTED")
            self.imageView.image = image
            
        }
        
        guard let image = imageView.image, let ciImage = CIImage(image: image) else {return}
        
        detect(image: ciImage)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func detect(image: CIImage) {
        resultsLabel.text = "Detecting Object..."
        guard let model = try? VNCoreMLModel(for: model.model) else {fatalError()}
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first else {fatalError()}
            
            DispatchQueue.main.async {
                self.answerTextField.isUserInteractionEnabled = true
                self.answerTextField.text = nil
                self.resultsLabel.isHidden = true
                self.correctLabel.isHidden = true
                
                
                self.resultsLabel.text = "\(topResult.identifier.uppercased())"
                

                
                let resultsToken = self.resultsLabel.text?.components(separatedBy: ",")
                print(resultsToken![0])
                self.resultsLabel.text = resultsToken?[0]
                
                
                let firstCharacter = self.resultsLabel.text?.characters.first!
                let lastCharacter = self.resultsLabel.text?.characters.last!
                
                
                
                if (self.firstLetterLabel.text?.characters.count == 20 && self.lastLetterLabel.text?.characters.count == 19) {
            
                
                    self.firstLetterLabel.text?.append(firstCharacter!)
                    self.lastLetterLabel.text?.append(lastCharacter!)
            
                } else {
                
                  
                    
                    self.firstLetterLabel.text! = String(describing: self.firstLetterLabel.text!.dropLast())
                    
                    self.lastLetterLabel.text! = String(describing: self.lastLetterLabel.text!.dropLast())
                    
                    
                    self.firstLetterLabel.text?.append(firstCharacter!)
                    self.lastLetterLabel.text?.append(lastCharacter!)
                    
                    
                }
                
                
                
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            }catch {
                print(error)
            }
        }
    }
}
