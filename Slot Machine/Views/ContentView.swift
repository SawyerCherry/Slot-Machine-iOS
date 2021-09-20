//
//  ContentView.swift
//  Slot Machine
//
//  Created by Sawyer Cherry on 9/18/21.
//

import SwiftUI

struct ContentView: View {
    //: MARK: -  Properties
    
    let symbols = ["gfx-chung", "gfx-tpose", "gfx-stevemm", "gfx-orang"]
    
    @State private var highscore: Int = 0
    @State private var coins: Int = 100
    @State private var betAmount: Int = 10
    
    @State private var reels: Array = [0, 1, 2]
    
    @State private var showingInfoView: Bool = false
    
    @State private var isActiveBet10: Bool = true
    @State private var isActiveBet20: Bool = false
    
    
    
    //: MARK: -  Functions
    
    // Spin the reels
    
    func spinReels() {
        //        reels[0] = Int.random(in: 0...symbols.count - 1)
        //        reels[1] = Int.random(in: 0...symbols.count - 1)
        //        reels[2] = Int.random(in: 0...symbols.count - 1)
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
    }
    // check the winning
    
    func checkWinning() {
        if reels[0] == reels[1] && reels[1] == reels[2] && reels[0] == reels[2] {
            //player wins
            playerWins()
            //new highscore
            if coins > highscore {
                newHighScore()
            }
        } else {
            //player loses
            playerLoses()
        }
    }
    
    func playerWins() {
        coins += betAmount * 10
    }
    
    func newHighScore() {
        highscore = coins
    }
    
    // game is over
    
    func playerLoses() {
        coins -= betAmount
    }
    
    func activateBet20() {
        betAmount = 20
        isActiveBet20 = true
        isActiveBet10 = false
    }
    
    func activateBet10() {
        betAmount = 10
        isActiveBet10 = true
        isActiveBet20 = false
    }
    
    func reset() {
        coins = 100
        highscore = highscore
        
    }
    
    
    
    
    
    var body: some View {
        ZStack {
            
            //: MARK: -  Background
            LinearGradient(gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            //: MARK: -  Interface
            VStack(alignment: .center, spacing: 5) {
                
                //: MARK: -  header
                LogoView()
                
                Spacer()
                
                //: MARK: -  score
                
                HStack {
                    HStack {
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        
                        
                    }
                    .modifier(ScoreContainerModifier())
                    
                    
                    Spacer()
                    
                    
                    
                    HStack {
                        Text("\(highscore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                        
                        
                        
                    }
                    .modifier(ScoreContainerModifier())
                }
                
                //: MARK: -  slot machine
                
                VStack(alignment: .center, spacing: 0) {
                    //: MARK: -  reel 1
                    ZStack {
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                    }
                    
                    HStack(alignment: .center, spacing: 0) {
                        //: MARK: - reel 2
                        ZStack {
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                        }
                        
                        Spacer()
                        
                        //: MARK: -  reel 3
                        ZStack {
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                        }
                    }
                    
                    .frame(maxWidth: 500)
                    
                    
                    
                    
                    //: MARK: -  spin button
                    
                    Button(action: {
                        self.spinReels()
                        
                        self.checkWinning()
                    }) {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    }
                }
                .layoutPriority(2)
                
                //: MARK: -  footer
                
                Spacer()
                
                HStack {
                    // MARK: Bet 20
                    
                    HStack(alignment: .center, spacing: 10) {
                        Button(action: {
                            self.activateBet20()
                        }) {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet20 ? Color("ColorYellow") : Color.white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                        
                        Image("gfx-dogecoin")
                            .resizable()
                            .opacity(isActiveBet20 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                    }
              
                    
                    //: MARK: -  Bet 10
                    HStack(alignment: .center, spacing: 10) {
                        
                        Image("gfx-dogecoin")
                            .resizable()
                            .opacity(isActiveBet10 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                        
                        Button(action: {
                            self.activateBet10()
                        }) {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet10 ? Color("ColorYellow") : Color.white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                        
                        
                    }
                    
                }
            }
            //: MARK: -  Buttons
            
            .overlay(
                Button(action: {
                    self.reset()
                }) {
                    Image(systemName: "arrow.2.circlepath.circle")
                }
                .modifier(ButtonModifier()),
                alignment: .topLeading
            )
            .overlay(
                Button(action: {
                    self.showingInfoView = true
                }) {
                    Image(systemName: "info.circle")
                }
                .modifier(ButtonModifier()),
                alignment: .topTrailing
            )
            .padding()
            .frame(maxWidth: 720)
            
            //: MARK: -  Popup
        }
        .sheet(isPresented: $showingInfoView) {
            InfoView()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
