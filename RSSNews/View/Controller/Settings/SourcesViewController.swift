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

protocol SourcesView: class {

    /// Shows the error message in Toast
    ///
    /// - Parameter message: Message to show
    func showErrorMessage(message: String)
}

class SourcesViewController: UITableViewController, SourcesView {

    private var sourcesViewPresenter: SourcesViewPresenter!
    private var sourceArray: [SourceItem] = []

    var sourceDidChangeHandler: (() -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()

        sourcesViewPresenter = SourcesPresenter(view: self)
        navigationItem.title = SettingsSection.SourceSection.source.rawValue
    }

    func showErrorMessage(message: String) {
        Toast.show(view: self.view, message: message, duration: Constants.toastDuration)
    }
}

extension SourcesViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourcesViewPresenter.sourcesCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath)

        let source = sourcesViewPresenter.sourceByPosition(position: indexPath.row)

        cell.textLabel!.text = source.sourceName
        cell.accessoryType = sourcesViewPresenter.isSourceChosen(source: source) ? .checkmark : .none

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedPosition = sourcesViewPresenter.chosenSourcePosition()
        sourcesViewPresenter.sourceDidSelect(position: indexPath.row)
        sourceDidChangeHandler()
        tableView.reloadRows(at: [indexPath, IndexPath(row: selectedPosition, section: 0)], with: .automatic)

    }
}

extension SourcesViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
}
