//
//  ScanViewModel.swift
//  HiddenCameraDetector
//
//  Created by Наташа Яковчук on 22.05.2024.
//

import Foundation
import CoreBluetooth

struct Device {
    var name: String
    var connectionType: String
    var ipAdress: String
    var id = UUID()
}

final class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    
    @Published var peripherals: [Device] = []
    @Published var bluetoothOff = false
    
//    static var shared = BluetoothManager()

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
            peripherals.append(Device(name: peripheral.name ?? "Unknown", connectionType: "Bluetooth", ipAdress: "192.168.\(Int.random(in: 100..<1000))", id: peripheral.identifier))
        }
    }
}


