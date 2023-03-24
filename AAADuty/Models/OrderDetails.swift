//
//  OrderDetails.swift
//  AAADuty
//
//  Created by Saikiran Panuganti on 08/03/23.
//

import Foundation
import CoreLocation

struct OrderDetails: Codable {
    var category: Category?
    var totalAmount: Int?
    var address: Location?
    var pickUpAddress: Location?
    var dropAddress: Location?
    var complaintType: ComplaintType?
    var vehicleProblem: VechicleProblem?
    var userAddress: Location?
    var count: Int = 0
    var comments: String?
    
    func getRequestParams() -> [String: Any]? {
        var orderRequestParams: [String: Any] = [:]
        orderRequestParams["AddTip"] = 0
        orderRequestParams["CategoryID"] = category?.id ?? ""
        orderRequestParams["CategoryName"] = category?.category ?? ""
        orderRequestParams["ComplaintTypeID"] = complaintType?.id ?? ""
        orderRequestParams["ComplaintTypeName"] = complaintType?.complaint ?? ""
        orderRequestParams["typeID"] = complaintType?.typeID ?? ""
        orderRequestParams["typeName"] = complaintType?.typeName ?? ""
        orderRequestParams["GST"] = complaintType?.gst ?? 0
        let amount = (count*(complaintType?.price ?? 0)) + (complaintType?.serviceCharge ?? 0) + (complaintType?.pgServiceTax ?? 0)
        orderRequestParams["Price"] = amount
        orderRequestParams["Tax"] = complaintType?.pgServiceTax ?? 0
        orderRequestParams["pinCode"] = Int(address?.postalCode ?? "0")
        
        // CHeck this
        orderRequestParams["CustomerAddress"] = address?.address
        orderRequestParams["CustomerID"] = AppData.shared.user?.id ?? ""
        orderRequestParams["CustomerName"] = AppData.shared.user?.customerName ?? ""
        orderRequestParams["CustomerPhoneNumber"] = AppData.shared.user?.mobileNumber ?? ""
        orderRequestParams["CustomerLocation"] = "\(address?.longitude ?? 0),\(address?.latitude ?? 0)"
        
        orderRequestParams["DesinationAddress"] = address?.address
        orderRequestParams["DestinationLat"] = "\(address?.latitude ?? 0)"
        orderRequestParams["DestinationLocation"] = "\(address?.longitude ?? 0),\(address?.latitude ?? 0)"
        orderRequestParams["DestinationLong"] = "\(address?.longitude ?? 0)"
        
        var serviceParams: [String: Any] = [:]
        serviceParams["CategoryID"] = category?.id ?? ""
        serviceParams["CategoryName"] = category?.category ?? ""
        serviceParams["Complaint"] = complaintType?.complaint ?? ""
        serviceParams["NoOfCount"] = count
        serviceParams["Price"] = complaintType?.price ?? 0
        serviceParams["TypeID"] = complaintType?.typeID ?? ""
        serviceParams["TypeName"] = complaintType?.typeName ?? ""
        serviceParams["isActive"] = complaintType?.isActive ?? false
        orderRequestParams["Services"] = [serviceParams]
        
        // Check this
        if let userLatitude = userAddress?.latitude, let userLongitude = userAddress?.longitude, let destLatitude = address?.latitude, let destLongitude = address?.longitude {
            let userLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
            let destLocation = CLLocation(latitude: destLatitude, longitude: destLongitude)
            let distance = userLocation.distance(from: destLocation)/1000
            orderRequestParams["Distance"] = distance
        }else {
            orderRequestParams["Distance"] = 0
        }
        orderRequestParams["Note"] = ""
        orderRequestParams["Remarks"] = comments
        
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
