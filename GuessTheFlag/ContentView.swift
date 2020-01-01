

import SwiftUI

struct ContentView: View {
    @State private var countries = "Estonia France Germany Ireland Italy Nigeria Poland Russia Spain UK US".components(separatedBy: " ").shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var radiansPerFlag: [Double] = [
        0.0,
        0.0,
        0.0,
    ]
    @State private var opacitiesPerFlag: [Double] = [
        1.0,
        1.0,
        1.0,
    ]

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)

                }
                ForEach(0..<3) { index in
                    Button(action: {
                        self.flagTapped(index)
                        withAnimation(Animation.easeInOut(duration: 0.4)) {
                            if index != self.correctAnswer{
                                
                            } else {
                                self.radiansPerFlag[index] += 2 * .pi
                                for wrong in 0..<3 {
                                    if wrong != index {
                                        self.opacitiesPerFlag[wrong] = 0.2
                                    }
                                }
                            }
                        }
                    }) {
                        Image(self.countries[index])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black, lineWidth: CGFloat(1)))
                            .shadow(color: .black, radius: CGFloat(2))
                        .opacity(self.opacitiesPerFlag[index])
                    }
                    .rotation3DEffect(
                        .radians(self.radiansPerFlag[index]),
                        axis: (x: 0, y: 1, z: 0)
                    )
                }
                Spacer()
                Text("Your score is \(score)")
                    .foregroundColor(.white)
                Spacer()
            }
        }
        
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("\(scoreTitle == "Wrong" ? "Wrong! That’s the flag of \(countries[self.correctAnswer])" : "")Your score is \(self.score)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
                self.opacitiesPerFlag = [
                                           1.0,
                                           1.0,
                                           1.0,
                                       ]
            })
        }
//        .frame(width: .infinity, height: .infinity, alignment: .center)
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong"
        }

        showingScore = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 8 Plus"))
        .previewDisplayName("iPhone 8 Plus")
    }
}
