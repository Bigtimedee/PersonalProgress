import SwiftUI

struct SettingsView: View {
    @AppStorage("weeklyReminderEnabled") private var weeklyReminderEnabled = false
    @AppStorage("privacyLockEnabled") private var privacyLockEnabled = false

    private let notificationService = NotificationService.shared

    var body: some View {
        NavigationStack {
            List {
                Section("Notifications") {
                    Toggle("Weekly Reflection Reminder", isOn: $weeklyReminderEnabled)
                        .onChange(of: weeklyReminderEnabled) { _, enabled in
                            if enabled {
                                notificationService.scheduleWeeklyReflectionReminder()
                            } else {
                                notificationService.cancelWeeklyReflectionReminder()
                            }
                        }
                }

                Section("Privacy") {
                    Toggle("Require Face ID / Touch ID", isOn: $privacyLockEnabled)
                }

                Section("About") {
                    LabeledContent("Version", value: Bundle.main.releaseVersionNumber ?? "1.0")
                    LabeledContent("Privacy", value: "Data Not Collected")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
}

#Preview {
    SettingsView()
}
