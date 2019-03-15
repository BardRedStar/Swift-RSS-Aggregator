//
//  SettingsPresenter.swift
//  RSSNews
//
//  Created by User on 14/03/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation


/// A protocol to implement settings presenter functions according to MVP architecture
protocol SettingsViewPresenter {

    /// Count of sections
    var sectionsCount: Int { get }
    
    
    /// - Parameter view: Settings view to bind
    init(view: SettingsView)

    
    /// Gets chosen state of settings option
    ///
    /// - Parameter option: Option to get state
    /// - Returns: State of option in UserDefaults
    func chosenState(option: Option) -> String

    
    /// Get section by it's position
    ///
    /// - Parameter position: Position value
    /// - Returns: Section object
    func sectionByPosition(position: Int) -> SettingsSection

    
    /// Gets count of object in section
    ///
    /// - Parameter section: Section object to count options
    /// - Returns: Options count
    func optionsCount(inSection section: SettingsSection) -> Int

    
    /// Gets option by it's position in section by section position
    ///
    /// - Parameters:
    ///   - sectionPosition: Section position
    ///   - optionPosition: Ooption position in section
    /// - Returns: Option object
    func optionInSectionByPosition(sectionPosition: Int, optionPosition: Int) -> Option
}

/// A class for implementing settings presenter functions
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
        return section.options.count
    }

    func optionInSectionByPosition(sectionPosition: Int, optionPosition: Int) -> Option {
        return sectionsArray[sectionPosition].options[optionPosition]
    }

    func chosenState(option: Option) -> String {
        return UserDefaultsRepository.instance.stringProperty(forKey: option.value.lowercased()) ?? "None"
    }

    
    /// Initializes sections array
    private func initSections() {
        sectionsArray = SettingsSection.allCases
    }

}
