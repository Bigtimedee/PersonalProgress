import Foundation

enum Constants {

    enum App {
        static let name = "Personal Progress"
        static let minimumIOSVersion = "17.0"
    }

    enum Reflection {
        /// Hours after creation before a weekly reflection auto-locks.
        static let lockDelayHours: Double = 48
    }

    enum QuarterlyReview {
        /// Days after completion before a quarterly review auto-locks.
        static let lockDelayDays: Double = 30
    }

    enum Notifications {
        static let weeklyReminderHour = 19   // 7pm Sunday
        static let weeklyReminderMinute = 0
        static let quarterlyReminderDaysBefore = 3
    }

    enum Defaults {
        /// Default domain names shown during onboarding.
        static let suggestedDomains: [(name: String, icon: DomainIcon)] = [
            ("Spouse / Partner", .heart),
            ("Children", .personTwo),
            ("Work", .briefcase),
            ("Health", .leaf),
            ("Mind", .brain),
            ("Faith / Spirit", .star),
            ("Friendships", .person),
            ("Finances", .chart),
        ]
    }
}
