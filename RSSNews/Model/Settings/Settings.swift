//
//  SettingsItem.swift
//  RSSNews
//
//  Created by User on 13/03/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation

protocol Option {
    var value: String { get }
}

enum SettingsSection: String, CaseIterable {

    case source = "Source settings"

    static let sourceSection = SourceSection.allCases

    var section: [Option] {
        switch self {
        case .source:
            return SettingsSection.sourceSection
        }
    }

    enum SourceSection: String, CaseIterable, Option {
        case source = "Source"

        init?(id: Int) {
            switch id {
            case 1: self = .source
            default: return nil
            }
        }

        var value: String {
            return self.rawValue
        }
    }

    init?(id: Int) {
        switch id {
        case 1: self = .source
        default: return nil
        }
    }
}
