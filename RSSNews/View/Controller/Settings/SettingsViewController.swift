//
//  SettingsViewController.swift
//  RSSNews
//
//  Created by User on 13/03/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation
import UIKit
import Reusable

protocol SettingsView: class {

}

class SettingsViewController: UITableViewController {

    private var settingsViewPresenter: SettingsViewPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsViewPresenter = SettingsPresenter(view: self)

        tableView.dataSource = self
    }

}

extension SettingsViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return settingsViewPresenter.sectionsCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsViewPresenter.optionsCount(inSection: settingsViewPresenter.sectionByPosition(position: section))
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath)

        /// I'm sure that section isn't a nil value
        let option = settingsViewPresenter.optionInSectionByPosition(sectionPosition: indexPath.section, optionPosition: indexPath.row)
        cell.textLabel!.text = option.value
        cell.accessoryType = .disclosureIndicator
        cell.detailTextLabel?.text = settingsViewPresenter.chosenState(option: option)
        cell.detailTextLabel?.textColor = UIColor.lightGray

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let section = settingsViewPresenter.sectionByPosition(position: indexPath.section)
        switch section {
        case .source:
            switch SettingsSection.sourceSection[indexPath.row] {
            case .source:
                let sourceSettingsController = SourcesViewController.instantiate()
                sourceSettingsController.sourceDidChangeHandler = {
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                navigationController!.pushViewController(sourceSettingsController, animated: true)
            }
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsViewPresenter.sectionByPosition(position: section).rawValue
    }
}

extension SettingsViewController: SettingsView {
}

extension SettingsViewController: StoryboardBased {
}
