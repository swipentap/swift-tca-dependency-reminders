//
//  Created by Judy Alvarez on 23.12.2023.
//

import Dependencies
import EventKit
import SwiftUI
import Foundation
import Appl

extension Appl.Dependencies {
    public struct Reminders {
        public var fetchItems: @Sendable () async throws -> [Appl.Dependencies.Reminders.Entities.Reminder]
    }
}

extension Appl.Dependencies.Reminders: DependencyKey {
    
    public static let liveValue: Self = {
        return Self(
            fetchItems: { return try await doFetchItems() }
        )
    }()
    
    static var isAvailable: Bool {
        EKEventStore.authorizationStatus(for: .reminder) == .authorized
    }
    
    @available(iOS 17.0, macOS 14.0, *)
    static func requestAccess17() async throws {
        let ekStore = EKEventStore()
        let status = EKEventStore.authorizationStatus(for: .reminder)
        switch status {
        case .authorized:
            return
        case .restricted:
            throw Appl.Dependencies.Reminders.Errors.TodayError.accessRestricted
        case .notDetermined:
            let accessGranted = try await ekStore.requestFullAccessToReminders()
            guard accessGranted else {
                throw Appl.Dependencies.Reminders.Errors.TodayError.accessDenied
            }
        case .denied:
            throw Appl.Dependencies.Reminders.Errors.TodayError.accessDenied
        /*case .fullAccess:
            throw Appl.Dependencies.Reminders.Errors.TodayError.unknown
        case .writeOnly:
            throw Appl.Dependencies.Reminders.Errors.TodayError.unknown*/
        @unknown default:
            throw Appl.Dependencies.Reminders.Errors.TodayError.unknown
        }
    }

    static func requestAccess() async throws {
        let ekStore = EKEventStore()
        let status = EKEventStore.authorizationStatus(for: .reminder)
        switch status {
        case .authorized:
            return
        case .restricted:
            throw Appl.Dependencies.Reminders.Errors.TodayError.accessRestricted
        case .notDetermined:
            let accessGranted = try await ekStore.requestAccess(to: .reminder)
            guard accessGranted else {
                throw Appl.Dependencies.Reminders.Errors.TodayError.accessDenied
            }
        case .denied:
            throw Appl.Dependencies.Reminders.Errors.TodayError.accessDenied
        /*case .fullAccess:
            throw Appl.Dependencies.Reminders.Errors.TodayError.unknown
        case .writeOnly:
            throw Appl.Dependencies.Reminders.Errors.TodayError.unknown*/
        @unknown default:
            throw Appl.Dependencies.Reminders.Errors.TodayError.unknown
        }
    }

    static func doFetchItems() async throws -> [Appl.Dependencies.Reminders.Entities.Reminder] {
        if !isAvailable {
            if #available(iOS 17.0, macOS 14.0, *) {
                try await requestAccess17()
            } else {
                try await requestAccess()
            }
        }
        
        guard isAvailable else {
            throw Appl.Dependencies.Reminders.Errors.TodayError.accessDenied
        }

        let ekStore = EKEventStore()
        let predicate = ekStore.predicateForReminders(in: nil)
        let ekReminders = try await ekStore.reminders(matching: predicate)
        let reminders: [Appl.Dependencies.Reminders.Entities.Reminder] = ekReminders.compactMap { ekReminder in
            return Appl.Dependencies.Reminders.Entities.Reminder(with: ekReminder)
        }
        return reminders
    }
}

extension Appl.Dependencies.Reminders: TestDependencyKey {
    public static let previewValue = Self.noop
    public static let testValue = Self.noop
}

extension Appl.Dependencies.Reminders {
    public static let noop = Self(
        fetchItems: { return [] }
    )
}
