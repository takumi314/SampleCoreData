//
//  AddTaskViewContbroller.swift
//  SampleCoreData
//
//  Created by NishiokaKohei on 2017/03/16.
//  Copyright © 2017年 Kohey. All rights reserved.
//

import Foundation
import UIKit

class AddTaskViewContbroller: UIViewController {

    @IBOutlet weak var addTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func addTextOnButton(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let task = Task(context: context) // Link Task & Context
        task.name = addTextField.text!

        // Save the data to coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()

        let _ = navigationController?.popViewController(animated: true)
    }

}
