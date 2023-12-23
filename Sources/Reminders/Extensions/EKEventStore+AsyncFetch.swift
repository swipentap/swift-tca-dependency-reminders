//
//  Created by Judy Alvarez on 23.12.2023.
//

import EventKit
import Foundation
import Appl

extension EKEventStore {
    func reminders(matching predicate: NSPredicate) async throws -> [EKReminder] {
        try await withCheckedThrowingContinuation { continuation in
            fetchReminders(matching: predicate) { reminders in
                if let reminders {
                    continuation.resume(returning: reminders)
                } else {
                    continuation.resume(throwing: Appl.Dependencies.Reminders.Errors.TodayError.failedReadingReminders)
                }
            }
        }
    }
}
