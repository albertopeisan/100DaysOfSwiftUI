//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Alberto Peinado Santana on 31/8/23.
//

import CodeScanner
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    
    let filter: FilterType
    
    @State private var order: OrderType = .none
    @State private var showingOrderByDialog = false
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    enum OrderType {
        case none, nameAscendant, nameDescendant, mostRecent, leastRecent
        var id: Self { self }
    }
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }
    
    var orderedProspects: [Prospect] {
        switch order {
        case .none:
            return filteredProspects
        case .nameAscendant:
            return filteredProspects.sorted {
                $0.name < $1.name
            }
        case .nameDescendant:
            return filteredProspects.sorted {
                $0.name > $1.name
            }
        case .mostRecent:
            return filteredProspects.sorted {
                $0.createdAt > $1.createdAt
            }
        case .leastRecent:
            return filteredProspects.sorted {
                $0.createdAt < $1.createdAt
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                if !filteredProspects.isEmpty {
                    Button("Order by") {
                        showingOrderByDialog = true
                    }
                }
                
                ForEach(orderedProspects) { prospect in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if prospect.isContacted {
                            Image(systemName: "person.crop.circle.fill.badge.checkmark")
                                .imageScale(.large)
                                .foregroundColor(.green)
                        }
                    }
                    .swipeActions {
                        if prospect.isContacted {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                            
                            Button {
                                addNotification(for: prospect)
                            } label: {
                                Label("Remind Me", systemImage: "bell")
                            }
                            .tint(.orange)
                        }
                    }
                }
                
                Button("Add random prospects") {
                    var person = Prospect()
                    person.name = "Alberto Peinado"
                    person.emailAddress = "albertopeinado@gmail.com"
                    prospects.add(person)
                    
                    person = Prospect()
                    person.name = "Jorge Perez"
                    person.emailAddress = "jorgeperez@gmail.com"
                    prospects.add(person)
                    
                    person = Prospect()
                    person.name = "Walter Bou"
                    person.emailAddress = "walterbou@gmail.com"
                    prospects.add(person)
                }
            }
            .navigationTitle(title)
            .toolbar {
                Button {
                    isShowingScanner = true
                } label: {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
            }
            .confirmationDialog("Order by", isPresented: $showingOrderByDialog) {
                Button("Relevance") {
                    order = .none
                }
                Button("Name Ascendant") {
                    order = .nameAscendant
                }
                Button("Name Descendant") {
                    order = .nameDescendant
                }
                Button("Most Recent") {
                    order = .mostRecent
                }
                Button("Least Recent") {
                    order = .leastRecent
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            prospects.add(person)
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            //            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
}
