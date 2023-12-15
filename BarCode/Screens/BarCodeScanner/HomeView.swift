//
//  ContentView.swift
//  BarCode
//
//  Created by Shashank Pandey on 15/12/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = BarCodeScannerViewModel()
    var body: some View {
        NavigationStack{
            VStack {
                ScannerView(scannerCode: $viewModel.scannedCode, alertItem: $viewModel.alertItem)
                    .frame(maxWidth:.infinity, maxHeight: 300)
                Spacer()
                    .frame(height:60)
                Label("Scanned Barcode", systemImage: "barcode.viewfinder")
                    .font(.title)
                Text(viewModel.notScanned)
                    .bold()
                    .font(.largeTitle)
                    .foregroundStyle(viewModel.barScanned)
                    .padding()
            }
            .navigationTitle("Barcode Scanner")
            .alert(item: $viewModel.alertItem){
                alertItem in
                Alert(title: Text(alertItem.title ?? ""), message: Text(alertItem.message ?? ""), dismissButton: alertItem.actionButton)
            }
        }
    }
}

#Preview {
    HomeView()
}
