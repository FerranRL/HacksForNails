//
//  Appointment.swift
//  HacksForNails
//
//  Created by Ferran Rosales on 12/9/24.
//

import Foundation

struct Appointment: Identifiable {
    var id: String
    var clientID: String
    var price: String
    var saloon: String
    var service: String
    var serviceTime: String
    var time: String
    var prepaid: Bool
    var startTime: Date?
    var date: Date
}
