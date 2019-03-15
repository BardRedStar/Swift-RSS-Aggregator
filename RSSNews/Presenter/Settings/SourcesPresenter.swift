//
//  SourcesPresenter.swift
//  RSSNews
//
//  Created by User on 14/03/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation

protocol SourcesViewPresenter {
    init(view: SourcesView)

    var sourcesCount: Int { get }

    func sourceByPosition(position: Int) -> SourceItem

    func isSourceChosen(source: SourceItem) -> Bool

    func chosenSourcePosition() -> Int

    func sourceDidSelect(position: Int)
}

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

    func updatePropertyList() {
        if let sources = PropertyFileRepository.instance.sourcesFromPropertyList() {
            sourceArray = sources
        } else {
            view.showErrorMessage(message: "Sources loading error!")
        }
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

    private func findChosenSource() {
        let chosenSourceString = UserDefaultsRepository.instance.stringProperty(forKey:
            SettingsSection.SourceSection.source.rawValue.lowercased()) ?? sourceArray[0].sourceName
        chosenSource = sourceArray.first { $0.sourceName == chosenSourceString }
    }
}
