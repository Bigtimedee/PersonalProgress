import SwiftUI
import SwiftData

struct DomainSettingsView: View {
    @Bindable var domain: Domain
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var selectedIcon: DomainIcon = .star
    @State private var showArchiveConfirmation = false

    var body: some View {
        NavigationStack {
            List {
                nameSection
                iconSection
                archiveSection
            }
            .navigationTitle("Domain Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                name = domain.name
                selectedIcon = DomainIcon(rawValue: domain.iconName) ?? .star
            }
            .confirmationDialog(
                "Archive \"\(domain.name)\"?",
                isPresented: $showArchiveConfirmation,
                titleVisibility: .visible
            ) {
                Button("Archive Domain", role: .destructive) { archive() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Archived domains are hidden from your home screen. Their history is preserved.")
            }
        }
    }

    // MARK: - Sections

    private var nameSection: some View {
        Section {
            TextField("Domain name", text: $name)
                .font(.bodyMedium)
        } header: {
            Text("Name")
        }
    }

    private var iconSection: some View {
        Section {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: AppTheme.Spacing.sm), count: 5), spacing: AppTheme.Spacing.sm) {
                ForEach(DomainIcon.allCases, id: \.self) { icon in
                    iconCell(icon)
                }
            }
            .padding(.vertical, AppTheme.Spacing.xs)
        } header: {
            Text("Icon")
        }
    }

    private func iconCell(_ icon: DomainIcon) -> some View {
        let isSelected = icon == selectedIcon
        return Button {
            withAnimation(AppTheme.Animation.quick) {
                selectedIcon = icon
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                    .fill(isSelected ? Color.appAccent.opacity(0.15) : Color.surfaceElevated)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                            .strokeBorder(isSelected ? Color.appAccent : Color.clear, lineWidth: 2)
                    )
                Image(systemName: icon.rawValue)
                    .font(.system(size: 22))
                    .foregroundStyle(isSelected ? Color.appAccent : Color.textSecondary)
            }
            .frame(height: 52)
        }
        .buttonStyle(.plain)
    }

    private var archiveSection: some View {
        Section {
            Button(role: .destructive) {
                showArchiveConfirmation = true
            } label: {
                Label("Archive Domain", systemImage: "archivebox")
            }
        } footer: {
            Text("Archived domains are hidden from your home screen. History is preserved.")
        }
    }

    // MARK: - Actions

    private func save() {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        domain.name = trimmed
        domain.iconName = selectedIcon.rawValue
        try? modelContext.save()
        dismiss()
    }

    private func archive() {
        domain.isArchived = true
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    let container = PersistenceController.preview.container
    let context = container.mainContext
    let domains = try? context.fetch(FetchDescriptor<Domain>())
    let domain = domains?.first ?? Domain(name: "Work")
    return DomainSettingsView(domain: domain)
        .modelContainer(container)
}
