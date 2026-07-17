import SwiftUI

struct LightItUpView: View {
    @State private var activeCard = 0
    @State private var score = 0
    
    
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
                
                Text("Score: \(score)")
                    .font(.title2)
                    .foregroundStyle(.white)
                
                Text("Time: 30")
                    .font(.title2)
                    .foregroundStyle(.white)
                
                LazyVGrid(columns: columns, spacing: 15) {
                    
                    ForEach(0..<9, id: \.self) { index in
                        
                        Button {
                            handleCardTap(index)
                        } label: {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(
                                    index == activeCard
                                    ? Color.yellow
                                    : Color.gray
                                )
                                .frame(height: 100)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            
                Spacer()
                
            }
            .padding(.top, 50)
        }
    }
        private func handleCardTap(_ index: Int) {
            if index == activeCard {
                score += 1
                activeCard = Int.random(in: 0..<9)
            }
        }
        
    }


#Preview {
    LightItUpView()
}
