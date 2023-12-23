//
//  Created by Judy Alvarez on 23.12.2023.
//

import Foundation
import ComposableArchitecture
import Appl

extension DependencyValues {
    var reminders: Appl.Dependencies.Reminders {
        get { self[Appl.Dependencies.Reminders.self] }
        set { self[Appl.Dependencies.Reminders.self] = newValue }
    }
}
