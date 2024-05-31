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
    @Published var bluetoothAlert = false  // Add this line to show Bluetooth alert
    @Published var alertTitle = ""  // Add this line to show Bluetooth alert
    @Published var alertText = ""  // Add this line to show Bluetooth alert
    
    var bluetoothManager = BluetoothManager()
    let lanScanner = CountViewModel()
    let coreData = CoreDataManager.shared
    
    func scanButton() {
        
        // Check if Bluetooth is on before starting the scan
        guard bluetoothManager.isBluetoothOn() else {
            self.bluetoothAlert = true
            self.alertTitle = "Bluetooth is off"
            self.alertText = "The app needs Bluetooth to scan for nearby Bluetooth devices so please turn it on in the Settings"
            return
        }
        
        // MARK: - setting up
        devices.removeAll()
        devicesInfo.removeAll()
        bluetoothManager.peripherals.removeAll()
        lanScanner.connectedDevices.removeAll()
        isScanning = true
        
        // MARK: - scanning
        bluetoothManager.centralManager.scanForPeripherals(withServices: nil, options: nil)
        lanScanner.scanner.start()
        
        Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { timer in
            
            var intText = Int(self.buttonText.replacingOccurrences(of: "%", with: "")) ?? 0
            intText += 1
            self.buttonText = "\(intText)%"
            
            // MARK: - stopping scanning
            if intText >= 100 {
                timer.invalidate()
                guard !self.bluetoothManager.peripherals.isEmpty else { stopScanning(); return }
                for device in self.bluetoothManager.peripherals {
                    if device.name != "No name" {
                        self.devicesInfo.append(device)
                    }
                }
                
                guard !self.lanScanner.connectedDevices.isEmpty else { stopScanning(); return }
                for device in self.lanScanner.connectedDevices {
                    self.devicesInfo.append(DeviceInfo(name: device.name, connectionType: "Wi-Fi", ipAdress: device.ipAddress, id: device.id, date: formatDateToString(date: .now), isSuspicious: isIpAdress(device.name)))
                }
                
                self.bluetoothManager.centralManager.stopScan()
                self.lanScanner.scanner.stop()
                
                // MARK: - saving devices
                for item in self.devicesInfo {
                    let uuid = UUID()
                    self.coreData.saveEntity(name: item.name, ipAdress: item.ipAdress, id: uuid, date: item.date, connectionType: item.connectionType, isSuspicious: item.isSuspicious)
                    let all = self.coreData.allEntities()
                    if let savedEntity = all.first(where: { $0.id == uuid }) {
                        self.devices.append(savedEntity)
                    }
                }
                
                // MARK: - setting out
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.buttonText = "Start"
                        self.isScanning = false
                    }
                }
            }
        }
        
        func stopScanning() {
            self.bluetoothManager.centralManager.stopScan()
            self.lanScanner.scanner.stop()
            self.alertTitle = "Unsuccessful scanning"
            self.alertText = "Please make sure your Bluetooth and Wi-Fi are turned on and try again"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
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
    func checkAndShowBluetoothPermissionAlert() {
        let bluetoothAuthorizationStatus = CBManager.authorization
        switch bluetoothAuthorizationStatus {
        case .restricted, .denied, .notDetermined:
            showBluetoothPermissionAlert()
        case .allowedAlways:
            print("Bluetooth usage is authorized always.")
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }
    
    private func showBluetoothPermissionAlert() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        let alertController = UIAlertController(title: "No Access to Bluetooth",
                                                message: "The app requires access to Bluetooth to search for devices around you.",
                                                preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        window.rootViewController?.present(alertController, animated: true, completion: nil)
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
            peripherals.append(DeviceInfo(name: peripheral.name ?? "No name", connectionType: "Bluetooth", ipAdress: "Not Available", id: peripheral.identifier, date: formatDateToString(date: .now), isSuspicious: isIpAdress(peripheral.name ?? "")))
        }
    }
    
    func isBluetoothOn() -> Bool {
        return centralManager.state == .poweredOn
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


public func isIpAdress(_ ipAddress: String) -> Bool {
    let ipv4Pattern = "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
    let ipv6Pattern = "((([0-9a-fA-F]{1,4}:){7}([0-9a-fA-F]{1,4}|:))|(([0-9a-fA-F]{1,4}:){6}(:[0-9a-fA-F]{1,4}|(:[0-9a-fA-F]{1,4}){1,2}|:))|(([0-9a-fA-F]{1,4}:){5}((:[0-9a-fA-F]{1,4}){1,3}|:))|(([0-9a-fA-F]{1,4}:){4}((:[0-9a-fA-F]{1,4}){1,4}|:))|(([0-9a-fA-F]{1,4}:){3}((:[0-9a-fA-F]{1,4}){1,5}|:))|(([0-9a-fA-F]{1,4}:){2}((:[0-9a-fA-F]{1,4}){1,6}|:))|(([0-9a-fA-F]{1,4}:){1}((:[0-9a-fA-F]{1,4}){1,7}|:))|(:((:[0-9a-fA-F]{1,4}){1,8}|:)))"
    
    let ipv4Predicate = NSPredicate(format: "SELF MATCHES %@", ipv4Pattern)
    let ipv6Predicate = NSPredicate(format: "SELF MATCHES %@", ipv6Pattern)
    
    return ipv4Predicate.evaluate(with: ipAddress) || ipv6Predicate.evaluate(with: ipAddress)
}
