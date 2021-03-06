//
//  StandardDateFormatter.swift
//  CD
//
//  Created by Vladislav Simovic on 1/3/17.
//  Copyright © 2017 CustomDeal. All rights reserved.
//

fileprivate let serverDateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"

class StandardDateFormatter {
    
    static func dateFrom(dateString: String) -> NSDate? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = serverDateFormat
        return dateFormatter.date(from: dateString) as NSDate?
    }
    
    static func stringFrom(date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = serverDateFormat
        return dateFormatter.string(from: date as Date)
    }
    
    static func presentationStringFrom(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return dateFormatter.string(from: date)
    }
    
    static func stripTimeFrom(date: Date) -> Date {
        let newDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return Calendar.current.date(from: newDateComponents)!
    }
    
    static func formatDate(fromDate: Date, toDate: Date) -> String {
        return "from" + self.presentationStringFrom(date: fromDate) + " until " + self.presentationStringFrom(date: toDate)
    }
}
