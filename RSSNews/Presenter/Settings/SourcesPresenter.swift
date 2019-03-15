//
//  SourcesPresenter.swift
//  RSSNews
//
//  Created by User on 14/03/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation

/// A protocol to implement sources presenter functions according to MVP architecture
protocol SourcesViewPresenter {
    
    /// - Parameter view: Sources view to bind
    init(view: SourcesView)

    
    /// Count of sources
    var sourcesCount: Int { get }

    
    /// Gets source item by it's position
    ///
    /// - Parameter position: Position value
    /// - Returns: Source item object
    func sourceByPosition(position: Int) -> SourceItem

    
    /// Checks if typed source item chosen as news source
    ///
    /// - Parameter source: Source item to check
    /// - Returns: True if the item is chosen false otherwise
    func isSourceChosen(source: SourceItem) -> Bool

    
    /// Gets chosen source item position in sources list
    ///
    /// - Returns: Chose source item position
    func chosenSourcePosition() -> Int

    
    /// Calls when new source item has been selected
    ///
    /// - Parameter position: Selected source item position
    func sourceDidSelect(position: Int)
}


/// A class for implementing sources presenter functions
class SourcesPresenter: SourcesViewPresenter {

    private unowned var view: SourcesView
    private var sourceArray: [SourceItem]!
    private var chosenSource: SourceItem!

    var sourcesCount: Int {
        return sourceArray.count
    }

    required init(view: SourcesView) {
        self.view = view

        updatePropertyList()
        findChosenSource()
    }

    func sourceByPosition(position: Int) -> SourceItem {
        return sourceArray[position]
    }

    func isSourceChosen(source: SourceItem) -> Bool {
        return source == chosenSource
    }

    func chosenSourcePosition() -> Int {
        return sourceArray.firstIndex(of: chosenSource) ?? 0
    }

    func sourceDidSelect(position: Int) {

        chosenSource = sourceArray[position]

        UserDefaultsRepository.instance.saveStringProperty(
            forKey: SettingsSection.SourceSection.source.rawValue.lowercased(),
            value: sourceArray[position].sourceName ?? "None")
    }

    
    /// Updates the sources list from sources file
    private func updatePropertyList() {
        if let sources = PropertyFileRepository.instance.sourcesFromPropertyList() {
            sourceArray = sources
        } else {
            view.showErrorMessage(message: "Sources loading error!")
        }
    }
    
    
    /// Updates the chosen source using data from UserDefaults
    private func findChosenSource() {
        let chosenSourceString = UserDefaultsRepository.instance.stringProperty(forKey:
            SettingsSection.SourceSection.source.rawValue.lowercased()) ?? sourceArray[0].sourceName
        chosenSource = sourceArray.first { $0.sourceName == chosenSourceString }
    }
}
