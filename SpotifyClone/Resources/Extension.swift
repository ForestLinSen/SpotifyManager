//
//  Extension.swift
//  SpotifyClone
//
//  Created by Sen Lin on 10/3/2022.
//

import Foundation

extension DateFormatter{
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }()
    
    static let displayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
}

extension String{
    static func formatteDate(string: String) -> String{
        guard let date = DateFormatter.dateFormatter.date(from: string) else { return string }
        return DateFormatter.displayDateFormatter.string(from: date)
    }
}
