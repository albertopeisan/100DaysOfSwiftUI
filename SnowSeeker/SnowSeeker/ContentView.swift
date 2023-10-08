//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Alberto Peinado Santana on 1/10/23.
//

import SwiftUI



struct ContentView: View {
    @ObservedObject var favorites = Favorites()
    @State private var searchText = ""
    @State private var orderBy: OrderBy = .none
    
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    enum OrderBy {
        case none, alphabeticalAsc, alphabeticalDesc, countryAsc, countryDesc
    }
    
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            return resorts
        } else {
            return resorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var orderedResorts: [Resort] {
        switch orderBy {
        case .none:
            return filteredResorts
        case .alphabeticalAsc:
            return filteredResorts.sorted {
                $0.name < $1.name
            }
        case .alphabeticalDesc:
            return filteredResorts.sorted {
                $0.name > $1.name
            }
        case .countryAsc:
            return filteredResorts.sorted {
                $0.country < $1.country
            }
        case .countryDesc:
            return filteredResorts.sorted {
                $0.country > $1.country
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Order By", selection: $orderBy) {
                    Text("Default").tag(OrderBy.none)
                    Text("Name A - Z").tag(OrderBy.alphabeticalAsc)
                    Text("Name Z - A").tag(OrderBy.alphabeticalDesc)
                    Text("Country A - Z").tag(OrderBy.countryAsc)
                    Text("Country Z - A").tag(OrderBy.countryDesc)
                }
                .pickerStyle(.automatic)
                .padding(.horizontal)
                
                List(orderedResorts) { resort in
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
                                .padding(.horizontal)
                            
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
            }
            
            
            WelcomeView()
        }
        .environmentObject(favorites)
        //        .phoneOnlyStackNavigationView()
    }
}

extension View {
    @ViewBuilder func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}

#Preview {
    ContentView()
}
