//
//  ContentView.swift
//  MVVM test
//
//  Created by addin on 29/12/20.
//

import SwiftUI

let apiUrl = "https://api.letsbuildthatapp.com/static/courses.json"

//model
struct Course: Identifiable, Decodable {
    let id = UUID()
    let name: String
}

//view model
class CoursesViewModel: ObservableObject {
    
    @Published var msg = "ini msg"
    @Published var courses: [Course] = [
        .init(name: "course 1"),
        .init(name: "course 2"),
        .init(name: "course 3")
        
    ]
    
    func FetchData() {
        guard let url = URL(string: apiUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode([Course].self, from: data)
                DispatchQueue.main.async {
                    self.courses = result
                }
            } catch {
                print("error: \(error)")
            }
        }.resume()
    }
    
    func change() {
        msg = "NANI"
    }
}

//view
struct ContentView: View {
    @ObservedObject var coursesVM = CoursesViewModel()
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(coursesVM.courses) { course in
                    Text(course.name)
                }
            }
            .navigationBarTitle("Courses")
            .navigationBarItems(trailing: Button(action:{
                print("refresh")
                coursesVM.FetchData()
            }) {
                Text("Refresh")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
