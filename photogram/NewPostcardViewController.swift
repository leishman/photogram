//
//  NewPostcardViewController.swift
//  photogram
//
//  Created by Alexander Leishman on 11/29/15.
//  Copyright © 2015 Alexander Leishman. All rights reserved.
//

import UIKit
import MobileCoreServices

class NewPostcardViewController: DismissKeyboardController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, KeyboardToolbarDelegate {
    
    // Instance vars
    private var imageView = UIImageView()
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        
        set {
            // unhide control elements requiring a view
            filterButton.hidden = false
            nextButton.hidden = false
            imageView.image = newValue
        }
    }
    
    private var postcard: Postcard?
    
    let filterOptions = ["Sepia", "Black and White", "Vintage"]
    
    let filterPickerView = UIPickerView()
    
    
    
    // MARK: Outlets
    @IBOutlet weak var filterSelectField: UITextField!


    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
        }
    }
    
    // MARK: Actions
    
    @IBAction func nextView(sender: UIButton) {
        savePostcard()
    }
    
    @IBAction func chooseFilter(sender: UIButton) {
        filterSelectField.becomeFirstResponder()
    }
    
    
    // MARK: File saving and Core Data
    
    // Contains logic to capture visible section of original image
    // In other words this performs the crop logic and retuns the new cropped image
    private func getNewImage() -> UIImage {
        // horizontal scaling factor
        let scalew = (1 / scrollView.zoomScale) * (image!.size.width / scrollView.bounds.width)
        
        // vertical scaling factor
        let scaleh = (1 / scrollView.zoomScale) * (image!.size.height / scrollView.bounds.height)
        let visibleRect = CGRectMake(scrollView.contentOffset.x * scalew, scrollView.contentOffset.y * scaleh, scrollView.bounds.size.width * scalew, scrollView.bounds.size.height * scaleh)
        let ref: CGImageRef = CGImageCreateWithImageInRect(image!.CGImage, visibleRect)!
        return UIImage(CGImage: ref)
        
    }

    // Prepare to write to DB
    private func savePostcard() {
        
        let newImage = getNewImage()
        if image != nil {
            if let imageData = UIImageJPEGRepresentation(newImage, 1.0),
                let documentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first {
                    let unique = "\(NSDate.timeIntervalSinceReferenceDate()).jpg"
                    let url = documentsDirectory.URLByAppendingPathComponent(unique)
                    if imageData.writeToURL(url, atomically: true) {
                        writePostcardToDb(unique)
                    }
            }
        } else {
            print("Image did not save!")
        }
    }
    
    // Write new postcard object to DB
    private func writePostcardToDb(url: String) {
        
        func cb(p: Postcard) {
            performSegueWithIdentifier("postcardTextViewSegue", sender: self)
        }
        
        if let context = AppDelegate.managedObjectContext {
            context.performBlock {
                self.postcard = Postcard.createWithImageUrl(url, inManagedContext: context, callback: cb)
            }
        }
    }
    
    @IBAction func selectPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .PhotoLibrary
            picker.mediaTypes = [kUTTypeImage as String]
            picker.allowsEditing = false
            picker.delegate = self
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // ensure all images are landscape to fit the postcard layout
    func getRotatedImage(img: UIImage) -> UIImage {
        if (img.imageOrientation == UIImageOrientation.Up || img.imageOrientation == UIImageOrientation.Down) {
            return img.imageRotatedByDegrees(90, flip: false)
        }
        return img
    }
    
    // add image to scroll view for cropping and editing
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {

        self.image = getRotatedImage(image)
        
        // ensure image is scaled to fit in the initial scroll window
        imageView.frame = CGRect(origin: CGPointZero, size: scrollView.frame.size)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func doneKeyboard() {
        filterSelectField.resignFirstResponder()
    }
    
    func cancelKeyboard() {
        filterSelectField.resignFirstResponder()
    }
    
    func applySepiaFilter(ci_image: CIImage) -> CIImage {
        let filter = CIFilter(name: "CISepiaTone")!
        filter.setValue(ci_image, forKey: kCIInputImageKey)
        filter.setValue(0.9, forKey:  kCIInputIntensityKey)
        return filter.outputImage!

    }
    
    // adapted from: http://www.raywenderlich.com/76285/beginning-core-image-swift
    func applyVintageFilter(ci_image: CIImage) -> CIImage {
        let intensity = 0.9
        // 1
        let sepia = CIFilter(name:"CISepiaTone")!
        sepia.setValue(ci_image, forKey:kCIInputImageKey)
        sepia.setValue(intensity, forKey:"inputIntensity")
        
        // 2
        let random = CIFilter(name:"CIRandomGenerator")!
        
        // 3
        let lighten = CIFilter(name:"CIColorControls")!
        lighten.setValue(random.outputImage!, forKey:kCIInputImageKey)
        lighten.setValue(1 - intensity, forKey:"inputBrightness")
        lighten.setValue(0, forKey:"inputSaturation")
        
        // 4
        let croppedImage = lighten.outputImage!.imageByCroppingToRect(ci_image.extent)
        
        // 5
        let composite = CIFilter(name:"CIHardLightBlendMode")!
        composite.setValue(sepia.outputImage!, forKey:kCIInputImageKey)
        composite.setValue(croppedImage, forKey:kCIInputBackgroundImageKey)
        
        // 6
        let vignette = CIFilter(name:"CIVignette")!
        vignette.setValue(composite.outputImage!, forKey:kCIInputImageKey)
        vignette.setValue(intensity * 2, forKey:"inputIntensity")
        vignette.setValue(intensity * 30, forKey:"inputRadius")
        
        // 7
        return vignette.outputImage!
    }
    
    func applyBWFilter(ci_image: CIImage) -> CIImage {
        let filter = CIFilter(name: "CIColorControls")!
        
        filter.setValue(ci_image, forKey: kCIInputImageKey)
        filter.setValue(0.0, forKey: "inputBrightness")
        filter.setValue(1.1, forKey: "inputContrast")
        filter.setValue(0.0, forKey: "inputSaturation")
        return filter.outputImage!
    }
    
    // TODO: add more complex filters
    private func applyFilter(name: String) {
        let ci_image = CIImage(image: image!)!
        var new_ci_image: CIImage?
        switch name {
            case filterOptions[0]:
                new_ci_image = applySepiaFilter(ci_image)
            case filterOptions[1]:
                new_ci_image = applyBWFilter(ci_image)
            case filterOptions[2]:
                new_ci_image = applyVintageFilter(ci_image)
        default:
            return
        }
        
        let cg_image = CIContext().createCGImage(new_ci_image!, fromRect: new_ci_image!.extent)
        image = UIImage(CGImage: cg_image)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide elements that require photo to be selected
        nextButton.hidden = true
        filterButton.hidden = true
        filterSelectField.hidden = true
        
        scrollView.addSubview(imageView)
        filterPickerView.showsSelectionIndicator = true
        filterPickerView.delegate = self
        filterSelectField.inputView = filterPickerView
        
        filterSelectField.inputAccessoryView = createToolbar()
    }
    
    // MARK: Picker View Delegate Functions
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filterOptions.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filterOptions[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let filterName = filterOptions[row]
        applyFilter(filterName)
    }
}

