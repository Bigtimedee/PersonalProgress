import Foundation
import UserNotifications

/// Manages all local notifications for the app.
/// This app uses local notifications only — no push, no remote server.
final class NotificationService: NSObject {

    nonisolated(unsafe) static let shared = NotificationService()

    private let center = UNUserNotificationCenter.current()

    private override init() {
        super.init()
        center.delegate = self
    }

    // MARK: - Authorization

    func requestAuthorizationIfNeeded() {
        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .notDetermined else { return }
            self.center.requestAuthorization(options: [.alert, .sound]) { _, _ in }
        }
    }

    // MARK: - Weekly reminder

    /// Schedules the Sunday evening weekly reflection reminder.
    func scheduleWeeklyReflectionReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Weekly Reflection"
        content.body = "Take 15 minutes to reflect on this week and plan the next."
        content.sound = .default

        var components = DateComponents()
        components.weekday = 1 // Sunday
        components.hour = Constants.Notifications.weeklyReminderHour
        components.minute = Constants.Notifications.weeklyReminderMinute

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(
            identifier: "weekly-reflection",
            content: content,
            trigger: trigger
        )

        center.add(request)
    }

    func cancelWeeklyReflectionReminder() {
        center.removePendingNotificationRequests(withIdentifiers: ["weekly-reflection"])
    }

    // MARK: - Quarterly reminder

    func scheduleQuarterlyReviewReminder(for quarter: Quarter, year: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Quarterly Review — \(quarter.displayName)"
        content.body = "It's time for your \(quarter.displayName) review. Read your letter."
        content.sound = .default

        var components = DateComponents()
        components.year = year
        components.month = quarter.endMonth
        components.day = 28 // Late in the final month of the quarter
        components.hour = 9
        components.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(
            identifier: "quarterly-review-\(year)-\(quarter.rawValue)",
            content: content,
            trigger: trigger
        )

        center.add(request)
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}
