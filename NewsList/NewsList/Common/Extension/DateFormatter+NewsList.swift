//
//  DateFormatter+NewsList.swift
//  NewsList
//
//  Created by Alex Ivashko on 24.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import Foundation

extension DateFormatter {
    static var defaultFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM yyyy H:mm:ss Z"
        return dateFormatter
    }()
}
