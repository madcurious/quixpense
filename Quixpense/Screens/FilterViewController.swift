//
//  FilterViewController.swift
//  Quixpense
//
//  Created by Matt Quiros on 26/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate {
    
    func filterViewController(_ filterViewController: FilterViewController, didSelect filter: Filter)
    
}

class FilterViewController: UIViewController {
    
    enum ViewId: String {
        case cell = "cell"
    }
    
    var selectedDisplayMode: Int
    var selectedPeriod: Int
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    var delegate: FilterViewControllerDelegate?
    
    init(initialSelection: Filter) {
        self.selectedDisplayMode = Filter.DisplayMode.all.index(of: initialSelection.displayMode)!
        self.selectedPeriod = Period.all.index(of: initialSelection.period)!
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
        
        navigationItem.title = "Filter"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleTapOnCancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleTapOnDoneButton))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewId.cell.rawValue)
        
        
    }
    
    class func present(from presenter: UIViewController, initialSelection: Filter, delegate: FilterViewControllerDelegate?) {
        let vc = FilterViewController(initialSelection: initialSelection)
        vc.delegate = delegate
        presenter.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
}

@objc extension FilterViewController {
    
    func handleTapOnCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleTapOnDoneButton() {
        delegate?.filterViewController(self, didSelect: Filter(displayMode: Filter.DisplayMode.all[selectedDisplayMode], period: Period.all[selectedPeriod]))
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource
extension FilterViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Filter.DisplayMode.all.count
        default:
            return Period.all.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewId.cell.rawValue, for: indexPath)
        cell.textLabel?.text = {
            if indexPath.section == 0 {
                return Filter.DisplayMode.all[indexPath.row].title.capitalized
            }
            return Period.all[indexPath.row].title.capitalized
        }()
        cell.accessoryType = {
            switch indexPath.section {
            case 0 where indexPath.row == selectedDisplayMode:
                return .checkmark
            case 1 where indexPath.row == selectedPeriod:
                return .checkmark
            default:
                return .none
            }
        }()
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension FilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case let (section, row) where section == 0 && row != selectedDisplayMode:
            let old = selectedDisplayMode
            selectedDisplayMode = row
            tableView.reloadRows(at: [IndexPath(row: old, section: section), indexPath], with: .automatic)
        case let (section, row) where section == 1 && row != selectedPeriod:
            let old = selectedPeriod
            selectedPeriod = row
            tableView.reloadRows(at: [IndexPath(row: old, section: section), indexPath], with: .automatic)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "DISPLAY"
        default:
            return "TOTALS"
        }
    }
    
}
