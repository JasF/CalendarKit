//
//  PhotosViewController.swift
//  CalendarApp
//
//  Created by Jasf on 8.01.23.
//  Copyright © 2023 Richard Topchii. All rights reserved.
//

import Foundation
import UIKit
import YPImagePicker
import CryptoSwift
import ProgressHUD

class PhotosViewController : UIViewController {
    @IBAction func backButtonTapped() {
        navigationController?.dismiss(animated: true)
    }
    @IBAction func addButtonTapped() {
        let picker = YPImagePicker()
        picker.didFinishPicking { [weak self, unowned picker] items, _ in
            guard let self = self else {
                return
            }
            if let photo = items.singlePhoto {
                self.addAndEncryptPhoto(photo.originalImage)
                /*
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                 */
                
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    @IBAction func viewButtonTapped() {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "FilesViewController") as! FilesViewController
        present(controller, animated: true)
    }
    
    func addAndEncryptPhoto(_ image: UIImage) {
        let data = image.pngData()
        if data == nil {
            let controller = UIAlertController(title: "error", message: "data is nil", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel)
            controller.addAction(ok)
            present(controller, animated: true)
            return
        }
        ProgressHUD.show("Photo adding")
        DispatchQueue.global(qos: .userInitiated).async {
            print("This is run on a background queue")
            
            let hexString = data!.hexEncodedString(options: [.upperCase])
            let key = Array<UInt8>(hex: "0123456789ABCDEFF0E1D2C3B4A59687")
            let iv = Array<UInt8>(hex: "FEDCBA9876543210")
            let input = Array<UInt8>(hex: hexString)
            do {
                let result = try? Blowfish(key: key, blockMode: CBC(iv: iv), padding: .zeroPadding).encrypt(input)
                if result != nil {
                    print("result count is: \(result!.count)")
                    let filename = Digest.md5(result!).toHexString()
                    let resultData = Data(result!)
                    let updatedPath = FileManager.default.urls(for: .documentDirectory,
                                                        in: .userDomainMask)[0].appendingPathComponent("menstrual")
                    if !FileManager.default.fileExists(atPath: updatedPath.path) {
                        do {
                            try FileManager.default.createDirectory(atPath: updatedPath.path, withIntermediateDirectories: true, attributes: nil)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    let path = FileManager.default.urls(for: .documentDirectory,
                                                        in: .userDomainMask)[0].appendingPathComponent("menstrual/\(filename)")
                    print("path is: \(path)")
                    try? resultData.write(to: path)
                    
                        DispatchQueue.main.async {
                            ProgressHUD.remove()
                            print("This is run on the main queue, after the previous code in outer block")
                            let controller = UIAlertController(title: "VSIO OK", message: "Photo Encrypted!", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .cancel)
                            controller.addAction(ok)
                            self.present(controller, animated: true)
                        }
                }
                else {
                    DispatchQueue.main.async {
                        ProgressHUD.remove()
                        print("This is run on the main queue, after the previous code in outer block")
                        let controller = UIAlertController(title: "error", message: "encryption failed", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .cancel)
                        controller.addAction(ok)
                        self.present(controller, animated: true)
                    }
                    return
                }
            }
            
        }
        
    }
}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return self.map { String(format: format, $0) }.joined()
    }
}

class FilesViewController : UIViewController, UITableViewDelegate,  UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    class CellInfo : NSObject {
        var fileName = ""
        var filePath = ""
    }
    var cells = [CellInfo]()
    @IBAction func closeTapped() {
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
        let fm = FileManager.default
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("menstrual")
        var pathString = path.absoluteString
        pathString = (pathString as NSString).replacingOccurrences(of: "file://", with: "")
        do {
            let items = try fm.contentsOfDirectory(atPath: pathString)

            for item in items {
                print("Found \(item)")
                let info = CellInfo()
                info.fileName = item
                info.filePath = "\(pathString)/\(item)"
                cells.append(info)
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosCell")! as! PhotosCell
        cell.title?.text = cells[indexPath.row].fileName
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let info = cells[indexPath.row]
            do {
                try FileManager.default.removeItem(atPath: info.filePath)
                print("Image has been deleted")
                cells.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print(error)
            }
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = cells[indexPath.row]
        let path = info.filePath
        let url = URL(string: "\("file:/")\("/")\(path)")!
        do {
            let data = try Data(contentsOf: url)
            print("data count is: \(data.count)")
            decryptDataAndShowImage(data)
        }
        catch {
            
        }
    }
    
    func decryptDataAndShowImage(_ data: Data) {
        ProgressHUD.show("Photo opening")
        DispatchQueue.global(qos: .userInitiated).async {
            print("This is run on a background queue")
            
            let hexString = data.hexEncodedString(options: [.upperCase])
            let key = Array<UInt8>(hex: "0123456789ABCDEFF0E1D2C3B4A59687")
            let iv = Array<UInt8>(hex: "FEDCBA9876543210")
            let input = Array<UInt8>(hex: hexString)
            do {
                let result = try? Blowfish(key: key, blockMode: CBC(iv: iv), padding: .zeroPadding).decrypt(input)
                if result != nil {
                    let resultData = Data(result!)
                    print("resultData is: \(resultData.count)")
                    let image = UIImage(data: resultData)!
                    print("image size is: \(image.size)")
                    DispatchQueue.main.async {
                        ProgressHUD.remove()
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ViewerViewController") as! ViewerViewController
                        controller.image = image
                        self.present(controller, animated: true)
                    }
                }
            }
            catch {
                
            }
        }
        
    }
}

class PhotosCell : UITableViewCell {
    @IBOutlet var title: UILabel?
}

class ViewerViewController : UIViewController {
    @IBAction func closeTapped() {
        dismiss(animated: true)
    }
    @IBOutlet var imageView: UIImageView!
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
