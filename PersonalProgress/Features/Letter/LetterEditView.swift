import SwiftUI
import SwiftData

struct LetterEditView: View {
    @Bindable var letter: AnnualLetter
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var yearWord: String = ""
    @State private var themeStatement: String = ""
    @State private var rawText: String = ""
    @State private var showSealConfirmation = false

    var body: some View {
        NavigationStack {
            List {
                metadataSection
                bodySection
                if !letter.isSealed {
                    sealSection
                }
            }
            .navigationTitle("Edit Letter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                title = letter.title
                yearWord = letter.yearWord ?? ""
                themeStatement = letter.themeStatement ?? ""
                rawText = letter.rawText
            }
            .confirmationDialog(
                "Seal \"\(letter.displayTitle)\"?",
                isPresented: $showSealConfirmation,
                titleVisibility: .visible
            ) {
                Button("Seal Letter", role: .destructive) { seal() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("A sealed letter becomes read-only. This cannot be undone.")
            }
        }
    }

    // MARK: - Sections

    private var metadataSection: some View {
        Section {
            TextField("Title", text: $title)
                .font(.bodyMedium)
            TextField("Year word (e.g. Presence)", text: $yearWord)
                .font(.bodyMedium)
            TextField("Theme statement", text: $themeStatement, axis: .vertical)
                .font(.bodyMedium)
                .lineLimit(3...6)
        } header: {
            Text("Header")
        }
    }

    private var bodySection: some View {
        Section {
            TextField("Write your letter…", text: $rawText, axis: .vertical)
                .font(.letterBody)
                .lineLimit(10...)
        } header: {
            Text("Letter")
        }
    }

    private var sealSection: some View {
        Section {
            Button(role: .destructive) {
                showSealConfirmation = true
            } label: {
                Label("Seal Letter", systemImage: "lock")
            }
        } footer: {
            Text("Sealing makes this letter permanently read-only — a time capsule for the year.")
        }
    }

    // MARK: - Actions

    private func save() {
        letter.title = title.trimmingCharacters(in: .whitespaces)
        letter.yearWord = yearWord.trimmingCharacters(in: .whitespaces).nilIfEmpty
        letter.themeStatement = themeStatement.trimmingCharacters(in: .whitespaces).nilIfEmpty
        try? LetterService().updateLetterText(letter, rawText: rawText, in: modelContext)
        try? modelContext.save()
        dismiss()
    }

    private func seal() {
        save()
        try? LetterService().sealLetter(letter, in: modelContext)
        dismiss()
    }
}

private extension String {
    var nilIfEmpty: String? { isEmpty ? nil : self }
}

#Preview {
    let container = PersistenceController.preview.container
    let context = container.mainContext
    let letters = try? context.fetch(FetchDescriptor<AnnualLetter>())
    let letter = letters?.first ?? AnnualLetter(year: 2026, title: "My 2026 Letter")
    return LetterEditView(letter: letter)
        .modelContainer(container)
}
