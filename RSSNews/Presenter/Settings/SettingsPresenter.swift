//
//  SettingsPresenter.swift
//  RSSNews
//
//  Created by User on 14/03/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation

protocol SettingsViewPresenter {

    init(view: SettingsView)

    func chosenState(option: Option) -> String

    var sectionsCount: Int { get }

    func sectionByPosition(position: Int) -> SettingsSection

    func optionsCount(inSection section: SettingsSection) -> Int

    func optionInSectionByPosition(sectionPosition: Int, optionPosition: Int) -> Option
}

class SettingsPresenter: SettingsViewPresenter {

    unowned let view: SettingsView

    var sectionsArray: [SettingsSection]!

    var sectionsCount: Int {
        return sectionsArray.count
    }

    required init(view: SettingsView) {
        self.view = view

        initSections()
    }

    func sectionByPosition(position: Int) -> SettingsSection {
        return sectionsArray[position]
    }

    func optionsCount(inSection section: SettingsSection) -> Int {
        return section.section.count
    }

    func optionInSectionByPosition(sectionPosition: Int, optionPosition: Int) -> Option {
        return sectionsArray[sectionPosition].section[optionPosition]
    }

    func chosenState(option: Option) -> String {
        return UserDefaultsRepository.instance.stringProperty(forKey: option.value.lowercased()) ?? "None"
    }

    private func initSections() {
        sectionsArray = SettingsSection.allCases
    }

}
