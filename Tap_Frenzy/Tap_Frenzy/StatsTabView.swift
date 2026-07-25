import SwiftUI

struct StatsTabView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue)

            Text("Stats")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Your game statistics will appear here.")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Stats")
    }
}

#Preview {
    NavigationStack {
        StatsTabView()
    }
}
