//
//  ScanViewModel.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 22.05.2024.
//

import Foundation
import CoreBluetooth
import SystemConfiguration.CaptiveNetwork
import Network
import LanScanner
import SwiftUI

struct DeviceInfo {
    var name: String
    var connectionType: String
    var ipAdress: String
    var id = UUID()
    var date: String
    var isSuspicious: Bool
}

final class ScanViewModel: ObservableObject {
    
    @Published var isScanning = false
    @Published var buttonText = "Start"
    @Published var devicesInfo: [DeviceInfo] = []
    @Published var devices: [Device] = []
    
    @Published var bluetoothOffAlert = false
    
    let bluetoothManager = BluetoothManager()
    let lanScanner = CountViewModel()
    let coreData = CoreDataManager.shared
    
    
    func scanButton() {
        
// MARK: - setting up
        devices.removeAll()
        devicesInfo.removeAll()
        bluetoothManager.peripherals.removeAll()
        lanScanner.connectedDevices.removeAll()
        isScanning = true
        
//MARK: - checking the availability
        
        if bluetoothManager.bluetoothOff == true {
            bluetoothOffAlert = true
            return
        }
        
//MARK: - scanning
        bluetoothManager.centralManager.scanForPeripherals(withServices: nil, options: nil)
        lanScanner.scanner.start()
        
        Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { timer in
            
            var intText = Int(self.buttonText.replacingOccurrences(of: "%", with: "")) ?? 0
            intText += 1
            self.buttonText = "\(intText)%"
            
//MARK: - stopping scanning
            if intText >= 100 {
                timer.invalidate()
                guard !self.bluetoothManager.peripherals.isEmpty else {return}
                for device in self.bluetoothManager.peripherals {
                    self.devicesInfo.append(device)
                }
                
                guard !self.lanScanner.connectedDevices.isEmpty else {return}
                for device in self.lanScanner.connectedDevices {
                    self.devicesInfo.append(DeviceInfo(name: device.name, connectionType: "Wi-Fi", ipAdress: device.ipAddress, id: device.id, date: formatDateToString(date: .now), isSuspicious: device.id.uuidString.contains("123")))
                }
                
                self.bluetoothManager.centralManager.stopScan()
                self.lanScanner.scanner.stop()
             
//MARK: - saving devices
                for item in self.devicesInfo {
                    let uuid = UUID()
                    self.coreData.saveEntity(name: item.name, ipAdress: item.ipAdress, id: uuid, date: item.date, connectionType: item.connectionType, isSuspicious: item.isSuspicious)
                    let all = self.coreData.allEntities()
                    let savedEntity = all.first(where: {$0.id == uuid})
                    self.devices.append(savedEntity!)
                }
                
//MARK: - setting out
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.buttonText = "Start"
                        self.isScanning = false
                    }
                }
            }
        }
    }
}

final class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    
    @Published var peripherals: [DeviceInfo] = []
    @Published var bluetoothOff = false
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        bluetoothOff = false
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            bluetoothOff = true
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(where: { $0.id == peripheral.identifier }) {
            peripherals.append(DeviceInfo(name: peripheral.name ?? "No name", connectionType: "Bluetooth", ipAdress: "Not Available", id: peripheral.identifier, date: formatDateToString(date: .now), isSuspicious: peripheral.identifier.uuidString.contains("123")))
        }
    }
}

class CountViewModel: ObservableObject {

    // Properties

    @Published var connectedDevices = [LanDevice]()
    @Published var progress: CGFloat = .zero
    @Published var title: String = .init()
    @Published var showAlert = false

    lazy var scanner = LanScanner(delegate: self)

    // Init

    init() { }

    // Methos

    func reload() {
        connectedDevices.removeAll()
        scanner.start()
    }
}

extension CountViewModel: LanScannerDelegate {
    func lanScanHasUpdatedProgress(_ progress: CGFloat, address: String) {
        self.progress = progress
        self.title = address
    }

    func lanScanDidFindNewDevice(_ device: LanDevice) {
        connectedDevices.append(device)
    }

    func lanScanDidFinishScanning() {
        showAlert = true
    }
}

extension LanDevice: Identifiable {
    public var id: UUID { .init() }
}

public func formatDateToString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy-HH:mm"
    return dateFormatter.string(from: date)
}
