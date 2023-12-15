//
//  CreatePaymentOrder.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 15/12/23.
//

import Foundation


// MARK: - Welcome
struct PaymentOrderModel: Codable {
    let status: String?
    let statusCode: Int?
    let message: String?
    let data: PaymentOrder?

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case statusCode = "StatusCode"
        case message = "Message"
        case data = "Data"
    }
}

// MARK: - DataClass
struct PaymentOrder: Codable {
    let amount, amountDue, amountPaid, attempts: Int?
    let createdAt: Int?
    let currency, entity, id: String?
    let notes: Notes?
    let receipt, status: String?

    enum CodingKeys: String, CodingKey {
        case amount
        case amountDue = "amount_due"
        case amountPaid = "amount_paid"
        case attempts
        case createdAt = "created_at"
        case currency, entity, id, notes
        case receipt, status
    }
}

// MARK: - Notes
struct Notes: Codable {
    let key1: String?
}
