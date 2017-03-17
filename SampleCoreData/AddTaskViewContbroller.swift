//
//  AddTaskViewContbroller.swift
//  SampleCoreData
//
//  Created by NishiokaKohei on 2017/03/16.
//  Copyright © 2017年 Kohey. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddTaskViewContbroller: UIViewController {

    @IBOutlet weak var addTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBActions

    @IBAction func addTextOnButton(_ sender: UIButton) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = delegate.persistentContainer.viewContext
        let task = Task(context: context) // Link Task & Context
        task.name = addTextField.text!

        // Save the data to coredata
        delegate.saveContext()

        dismiss(animated: true, completion: nil)
    }

    @IBAction func toBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    // MAEK: - Privete methods


}

// MARK: - UITextFieldDelegate

extension AddTaskViewContbroller: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        super.becomeFirstResponder()
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // キーボードが開いていればclose
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        return true
    }

}
