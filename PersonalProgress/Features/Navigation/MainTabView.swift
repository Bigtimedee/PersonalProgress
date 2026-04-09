import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            ReflectView()
                .tabItem {
                    Label("Reflect", systemImage: "sparkles")
                }

            LetterView()
                .tabItem {
                    Label("Letter", systemImage: "envelope.fill")
                }

            ReviewsView()
                .tabItem {
                    Label("Reviews", systemImage: "calendar.badge.checkmark")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
        .modelContainer(PersistenceController.preview.container)
}
