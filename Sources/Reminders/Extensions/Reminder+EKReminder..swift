//
//  Created by Judy Alvarez on 23.12.2023.
//

import EventKit
import Foundation
import Appl

extension Appl.Dependencies.Reminders.Entities.Reminder {
    init(with ekReminder: EKReminder) {
        id = ekReminder.calendarItemIdentifier
        title = ekReminder.title
        notes = ekReminder.notes
        isComplete = ekReminder.isCompleted
        calendar = ekReminder.calendar.title
        
        if let dueDate = ekReminder.alarms?.first?.absoluteDate {
            self.dueDate = dueDate
        } else if let dueDate = ekReminder.dueDateComponents?.date {
            var dateComponent = DateComponents()
            dateComponent.day = 1
            let newDate = Calendar.current.date(byAdding: dateComponent, to: dueDate)
            
            self.dueDate = newDate!
        } else {
            self.dueDate = Date.init(timeIntervalSinceReferenceDate: 0)
        }
        
        weekDay = getWeekDay(self.dueDate)
    }
    
    func getWeekDay(_ now: Date) -> Int {
        
        let cal = Calendar.current
        let comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear, .weekday], from: now)
        let wd = comps.weekday!
        
        return wd
    }
}
