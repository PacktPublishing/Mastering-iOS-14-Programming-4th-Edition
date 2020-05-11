



import SwiftUI

struct ContentView: View {
    
    @State var contacts: [String] = [String]()
    
    var body: some View {
        List {
            ForEach(contacts, id: \.self) { contact in
                RowView(name: contact)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let mockData = ["Chris", "Andy", "Harry", "Nathan", "Sam"]
        return ContentView(contacts: mockData)
    }
}

struct RowView: View {
    
    @State var name: String
    
    var body: some View {
        Text(name)
    }
    
}
