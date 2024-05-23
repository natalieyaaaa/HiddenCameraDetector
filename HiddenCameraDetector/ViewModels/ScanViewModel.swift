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


struct DeviceInfo {
    var name: String
    var connectionType: String
    var ipAdress: String
    var id = UUID()
    var date: String
    
}

final class ScanViewModel: ObservableObject {
    
    @Published var isScanning = false
    @Published var buttonText = "Start"
    @Published var devices: [DeviceInfo] = []
    
    let bluetoothManager = BluetoothManager()
    let coreData = CoreDataManager.shared
    
    func scanButton() {
        devices.removeAll()
        isScanning = true
        
        bluetoothManager.centralManager.scanForPeripherals(withServices: nil, options: nil)
        
        Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { timer in
            
            var intText = Int(self.buttonText.replacingOccurrences(of: "%", with: "")) ?? 0
            intText += 1
            self.buttonText = "\(intText)%"
            
            if intText >= 100 {
                
                timer.invalidate()
                guard !self.bluetoothManager.peripherals.isEmpty else {return}
                for device in self.bluetoothManager.peripherals {
                    self.devices.append(device)
                }
                
                self.bluetoothManager.centralManager.stopScan()
             
                for item in self.devices {
                    self.coreData.saveEntity(name: item.name, ipAdress: item.ipAdress, id: UUID(), date: item.date, connectionType: item.connectionType)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.buttonText = "Start"
                    self.isScanning = false
                    
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
    
    func formatDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy-HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(where: { $0.id == peripheral.identifier }) {
            peripherals.append(DeviceInfo(name: peripheral.name ?? "Unknown", connectionType: "Bluetooth", ipAdress: "Not Available", id: peripheral.identifier, date: formatDateToString(date: .now)))
        }
    }
}


