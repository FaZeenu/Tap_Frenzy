import SwiftUI

struct MapTabView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "map.fill")
                .font(.system(size: 60))
                .foregroundStyle(.green)

            Text("Map")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Completed game locations will appear here.")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Map")
    }
}

#Preview {
    NavigationStack {
        MapTabView()
    }
}
