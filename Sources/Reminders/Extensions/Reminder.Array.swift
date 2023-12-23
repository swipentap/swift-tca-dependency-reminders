//
//  Created by Judy Alvarez on 23.12.2023.
//

import Foundation
import Appl

extension [Appl.Dependencies.Reminders.Entities.Reminder] {
    func indexOfReminder(withId id: Appl.Dependencies.Reminders.Entities.Reminder.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}
