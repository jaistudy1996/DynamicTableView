//
//  ViewController.swift
//  DynamicTable
//
//  Created by Jayant Arora on 4/24/18.
//  Copyright © 2018 Jayant Arora. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var newContent: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    // MARK: Data Source
    var tableData = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 11.0, *) {
            tableView.dragDelegate = self
//            tableView.dropDelegate = self
            tableView.dragInteractionEnabled = true
        } else {
            // Fallback on earlier versions
        }
        requestAuthForNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addDataToTable(_ sender: UIButton) {
        guard newContent.text != nil else { return }
        tableData.append(newContent.text!)
        newContent.text = ""

        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: tableData.count - 1, section: 0)], with: .top)
        tableView.endUpdates()
    }

}

// MARK: Delegate and Data Source
extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableData.count == 0 {
            // Show a message when there is no data in the table
            let messageLabel = UILabel(frame: CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: 20))
            messageLabel.text = "Add some data to this table."
            messageLabel.textAlignment = .center
            messageLabel.textColor = UIColor.lightGray
            messageLabel.sizeToFit()
            tableView.backgroundView  = messageLabel
            tableView.separatorStyle = .none
            return 0
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            return tableData.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.cellLabel.text = tableData[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section: \(section)"
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        tableData.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}

// MARK: Notification Handling
extension ViewController {
    func requestAuthForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
            guard granted else { return }
            self.getCurrentNotificationSettings()
        })
    }

    func getCurrentNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}

extension ViewController: UITableViewDragDelegate {
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = tableData[indexPath.row]
        return [dragItem]
    }
}

extension ViewController: UITableViewDropDelegate {
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {

        guard session.localDragSession != nil,
            (destinationIndexPath?.row)! < tableData.count,
            tableView.hasActiveDrag
        else {
            return UITableViewDropProposal(operation: .forbidden)
        }
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) { }
}

