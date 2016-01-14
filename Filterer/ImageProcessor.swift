import UIKit

//Constants for array positions
let RED = 0
let GREEN = 1
let BLUE = 2

public struct ImageProcessor {
    
    public var image:RGBAImage
    public var averageColour = [0.0, 0.0, 0.0]
    //public var currentFilter = ImageProcessor.brightness
    public init (image:RGBAImage) {
        self.image = image
        //self.currentFilter =
        //calculate average colour for increaseDiff
        calculateAvg(image)
    }
    
    //Applies filters based on their order in filters with respective magnitudes.
    public func applyFilters (filters:[(Pixel, magnitude: Double) -> Pixel], magnitudes:[Double]) {
        
        for x in 0..<image.width {
            for y in 0..<image.height {
                let index = y * image.width + x
                var pixel = image.pixels[index]
                for i in 0..<filters.count {
                    pixel = filters[i](pixel, magnitude: magnitudes[i])
               }
               image.pixels[index] = pixel
            }
        }
        //currentFilter = filters.last!
    }
    
    //Sends appropriate input to applyFilters using the dictionary filterDict
    public func applyPredefined (filters:[String]) {
        let filterDict = ["Contrast x 2" : contrast,
                          "Brightness + 50" : brightness,
                          "Negative x 1" : negative,
                          "Grayscale x 1" : grayscale,
                          "Enhance x 2" : enhance]
        
        var filterList:[((Pixel, magnitude:Double) -> Pixel)] = []
        var magnitudeList = [Double]()
        for i in 0..<filters.count {
            filterList.append(filterDict[filters[i]]!)
            magnitudeList.append(Double(filters[i].componentsSeparatedByString(" ").last!)!)
        }
        applyFilters(filterList, magnitudes: magnitudeList)
    }
    
    //initialize the list averageColour with avgRed, avgGreen, and avgBlue
    public mutating func calculateAvg (image:RGBAImage) {
        let count = Double(image.width * image.height)
        
        for x in 0..<image.width {
            for y in 0..<image.height {
                let index = y * image.width + x
                var pixel = image.pixels[index]
                averageColour[RED] += Double(pixel.red)/count
                averageColour[GREEN] += Double(pixel.green)/count
                averageColour[BLUE] += Double(pixel.blue)/count
            }
        }
    }
    
    //Returns a pixel with modified brightness
    public func brightness (var pixel:Pixel, magnitude:Double) -> Pixel {
        let newMag = 100*(magnitude - 1.0)
        pixel.red = UInt8(max(0, min(255, newMag + Double(pixel.red))))
        pixel.green = UInt8(max(0, min(255, newMag + Double(pixel.green))))
        pixel.blue = UInt8(max(0, min(255, newMag + Double(pixel.blue))))
        return pixel
    }
    
    //Returns a pixel with modified contrast
    public func contrast (var pixel:Pixel, magnitude:Double) -> Pixel {
        let newMag = 2 * magnitude
        pixel.red = UInt8(max(0, min(255, newMag * Double(pixel.red))))
        pixel.green = UInt8(max(0, min(255, newMag * Double(pixel.green))))
        pixel.blue = UInt8(max(0, min(255, newMag * Double(pixel.blue))))
        return pixel
    }
    
    //An extension of the filter from week 4
    public func enhance (var pixel:Pixel, magnitude:Double) -> Pixel {
        let newMag = 2 * magnitude
        var diff = [Double(pixel.red), Double(pixel.green), Double(pixel.blue)]
        for i in 0..<diff.count {
            diff[i] -= averageColour[i]
            if (abs(diff[i]) > 0) {
                
                switch i {
                case 0: pixel.red = UInt8(max(0, min(255, averageColour[i] + newMag * diff[i])))
                case 1: pixel.green = UInt8(max(0, min(255, averageColour[i] + newMag * diff[i])))
                case 2: pixel.blue = UInt8(max(0, min(255, averageColour[i] + newMag * diff[i])))
                default: break
                }
            }
        }
        return pixel
    }
    
    //Returns a grayscale pixel
    public func grayscale(var pixel:Pixel, magnitude:Double) -> Pixel {
        let newMag = magnitude
        /*constants from grayscale algorithm from http://www.cs.uregina.ca/Links/class-info/325/PythonPictures/ */
        let weightRed = 0.299
        let weightGreen = 0.587
        let weightBlue = 0.114
        
        let luminance = UInt8(max(0, min(255, newMag * (Double(pixel.red) * weightRed + Double(pixel.green) * weightGreen + Double(pixel.blue) * weightBlue))))
        
        pixel.red = luminance
        pixel.green = luminance
        pixel.blue = luminance
        
        return pixel
    }
    
    // Returns a pixel with negative colour
    public func negative(var pixel:Pixel, magnitude:Double) -> Pixel {
        let newMag = magnitude
        pixel.red = UInt8(max(0, min(255, 255 - newMag * Double(pixel.red))))
        pixel.green = UInt8(max(0, min(255, 255 - newMag * Double(pixel.green))))
        pixel.blue = UInt8(max(0, min(255, 255 - newMag * Double(pixel.blue))))
        
        return pixel
    }
    
//    public func changeMagnitude (mag: Double) {
//        //var currentFilter = contrast
//        //print "\(currentFilter)"
//        for x in 0..<image.width {
//            for y in 0..<image.height {
//                let index = y * image.width + x
//                var pixel = image.pixels[index]
//                pixel = currentFilter(pixel, magnitude: mag)
//                image.pixels[index] = pixel
//            }
//        }
//
//    }
}

