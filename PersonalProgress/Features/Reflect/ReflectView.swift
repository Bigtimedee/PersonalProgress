import SwiftUI
import SwiftData

struct ReflectView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var currentReflection: WeeklyReflection?

    private let reflectionService = ReflectionService()

    var body: some View {
        NavigationStack {
            Group {
                if let reflection = currentReflection {
                    WeeklyReflectionForm(reflection: reflection)
                } else {
                    ProgressView("Loading...")
                }
            }
            .navigationTitle("Reflect")
            .navigationBarTitleDisplayMode(.large)
        }
        .task {
            await loadCurrentReflection()
        }
    }

    private func loadCurrentReflection() async {
        do {
            currentReflection = try reflectionService.currentWeekReflection(in: modelContext)
        } catch {
            // TODO: handle error in Phase 6
        }
    }
}

// MARK: - WeeklyReflectionForm

struct WeeklyReflectionForm: View {
    @Bindable var reflection: WeeklyReflection

    var body: some View {
        List {
            Section {
                Text(reflection.weekStartDate.weekLabel)
                    .font(.headingSmall)
                    .foregroundStyle(.textSecondary)
            }

            Section("How did the week go?") {
                TextEditor(text: Binding(
                    get: { reflection.weekReflectionText ?? "" },
                    set: { reflection.weekReflectionText = $0.isEmpty ? nil : $0 }
                ))
                .frame(minHeight: 100)
                .disabled(reflection.isLocked)
            }

            Section("Highlight") {
                TextField(
                    "The most important thing this week was…",
                    text: Binding(
                        get: { reflection.weekHighlight ?? "" },
                        set: { reflection.weekHighlight = $0.isEmpty ? nil : $0 }
                    ),
                    axis: .vertical
                )
                .disabled(reflection.isLocked)
            }

            Section("Top Priorities for Next Week") {
                ForEach(reflection.weeklyPriorities.indices, id: \.self) { index in
                    TextField("Priority \(index + 1)", text: Binding(
                        get: { reflection.weeklyPriorities[index] },
                        set: { reflection.weeklyPriorities[index] = $0 }
                    ))
                    .disabled(reflection.isLocked)
                }
                if !reflection.isLocked && reflection.weeklyPriorities.count < 3 {
                    Button("Add Priority") {
                        reflection.weeklyPriorities.append("")
                    }
                }
            }

            if reflection.isLocked {
                Section {
                    Label("This reflection is locked.", systemImage: "lock.fill")
                        .font(.captionMedium)
                        .foregroundStyle(.textTertiary)
                }
            }
        }
    }
}

#Preview {
    ReflectView()
        .modelContainer(PersistenceController.preview.container)
}
