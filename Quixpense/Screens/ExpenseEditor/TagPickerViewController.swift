//
//  TagPickerViewController.swift
//  Quixpense
//
//  Created by Matt Quiros on 06/02/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData

class TagPickerViewController: UIViewController {
    
    enum ViewId: String {
        case cell = "cell"
    }
    
    let viewContext: NSManagedObjectContext
    let tableView = UITableView(frame: .zero, style: .grouped)
    var tags = [Tag]()
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K != %@", #keyPath(Tag.name), DefaultClassifier.tag.storedName)
//            tags = try viewContext.fetch(fetchRequest).sorted(by: {
//                switch ($0, $1) {
//                case _ where $0.name == Classifier.tag.default:
//                    return true
//                case _ where $1.name == Classifier.tag.default:
//                    return false
//                default:
//                    if let name0 = $0.name,
//                        let name1 = $1.name {
//                        return name0.compare(name1) == .orderedAscending
//                    }
//                    return false
//                }
//            })
            tags = try viewContext.fetch(fetchRequest).sorted(by: {
                if let name0 = $0.name,
                    let name1 = $1.name {
                    return name0.compare(name1) == .orderedAscending
                }
                return false
            })
            
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewId.cell.rawValue)
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
}

extension TagPickerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewId.cell.rawValue, for: indexPath)
        cell.accessoryType = .checkmark
        cell.textLabel?.text = tags[indexPath.row].name
        return cell
    }
    
}

extension TagPickerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
