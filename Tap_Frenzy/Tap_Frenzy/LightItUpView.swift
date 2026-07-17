import SwiftUI

struct LightItUpView: View {
    @State private var activeCard = 0
    
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
                    ForEach(0..<9, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(
                                index == activeCard
                                ? Color.yellow
                                : Color.gray
                            )
                        
                        
                            .frame(height: 100)
                    }
                }
                .padding()
                
                Button("Change Light") {
                    activeCard = Int.random(in: 0..<9)
                }
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.black)
                .padding()
                .background(Color.yellow)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Spacer()
                
            }
            .padding(.top, 50)
        }
    }
}

#Preview {
    LightItUpView()
}
