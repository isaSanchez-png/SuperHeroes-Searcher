//
//  SuperHeroDetail.swift
//  SuperHeroes-Searcher
//
//  Created by Isa on 10/06/26.
//

import SwiftUI
import Charts

struct SuperHeroDetail: View {
    let id: String
    @State var superHero: ApiNetwork.SuperHeroComplete? = nil
    @State var loading: Bool = true
    
    var body: some View {
        VStack{
            if loading {
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
                
            } else if let superHero = superHero {
                ScrollView (.vertical, showsIndicators: false) {
                    VStack (spacing: 16) {
                        
                        AsyncImage(url: URL(string: superHero.image.url))
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: 320)
                            .clipped()
                            .padding(.horizontal)
                            .cornerRadius(20)
                        
                        Text(superHero.name)
                            .bold()
                            .font(.largeTitle)
                            .foregroundColor(.icon)
                            .padding(.bottom, 2)
                        
                        HStack{
                            Text("The aliases are: ")
                                .bold()
                                .foregroundColor(.white) +
                            Text(superHero.biography.aliases.filter({ $0 != "-" }).joined(separator: ", "))
                                .foregroundColor(.icon)
                                .bold()
                                .font(.title3)
                        }
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.bottom, 2)
                        
                        Text("The publiser is: ")
                            .bold()
                            .foregroundColor(.white)
                        +
                        Text("\(superHero.biography.publisher)")
                            .foregroundColor(.icon)
                            .bold()
                            .font(.title3)
                        
                        SuperheroStats(stats: superHero.powerstats)
                            .frame(maxWidth: .infinity)
                        
                        
                        Text("\(superHero.name) is a ")
                            .bold()
                            .foregroundColor(.white)
                        +
                        Text("\(superHero.biography.alignment)")
                            .foregroundColor(.icon)
                            .font(.title3)
                            .italic()
                        +
                        Text(" hero")
                            .bold()
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.backgroundApp)
        .onAppear{
            Task{
                do {
                    superHero = try await ApiNetwork().getHeroById(id: id)
                } catch {
                    superHero = nil
                }
                loading = false
            }
        }
    }
}

struct SuperheroStats:View {
    let stats: ApiNetwork.Powestats
    
    var body: some View{
        VStack{
            Chart {
                SectorMark(
                    angle: .value("Count", Int(stats.combat) ?? 0),
                    innerRadius: .ratio(0.6),
                    angularInset: 5
                )
                .cornerRadius(5)
                .foregroundStyle(by: .value("Category", "Combat"))
                
                SectorMark(
                    angle: .value("Count", Int(stats.durability) ?? 0),
                    innerRadius: .ratio(0.6),
                    angularInset: 5
                )
                .cornerRadius(5)
                .foregroundStyle(by: .value("Category", "Durability"))
                
                SectorMark(
                    angle: .value("Count", Int(stats.durability) ?? 0),
                    innerRadius: .ratio(0.6),
                    angularInset: 5
                )
                .cornerRadius(5)
                .foregroundStyle(by: .value("Category", "Intelligence"))
                
                SectorMark(
                    angle: .value("Count", Int(stats.durability) ?? 0),
                    innerRadius: .ratio(0.6),
                    angularInset: 5
                )
                .cornerRadius(5)
                .foregroundStyle(by: .value("Category", "Strength"))
                
                SectorMark(
                    angle: .value("Count", Int(stats.durability) ?? 0),
                    innerRadius: .ratio(0.6),
                    angularInset: 5
                )
                .cornerRadius(5)
                .foregroundStyle(by: .value("Category", "Speed"))
                
                SectorMark(
                    angle: .value("Count", Int(stats.durability) ?? 0),
                    innerRadius: .ratio(0.6),
                    angularInset: 5
                )
                .cornerRadius(5)
                .foregroundStyle(by: .value("Category", "Power"))
                
            }
            .padding()
            
        }
        .frame(maxWidth: .infinity, maxHeight: 350)
        .background(.textApp)
        .cornerRadius(16)
        .padding(24)
    }
    
}

#Preview {
    SuperHeroDetail(id: "11")
}
