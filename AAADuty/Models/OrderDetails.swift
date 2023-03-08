//
//  OrderDetails.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 08/03/23.
//

import Foundation

struct OrderDetails: Codable {
    var category: Category?
    var totalAmount: Int?
    var address: Location?
    var pickUpAddress: Location?
    var dropAddress: Location?
    var complaintType: ComplaintType?
    var userAddress: Location?
    var count: Int = 0
    
    func getRequestParams() -> [String: Any]? {
        var orderRequestParams: [String: Any] = [:]
        orderRequestParams["AddTip"] = 0
        orderRequestParams["CategoryID"] = category?.id
        orderRequestParams["CategoryName"] = category?.category
        orderRequestParams["ComplaintTypeID"] = complaintType?.id
        orderRequestParams["ComplaintTypeName"] = complaintType?.complaint
        orderRequestParams["typeID"] = complaintType?.typeID ?? ""
        orderRequestParams["typeName"] = complaintType?.typeName ?? ""
        orderRequestParams["GST"] = category?.gst ?? 0
        orderRequestParams["Price"] = totalAmount
        orderRequestParams["Tax"] = complaintType?.pgServiceTax ?? 0
        orderRequestParams["pinCode"] = address?.postalCode ?? 0
        
        // CHeck this
        orderRequestParams["CustomerAddress"] = AppData.shared.user?.address
        orderRequestParams["CustomerID"] = AppData.shared.user?.id
        orderRequestParams["CustomerName"] = AppData.shared.user?.customerName
        orderRequestParams["CustomerPhoneNumber"] = AppData.shared.user?.mobileNumber
        orderRequestParams["CustomerLocation"] = "\(String(describing: userAddress?.longitude)),\(String(describing: userAddress?.latitude))"
        
        orderRequestParams["DesinationAddress"] = address?.address
        orderRequestParams["DestinationLat"] = "\(String(describing: address?.latitude))"
        orderRequestParams["DestinationLocation"] = "\(String(describing: address?.longitude)),\(String(describing: address?.latitude))"
        orderRequestParams["DestinationLong"] = "\(String(describing: address?.longitude))"
        
        var serviceParams: [String: Any] = [:]
        serviceParams["CategoryID"] = category?.id ?? ""
        serviceParams["CategoryName"] = category?.category ?? ""
        serviceParams["Complaint"] = complaintType?.complaint ?? ""
        serviceParams["NoOfCount"] = count
        serviceParams["Price"] = complaintType?.price ?? 0
        serviceParams["TypeID"] = complaintType?.typeID ?? ""
        serviceParams["TypeName"] = complaintType?.typeName ?? ""
        serviceParams["isActive"] = complaintType?.isActive ?? false
        orderRequestParams["Services"] = serviceParams
        
        // Check this
        orderRequestParams["Distance"] = 6
        orderRequestParams["Note"] = ""
        orderRequestParams["Problems"] = []
        orderRequestParams["Remarks"] = ""
        
        orderRequestParams["EndTime"] = ""
        orderRequestParams["SlotId"] = ""
        orderRequestParams["SourceAddress"] = ""
        orderRequestParams["SourceLocation"] = ""
        orderRequestParams["SourceLong"] = ""
        orderRequestParams["SourctLat"] = ""
        orderRequestParams["StartTime"] = ""
        orderRequestParams["TotalSFT"] = ""
        orderRequestParams["TransactionAmount"] = ""
        orderRequestParams["TransactionDoneBy"] = ""
        orderRequestParams["TransactionID"] = ""
        orderRequestParams["TransactionMode"] = ""
        orderRequestParams["VendorID"] = ""
        orderRequestParams["VendorPhoneNumber"] = ""
        orderRequestParams["VendorSlotID"] = ""
        orderRequestParams["VenodrName"] = ""
        
        return orderRequestParams
    }
}
