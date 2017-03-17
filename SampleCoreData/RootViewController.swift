//
//  RootViewController.swift
//  SampleCoreData
//
//  Created by NishiokaKohei on 2017/03/16.
//  Copyright © 2017年 Kohey. All rights reserved.
//

import UIKit
import CoreData

class RootViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasks: [Task] = []
    var names: [String] = []

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "The List"

        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
    }

    private func getData() {
        do {
            tasks = try context.fetch(Task.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
    }

    // MARK: - IBActions

    // Implement the saveTask IBAction （未実装）
    private func saveData(name: String) {
        guard
            let managedContext = (UIApplication.shared.delegate as? AppDelegate)?
                .persistentContainer.viewContext,
            let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext),
            let task = NSManagedObject(entity: entity, insertInto: managedContext) as? Task else {
            return
        }

        task.setValue(name, forKeyPath: "name")
        do {
            try managedContext.save()
            tasks.append(task)
        } catch let error as? Error {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    // Implement the addName IBAction （未実装）
    private func addName(_ sender: AnyObject) {
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        let saveAction
            = UIAlertAction(title: "Save",
                            style: .default) {
                                [unowned self] action in
                                guard let textField = alert.textFields?.first,
                                    let nameToSave = textField.text else {
                                        return
                                    }
                                self.names.append(nameToSave)
                                self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }

}

// MARK: - UITableViewDataSource

extension RootViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath)
        let task = tasks[indexPath.row]
        if let name = task.name {
            cell.textLabel?.text = name
        }
        return cell
    }

}

// MARK: - UITableViewDataSource

extension RootViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTask(forRowAt: indexPath)
        }
        tableView.reloadData()
    }

    private func deleteTask(forRowAt indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let task = tasks[indexPath.row]
        context.delete(task)
        appDelegate.saveContext()

        do {
            tasks = try context.fetch(Task.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
    }

}
