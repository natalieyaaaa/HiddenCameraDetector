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
    let lanScanner = CountViewModel()
    let coreData = CoreDataManager.shared
    
    func scanButton() {
        resetScan()
        startScanning()
        resetUIAfterScan()
    }

    private func resetScan() {
        devices.removeAll()
        isScanning = true
    }

    private func startScanning() {
        bluetoothManager.centralManager.scanForPeripherals(withServices: nil, options: nil)
        lanScanner.scanner.start()
        
        Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { timer in
            self.updateProgress()
            
            if self.scanCompleted() {
                self.finalizeScan()
                timer.invalidate()
            }
        }
    }

    private func updateProgress() {
        let currentProgress = Int(buttonText.replacingOccurrences(of: "%", with: "")) ?? 0
        let newProgress = min(currentProgress + 1, 100)
        buttonText = "\(newProgress)%"
    }

    private func scanCompleted() -> Bool {
        return Int(buttonText.replacingOccurrences(of: "%", with: "")) ?? 0 >= 100
    }

    private func finalizeScan() {
        stopScanning()
        saveDevicesToCoreData()
        resetUIAfterScan()
    }

    private func stopScanning() {
        bluetoothManager.centralManager.stopScan()
        lanScanner.scanner.stop()
    }

    private func saveDevicesToCoreData() {
        for peripheral in bluetoothManager.peripherals {
            devices.append(peripheral)
        }
        
        for device in lanScanner.connectedDevices {
            let deviceInfo = DeviceInfo(name: device.name, connectionType: "Wi-Fi", ipAdress: device.ipAddress, id: device.id, date: formatDateToString(date: .now))
            devices.append(deviceInfo)
        }
        
        for item in devices {
            coreData.saveEntity(name: item.name, ipAdress: item.ipAdress, id: UUID(), date: item.date, connectionType: item.connectionType)
        }
    }

    private func resetUIAfterScan() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.buttonText = "Start"
            self.isScanning = false
        }
    }}

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
            peripherals.append(DeviceInfo(name: peripheral.name ?? "Unknown", connectionType: "Bluetooth", ipAdress: "Not Available", id: peripheral.identifier, date: formatDateToString(date: .now)))
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
