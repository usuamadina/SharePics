//
//  ViewController.swift
//  SharePics
//
//  Created by labdisca on 16/6/18.
//  Copyright © 2018 umadina. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var btnLoginRegister: UIButton!
    @IBOutlet weak var btnMode: UIButton!
    var registerMode = true
    
    @IBOutlet weak var lblAccount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // No se puede poner en el viewWillAppear porque no se ejecuta el segue si no está cargada la vista
    override func viewDidAppear(_ animated: Bool)
    {
        if PFUser.current() != nil
        {
            self.performSegue(withIdentifier: "showUsers", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func actionLoginRegister(_ sender: UIButton)
    {
        if (txtEmail.text == "" || txtPass.text == "")
        {
           showAlert(title: "Error en los datos", message: "Usuario y contraseña obligatorios")
        }
        else
        {
            
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if (registerMode == true)
            {
                let user = PFUser()
                user.username = txtEmail.text
                user.password = txtPass.text
                user.email = txtEmail.text
                
                user.signUpInBackground(block:
                    {(success, error) in
                        
                        activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        if let error = error
                        {
                            print(error)
                            self.showAlert(title: "Error en el registro", message: error.localizedDescription)
                        }
                        else
                        {
                            print("User registered successfully!")
                            self.performSegue(withIdentifier: "showUsers", sender: self)
                        }
                        
                })
            }
            else
            {
                PFUser.logInWithUsername(inBackground: txtEmail.text!, password: txtPass.text!, block:
                {(user, error) in
                    
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil
                    {
                        print("Login error :(")
                    }
                    if user != nil
                    {
                        print("User logged successfully!")
                        self.performSegue(withIdentifier: "showUsers", sender: self)
                    }
                    
                })
            }
            
           
           
        }
    }
    
    func showAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action) in self.dismiss(animated: true, completion: nil)}))
        self.present(alert, animated: true, completion: nil)
    }
    
   
    @IBAction func actionaChangeMode(_ sender: UIButton)
    {
        
        if registerMode == true
        {
            registerMode = false
            btnLoginRegister.setTitle("Login", for: UIControlState.normal)
            btnMode.setTitle("Registrarse", for: UIControlState.normal)
            lblAccount.text = "¿Todavía no tienes cuenta?"
        }
        else
        {
            registerMode = true
            btnLoginRegister.setTitle("Registrarse", for: UIControlState.normal)
            btnMode.setTitle("Login", for: UIControlState.normal)
            lblAccount.text = "¿Ya tienes una cuenta?"
        }
    }
    
    
}

