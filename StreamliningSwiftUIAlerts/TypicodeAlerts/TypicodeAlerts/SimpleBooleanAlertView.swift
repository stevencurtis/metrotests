import SwiftUI

struct SimpleBooleanAlertView: View {
    @State private var showAlert = false

    var body: some View {
        Button("Show Alert") {
            showAlert = true
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Delete File"),
                message: Text("Are you sure you want to delete this file? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    // Delete action
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
    }
}

#Preview {
    SimpleBooleanAlertView()
}
