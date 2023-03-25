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
    var isManualTransmission: Bool?
    var vehicleType: VechicleType?
    var subCategory: SubCategory?
    var vehicle: Vechicle?
    
    func getRequestParams() -> [String: Any]? {
        if category?.serviceType == .flatTyre {
            return getFlatTyreParams()
        }else if category?.serviceType == .towing {
            return getTowingParams()
        }else if category?.serviceType == .vechicletech {
            return getVehicleTechParams()
        }
        return nil
    }
    
    func getFlatTyreParams() -> [String: Any]? {
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
    
    func getTowingParams() -> [String: Any]? {
        var orderRequestParams: [String: Any] = [:]
        orderRequestParams["AddTip"] = 0
        orderRequestParams["CategoryID"] = category?.id ?? ""
        orderRequestParams["CategoryName"] = category?.category ?? ""
        orderRequestParams["ComplaintTypeID"] = complaintType?.id ?? ""
        orderRequestParams["ComplaintTypeName"] = complaintType?.complaint ?? ""
        orderRequestParams["typeID"] = complaintType?.typeID ?? ""
        orderRequestParams["typeName"] = complaintType?.typeName ?? ""
        orderRequestParams["GST"] = complaintType?.gst ?? 0
        let amount = (complaintType?.price ?? 0) + (complaintType?.serviceCharge ?? 0) + (complaintType?.pgServiceTax ?? 0)
        orderRequestParams["Price"] = amount
        orderRequestParams["Tax"] = complaintType?.pgServiceTax ?? 0
        orderRequestParams["pinCode"] = Int(pickUpAddress?.postalCode ?? "0")
        
        // CHeck this
        orderRequestParams["CustomerAddress"] = userAddress?.address
        orderRequestParams["CustomerID"] = AppData.shared.user?.id ?? ""
        orderRequestParams["CustomerName"] = AppData.shared.user?.customerName ?? ""
        orderRequestParams["CustomerPhoneNumber"] = AppData.shared.user?.mobileNumber ?? ""
        orderRequestParams["CustomerLocation"] = "\(userAddress?.longitude ?? 0),\(userAddress?.latitude ?? 0)"
        
        orderRequestParams["DesinationAddress"] = dropAddress?.address
        orderRequestParams["DestinationLat"] = "\(dropAddress?.latitude ?? 0)"
        orderRequestParams["DestinationLocation"] = "\(dropAddress?.longitude ?? 0),\(dropAddress?.latitude ?? 0)"
        orderRequestParams["DestinationLong"] = "\(dropAddress?.longitude ?? 0)"
        
        orderRequestParams["SourceAddress"] = pickUpAddress?.address
        orderRequestParams["SourceLocation"] = "\(pickUpAddress?.longitude ?? 0),\(pickUpAddress?.latitude ?? 0)"
        orderRequestParams["SourceLong"] = "\(pickUpAddress?.longitude ?? 0)"
        orderRequestParams["SourctLat"] = "\(pickUpAddress?.latitude ?? 0)"
        
        var serviceParams: [String: Any] = [:]
        serviceParams["CategoryID"] = category?.id ?? ""
        serviceParams["CategoryName"] = category?.category ?? ""
        serviceParams["Complaint"] = complaintType?.complaint ?? ""
        serviceParams["Price"] = complaintType?.price ?? 0
        serviceParams["TypeID"] = complaintType?.typeID ?? ""
        serviceParams["TypeName"] = complaintType?.typeName ?? ""
        serviceParams["isActive"] = complaintType?.isActive ?? false
        orderRequestParams["Services"] = [serviceParams]
        
        // Check this
        if let userLatitude = pickUpAddress?.latitude, let userLongitude = pickUpAddress?.longitude, let destLatitude = dropAddress?.latitude, let destLongitude = dropAddress?.longitude {
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
    
    func getVehicleTechParams() -> [String: Any]? {
        var orderRequestParams: [String: Any] = [:]
        
        orderRequestParams["CategoryID"] = category?.id ?? ""
        orderRequestParams["CategoryName"] = category?.category ?? ""
        orderRequestParams["CustomerAddress"] = userAddress?.address
        orderRequestParams["CustomerID"] = AppData.shared.user?.id ?? ""
        orderRequestParams["CustomerLocation"] = "\(userAddress?.longitude ?? 0),\(userAddress?.latitude ?? 0)"
        orderRequestParams["CustomerPhoneNumber"] = AppData.shared.user?.mobileNumber ?? ""
        orderRequestParams["DesinationAddress"] = address?.address
        orderRequestParams["DestinationLat"] = "\(address?.latitude ?? 0)"
        orderRequestParams["DestinationLocation"] = "\(address?.longitude ?? 0),\(address?.latitude ?? 0)"
        orderRequestParams["DestinationLong"] = "\(address?.longitude ?? 0)"
        orderRequestParams["typeID"] = subCategory?.id ?? ""
        orderRequestParams["typeName"] = subCategory?.typeName ?? ""
        orderRequestParams["VehicleTypeID"] = vehicleType?.id ?? ""
        orderRequestParams["VehicleTypeName"] = vehicleType?.vehileType ?? ""
        orderRequestParams["ComplaintTypeID"] = vehicleProblem?.id ?? ""
        if let manual = isManualTransmission {
            if manual {
                orderRequestParams["ComplaintTypeName"] = "Manual"
            }else {
                orderRequestParams["ComplaintTypeName"] = "Automatic"
            }
        }
        orderRequestParams["BrandID"] = vehicle?.brandID
        orderRequestParams["BrandName"] = vehicle?.brand
        orderRequestParams["VehicleName"] = vehicle?.vehicleName
        orderRequestParams["Problem"] = vehicleProblem?.problem
        let amount = (vehicleProblem?.price ?? 0) + (vehicleProblem?.gst ?? 0) + (vehicleProblem?.pgServiceTax ?? 0)
        orderRequestParams["Price"] = amount
        orderRequestParams["PGServiceTax"] = vehicleProblem?.pgServiceTax
        orderRequestParams["GST"] = vehicleProblem?.gst
        orderRequestParams["TransactionAmount"] = ""
         orderRequestParams["TransactionDoneBy"] = ""
        orderRequestParams["TransactionID"] = ""
        orderRequestParams["TransactionMode"] = ""
        orderRequestParams["pinCode"] = Int(address?.postalCode ?? "0")
        
        return orderRequestParams
    }
}
