//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var filteredImage: UIImage?
    var currentFilterString: String = "Brightness"
    var showingFiltered = false
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var originalView: UIImageView!
    
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet var sliderView: UIView!
    
    @IBOutlet var slider: UISlider!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var compareButton: UIButton!
    
    @IBOutlet var textOriginal: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        sliderView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        let lpgr = UILongPressGestureRecognizer(target: self, action: "imagePressed:")
        let lpgr2 = UILongPressGestureRecognizer(target: self, action: "imagePressed:")
        lpgr.minimumPressDuration = 0.1;
        lpgr2.minimumPressDuration = 0.1
        
        imageView.addGestureRecognizer(lpgr)
        originalView.addGestureRecognizer(lpgr2)
    }

    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            originalView.image = image
            compareButton.selected = false
            compareButton.enabled = false
            editButton.selected = false
            editButton.enabled = false
            hideSliderView()
            showOriginal()
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onCompare(sender: UIButton) {
        if (sender.selected) {
            showFiltered()
            sender.selected = false
        } else {
        
            showOriginal()
            sender.selected = true
        }
    }
    
    func showOriginal() {
        UIView.animateWithDuration(0.4, animations: {
            self.textOriginal.alpha = 1
            self.originalView.alpha = 1
            }) { _ in}
        showingFiltered = false
    }
    
    func showFiltered() {
        originalView.alpha = 1
        UIView.animateWithDuration(0.4, animations: {
            self.originalView.alpha = 0
            self.textOriginal.alpha = 0
            }) { _ in}
        showingFiltered = true

    }
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        if (editButton.selected) {
            hideSliderView()
            editButton.selected = false
            
        }

        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }

    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }
    
    @IBAction func onEdit(sender: UIButton) {
        if (sender.selected) {
            hideSliderView()
            sender.selected = false
        } else {
            showSliderView()
            sender.selected = true
        }

    }
    func showSliderView() {
        view.addSubview(sliderView)
        
        if (filterButton.selected) {
            hideSecondaryMenu()
            filterButton.selected = false

        }
        
        let bottomConstraint = sliderView.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = sliderView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = sliderView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = sliderView.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.sliderView.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.sliderView.alpha = 1.0
        }
    }
    
    func hideSliderView() {
        UIView.animateWithDuration(0.4, animations: {
            self.sliderView.alpha = 0
            }) { completed in
                if completed == true {
                    self.sliderView.removeFromSuperview()
                }
        }
    }
    
    
    @IBAction func onContrast(sender: UIButton) {
        
        let myRGBA = RGBAImage(image: originalView.image!)!
        let imageProcessor = ImageProcessor(image:myRGBA)
        
        imageProcessor.applyFilters([imageProcessor.contrast], magnitudes:[1.0])
        imageView.image = myRGBA.toUIImage()
        //var currentFilter = imageProcessor.contrast
        showFiltered()
        
        if (!compareButton.enabled || !editButton.enabled) {
            compareButton.enabled = true
            editButton.enabled = true
        }
        currentFilterString = "Contrast"
        slider.value = 1.0
    }
    
    @IBAction func onBrightness(sender: UIButton) {
        let myRGBA = RGBAImage(image: originalView.image!)!
        let imageProcessor = ImageProcessor(image:myRGBA)
        
        imageProcessor.applyFilters([imageProcessor.brightness], magnitudes:[1.5])
        imageView.image = myRGBA.toUIImage()
        showFiltered()
        
        if (!compareButton.enabled || !editButton.enabled) {
            compareButton.enabled = true
            editButton.enabled = true
        }
        currentFilterString = "Brightness"
        slider.value = 1.5
    }
    
    @IBAction func onGrayscale(sender: UIButton) {
        let myRGBA = RGBAImage(image: originalView.image!)!
        let imageProcessor = ImageProcessor(image:myRGBA)
        
        imageProcessor.applyFilters([imageProcessor.grayscale], magnitudes:[1.0])
        imageView.image = myRGBA.toUIImage()
        showFiltered()
        
        if (!compareButton.enabled || !editButton.enabled) {
            compareButton.enabled = true
            editButton.enabled = true
        }
        
        
        currentFilterString = "Grayscale"
        slider.value = 1.0
    }
        
    @IBAction func onNegative(sender: UIButton) {
        let myRGBA = RGBAImage(image: originalView.image!)!
        let imageProcessor = ImageProcessor(image:myRGBA)
        
        imageProcessor.applyFilters([imageProcessor.negative], magnitudes:[1.0])
        imageView.image = myRGBA.toUIImage()
        showFiltered()
        
        if (!compareButton.enabled || !editButton.enabled) {
            compareButton.enabled = true
            editButton.enabled = true
        }
        currentFilterString = "Negative"
        slider.value = 1.0
    }
    
    @IBAction func onEnhance(sender: UIButton) {
        let myRGBA = RGBAImage(image: originalView.image!)!
        let imageProcessor = ImageProcessor(image:myRGBA)
        
        imageProcessor.applyFilters([imageProcessor.enhance], magnitudes:[1.0])
        imageView.image = myRGBA.toUIImage()
        showFiltered()
        
        if (!compareButton.enabled || !editButton.enabled) {
            compareButton.enabled = true
            editButton.enabled = true
        }
        currentFilterString = "Enhance"
        slider.value = 1.0
    }
    
    func imagePressed(gestureRecognizer:UIGestureRecognizer) {
        if (compareButton.enabled) {
            if (gestureRecognizer.state != UIGestureRecognizerState.Ended) {
                if (showingFiltered) {
                    showOriginal()
                } else {
                    showFiltered()
                }

            } else {
                if (showingFiltered) {
                    showOriginal()
                } else {
                    showFiltered()
                }
            }
        }
    }
    
    @IBAction func sliderChanged(sender: UISlider) {
       
        let myRGBA = RGBAImage(image: originalView.image!)!
        let imageProcessor = ImageProcessor(image:myRGBA)
        
        let Dict = ["Contrast" : imageProcessor.contrast,
            "Brightness" : imageProcessor.brightness,
            "Negative" : imageProcessor.negative,
            "Grayscale" : imageProcessor.grayscale,
            "Enhance" : imageProcessor.enhance]
        let currentFilter = Dict[currentFilterString]
        
        

        imageProcessor.applyFilters([currentFilter!], magnitudes: [Double(sender.value)])
        
        imageView.image = myRGBA.toUIImage()
        showFiltered()
    }
    
    
}

