import SwiftUI

struct LightItUpView: View {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 30) {

                Text("Light It Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text("Score: 0")
                    .font(.title2)
                    .foregroundStyle(.white)

                Text("Time: 30")
                    .font(.title2)
                    .foregroundStyle(.white)
                
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(0..<9, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray)
                            .frame(height: 100)
                    }
                }
                .padding()

                Spacer()
                
            }
            .padding(.top, 50)
        }
    }
}

#Preview {
    LightItUpView()
}
