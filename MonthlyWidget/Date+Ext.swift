//
//  Date+Ext.swift
//  Monthly
//
//  Created by Thomas Prezioso Jr on 1/2/23.
//

import Foundation

extension Date {
    var weekdayDisplayFormat: String {
        self.formatted(.dateTime.weekday (.wide))
    }
    
    var dayDisplayFormat: String {
        self.formatted (.dateTime.day())
    }
}
