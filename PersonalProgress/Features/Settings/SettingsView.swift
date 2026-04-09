import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("weeklyReminderEnabled") private var weeklyReminderEnabled = false
    @AppStorage("privacyLockEnabled") private var privacyLockEnabled = false
    @Environment(\.modelContext) private var modelContext

    private let notificationService = NotificationService.shared
    @State private var showResetConfirmation = false
    @State private var showExportSheet = false
    @State private var exportText: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                    notificationsSection
                    privacySection
                    dataSection
                    aboutSection
                }
                .padding(.vertical, AppTheme.Spacing.lg)
            }
            .background(Color.surfaceGrouped)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
        .confirmationDialog(
            "Reset Demo Data",
            isPresented: $showResetConfirmation,
            titleVisibility: .visible
        ) {
            Button("Reset", role: .destructive) { resetDemoData() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will delete all data and reload sample content. This cannot be undone.")
        }
        .sheet(isPresented: $showExportSheet) {
            ExportSheet(text: exportText)
        }
    }

    // MARK: - Notifications

    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Notifications")
                .padding(.horizontal, AppTheme.Spacing.xl)

            AppCard {
                HStack {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                        Text("Weekly Reflection Reminder")
                            .font(.bodyMedium)
                        Text("Sundays at 7:00 PM")
                            .font(.captionMedium)
                            .foregroundStyle(.textSecondary)
                    }
                    Spacer()
                    Toggle("", isOn: $weeklyReminderEnabled)
                        .labelsHidden()
                        .onChange(of: weeklyReminderEnabled) { _, enabled in
                            if enabled {
                                notificationService.scheduleWeeklyReflectionReminder()
                            } else {
                                notificationService.cancelWeeklyReflectionReminder()
                            }
                        }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }

    // MARK: - Privacy

    private var privacySection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Privacy")
                .padding(.horizontal, AppTheme.Spacing.xl)

            AppCard {
                HStack {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                        Text("Require Face ID / Touch ID")
                            .font(.bodyMedium)
                        Text("Lock app when backgrounded")
                            .font(.captionMedium)
                            .foregroundStyle(.textSecondary)
                    }
                    Spacer()
                    Toggle("", isOn: $privacyLockEnabled)
                        .labelsHidden()
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }

    // MARK: - Data

    private var dataSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "Data")
                .padding(.horizontal, AppTheme.Spacing.xl)

            AppCard {
                VStack(spacing: 0) {
                    Button {
                        exportText = buildExportText()
                        showExportSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .frame(width: 22)
                                .foregroundStyle(Color.appAccent)
                            Text("Export My Data")
                                .font(.bodyMedium)
                                .foregroundStyle(.textPrimary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.captionSmall)
                                .foregroundStyle(.textTertiary)
                        }
                    }

                    Divider()
                        .padding(.vertical, AppTheme.Spacing.sm)

                    Button(role: .destructive) {
                        showResetConfirmation = true
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                                .frame(width: 22)
                                .foregroundStyle(.red)
                            Text("Reset Demo Data")
                                .font(.bodyMedium)
                                .foregroundStyle(.red)
                            Spacer()
                        }
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }

    // MARK: - About

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            SectionHeader(title: "About")
                .padding(.horizontal, AppTheme.Spacing.xl)

            AppCard {
                VStack(spacing: 0) {
                    HStack {
                        Text("Version")
                            .font(.bodyMedium)
                        Spacer()
                        Text(Bundle.main.releaseVersionNumber ?? "1.0")
                            .font(.bodyMedium)
                            .foregroundStyle(.textSecondary)
                    }

                    Divider()
                        .padding(.vertical, AppTheme.Spacing.sm)

                    HStack {
                        Text("Privacy")
                            .font(.bodyMedium)
                        Spacer()
                        Text("Data Not Collected")
                            .font(.bodyMedium)
                            .foregroundStyle(.textSecondary)
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }

    // MARK: - Actions

    private func buildExportText() -> String {
        "Personal Progress Export\n\(Date.now.formatted(date: .long, time: .shortened))\n\n[Full export coming in a future update.]"
    }

    private func resetDemoData() {
        // Delete all model types via modelContext
        do {
            try modelContext.delete(model: Domain.self)
            try modelContext.delete(model: AnnualLetter.self)
            try modelContext.delete(model: WeeklyReflection.self)
            try modelContext.delete(model: QuarterlyReview.self)
        } catch {
            // Non-critical; data remains if delete fails
        }
    }
}

// MARK: - ExportSheet

private struct ExportSheet: View {
    let text: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                Text(text)
                    .font(.bodySmall)
                    .foregroundStyle(.textPrimary)
                    .padding(AppTheme.Spacing.xl)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color.surfaceGrouped)
            .navigationTitle("Export")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: text) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") { dismiss() }
                }
            }
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
        .modelContainer(PersistenceController.preview.container)
}
