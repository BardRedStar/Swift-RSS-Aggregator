//
//  SettingsItem.swift
//  RSSNews
//
//  Created by User on 13/03/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation


/// An protocol to indentify options from different sections
protocol Option {
    
    /// Gets string option value
    var value: String { get }
}


/// Enum for settings sections
enum SettingsSection: String, CaseIterable {

    /// Source section
    case source = "Source settings"

    /// Source section options list
    static let sourceSection = SourceSection.allCases
    
    /// Gets options list of this section
    var options: [Option] {
        switch self {
        case .source:
            return SettingsSection.sourceSection
        }
    }

    
    /// Source section enum
    ///
    /// - source: Name of the source option
    enum SourceSection: String, CaseIterable, Option {
        
        /// Source option
        case source = "Source"

        /// CaseIterable initializer
        ///
        /// - Parameter index: index of option
        init?(index: Int) {
            switch index {
            case 1: self = .source
            default: return nil
            }
        }

        /// Gets string value - name of the source option
        var value: String {
            return self.rawValue
        }
    }

    
    /// CaseIterable initializer
    ///
    /// - Parameter index: index of section
    init?(index: Int) {
        switch index {
        case 1: self = .source
        default: return nil
        }
    }
}
