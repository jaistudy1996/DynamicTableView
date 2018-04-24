//
//  ViewController.swift
//  DynamicTable
//
//  Created by Jayant Arora on 4/24/18.
//  Copyright © 2018 Jayant Arora. All rights reserved.
//

import UIKit

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
}

