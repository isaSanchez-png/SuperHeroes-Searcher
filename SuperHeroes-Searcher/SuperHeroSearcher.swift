//
//  SuperHeroSearcher.swift
//  SuperHeroes-Searcher
//
//  Created by Isa on 10/06/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct SuperHeroSearcher: View {
    @State var superHeroName: String = ""
    @State var wrapper: ApiNetwork.Wrapper? = nil
    @State var loading: Bool = false
    
    var body: some View {
        VStack{
            TextField("", text: $superHeroName, prompt: Text("Superman...")
                .foregroundColor(.textApp.opacity(0.5))
                .bold()
                .font(.title))
            .padding()
            .background(.icon)
            .cornerRadius(16)
            
            .foregroundColor(.white)
            .bold()
            .font(.title)
            .padding(16)
            .autocorrectionDisabled()
            .onSubmit {
                loading = true
                Task {
                    do {
                        wrapper = try await ApiNetwork().getHerosByQuery(query: superHeroName)
                    } catch {
                        print("Error")
                    }
                    loading = false
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.backgroundApp)
            NavigationStack{
                ZStack{
                    Color.backgroundApp.ignoresSafeArea()
                    
                    if loading {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.5)
                    }
                    List(wrapper? .results ?? []){
                        superhero in
                        ZStack{
                            SuperheroItem(superhero: superhero)
                            NavigationLink(destination: SuperHeroDetail(id: superhero.id)){
                                EmptyView()
                            }
                            .opacity(0)
                        }
                        .listRowBackground(Color.backgroundApp)
                        .listRowSeparator(.hidden)
                        .padding(.vertical, 4)
                    }
                    .listStyle(.plain)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.backgroundApp)
    }
}

struct SuperheroItem: View {
    let superhero: ApiNetwork.SuperHero
    
    var body: some View {
        ZStack{
            AsyncImage(url: URL(string: superhero.image.url))
            { phase in switch phase {
            case .empty:
                ZStack {
                    Color.gray.opacity(0.2)
                    ProgressView() .tint(.white)
                }
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                ZStack {
                    Color.gray.opacity(0.3)
                    Image(systemName: "person.fill.questionmark")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
            default :EmptyView()
            }
            }
            
            VStack{
                Spacer()
                Text(superhero.name)
                    .foregroundColor(.white)
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(.icon)
            }
        }
        .frame(height: 200)
        .cornerRadius(32)
        .listRowBackground(Color.backgroundApp)
    }
}

#Preview {
    SuperHeroSearcher()
}
