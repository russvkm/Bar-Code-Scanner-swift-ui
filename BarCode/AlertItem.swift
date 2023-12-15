//
//  AlertItem.swift
//  BarCode
//
//  Created by Shashank Pandey on 16/12/23.
//

import Foundation
import SwiftUI

struct AlertItem:Identifiable{
    let id: UUID = UUID()
    let title:String?
    let message:String?
    let actionButton:Alert.Button
}


struct AlertType{
    static let invalidAlertInput:AlertItem = AlertItem(title: "Invalid Input",
                                                       message: "Something went wrong with your camera. We are unable to capture input",
                                                       actionButton: .default(Text("Ok")))
    static let invalidBarCode:AlertItem = AlertItem(title: "Invalid barcode",
                                                    message: "This bar code is invalid. We only supports qr code, EAN8 and EAN13",
                                                    actionButton: .default(Text("OK")))
}
