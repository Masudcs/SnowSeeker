//
//  HomeScreen.swift
//  SnowSeeker
//
//  Created by Md. Masud Rana on 3/14/23.
//

import SwiftUI

extension View {
    @ViewBuilder func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            navigationViewStyle(.stack)
        } else {
            self
        }
    }
}

struct HomeScreen: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    @State private var sortType = "default"
    
    var sortedResorts: [Resort] {
        switch sortType {
        case "country":
            return resorts.sorted { $0.country.lowercased() < $1.country.lowercased() }
        case "apphabetical":
            return resorts.sorted { $0.name.lowercased() < $1.name.lowercased() }
        default:
            return resorts
        }
    }
    
    @State private var searchText = ""
    
    @StateObject var favorites = Favorites()

    var body: some View {
        NavigationView {
            List(filteredResorts) { resort in
                NavigationLink {
                    ResortView(resort: resort)
                } label: {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundColor(.secondary)
                        }
                        
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .searchable(text: $searchText, prompt: "Search for a resort")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Default Order", action: {
                            sortType = "default"
                        })
                        Button("Alphabetical Order", action: {
                            sortType = "apphabetical"
                        })
                        Button("Country Order", action: {
                            sortType = "country"
                        })
                    } label: {
                        Label("", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            
            WelcomeView()
        }
        .phoneOnlyStackNavigationView()
        .environmentObject(favorites)
    }
    
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            return sortedResorts
        } else {
            return sortedResorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func shortResorts(type: String = "default") -> [Resort] {
        switch type {
        case "country":
            return sortedResorts.sorted { $0.country.lowercased() < $1.country.lowercased() }
        case "apphabetical":
            return sortedResorts.sorted { $0.name.lowercased() < $1.name.lowercased() }
        default:
            return resorts
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
