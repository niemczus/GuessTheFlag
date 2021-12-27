//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Kamil on 01/12/2021.
//

import SwiftUI

extension Image {
    func flagImage() -> some View {
        self
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var showingEnd = false
    @State private var scoreTitle = ""
    @State private var endTitle = "The End of a Game!"
    @State private var score = 0
    @State private var questionCounter = 0
    
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 30) {
                    VStack  {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundStyle(.secondary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .flagImage()
                        }
                    }
                }
                
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .font(.title.bold())
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            
        }
        
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert(endTitle, isPresented: $showingEnd) {
            Button("Try again", action: reset)
        } message: {
            Text("You answered \(score) / 8 correctly")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        if questionCounter < 7 {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
            questionCounter += 1
        } else {
            showingEnd = true
        }
    }
    
    func reset() {
        questionCounter = 0
        score = 0
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
