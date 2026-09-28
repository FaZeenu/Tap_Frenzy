import SwiftUI

struct SettingsTabView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "gearshape.fill")
                .font(.system(size: 60))
                .foregroundStyle(.purple)

            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Notification and reset options will appear here.")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsTabView()
    }
}
