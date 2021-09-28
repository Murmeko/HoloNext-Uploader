//
//  LoginViewController.swift
//  HoloNext Uploader
//
//  Created by Yiğit Erdinç on 25.09.2021.
//

import UIKit

class LoginViewController: KUIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    var loginToken: String?
    let NM = NetworkManager()

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if usernameTextField.text?.isEmpty != true && passwordTextField.text?.isEmpty != true {
            if let safeUsername = usernameTextField.text, let safePassword = passwordTextField.text {
                NM.login(username: safeUsername, password: safePassword) { result in
                    self.loginToken = result?.body?.token
                    self.performSegue(withIdentifier: K.loginToUploadModelSegue, sender: self.loginButton)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.usernameTextField:
            self.passwordTextField.becomeFirstResponder()
        default:
            self.passwordTextField.resignFirstResponder()
        }
    }

    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let uploadModelViewController = segue.destination as! UploadModelViewController
        uploadModelViewController.loginToken = self.loginToken
    }
}

//MARK: - KUIViewController
class KUIViewController: UIViewController {

    // KBaseVC is the KEYBOARD variant BaseVC. more on this later

    @IBOutlet var bottomConstraintForKeyboard: NSLayoutConstraint!

    @objc func keyboardWillShow(sender: NSNotification) {
        let i = sender.userInfo!
        let s: TimeInterval = (i[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let k = (i[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        bottomConstraintForKeyboard.constant = k
        // Note. that is the correct, actual value. Some prefer to use:
        // bottomConstraintForKeyboard.constant = k - bottomLayoutGuide.length
        UIView.animate(withDuration: s) { self.view.layoutIfNeeded() }
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        let info = sender.userInfo!
        let s: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        bottomConstraintForKeyboard.constant = 0
        UIView.animate(withDuration: s) { self.view.layoutIfNeeded() }
    }

    @objc func clearKeyboard() {
        view.endEditing(true)
        // (subtle iOS bug/problem in obscure cases: see note below
        // you may prefer to add a short delay here)
    }

    func keyboardNotifications() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1

        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardNotifications()
        let t = UITapGestureRecognizer(target: self, action: #selector(clearKeyboard))
        view.addGestureRecognizer(t)
        t.cancelsTouchesInView = false
    }
}
