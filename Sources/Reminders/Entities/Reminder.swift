//
//  Created by Judy Alvarez on 23.12.2023.
//

import Foundation
import Appl

extension Appl.Dependencies.Reminders {
    public struct Entities {
    }
}

extension Appl.Dependencies.Reminders.Entities {
    public struct Reminder: Equatable, Identifiable {
        public var id: String = UUID().uuidString
        public var title: String
        public var dueDate: Date
        public var notes: String? = nil
        public var isComplete: Bool = false
        public var calendar: String? = nil
        public var weekDay: Int = 0
    }
}
