//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

var str = "Hello, playground"

typealias Filter = CIImage -> CIImage

typealias Parameters = Dictionary<String, AnyObject>

extension CIFilter {
    convenience init(name: String, parameters: Parameters){
        self.init(name: name)!
        setDefaults()
        for(key, value: AnyObject) in parameters {
            setValue(AnyObject, forKey: key)
        }
    }
    
    var outPutImage: CIImage {
        return self.valueForKey(kCIOutputImageKey) as! CIImage
    }
}


// For blur
func blur(radius: Double) -> Filter {
    return { image in
        let parameters: Parameters = [
            kCIInputRadiusKey: radius,
            kCIInputImageKey: image,
        ]
        let newImage =  CIFilter(name: "CIGUssianBlurr", parameters: parameters)
        return newImage.outPutImage
    }
}

// Color overlay

func colorGenerator(color: UIColor) -> Filter{
    return { _ in
        let params: Parameters = [kCIInputColorKey: color]
        let newImage = CIFilter(name: "colrOverlay", parameters: params)
        
        return newImage.outPutImage
        
    }
}

// composite source function

func compositeSource(overlay: CIImage) -> Filter {
    return { image in
        let parameters: Parameters = [kCIInputImageKey: image,
                                      kCIInputBackgroundImageKey: overlay]
        let newImage = CIFilter(name: "Overlay", parameters: parameters)
        let cropImage = image.extent
        return newImage.outPutImage.imageByCroppingToRect(cropImage)
    }
}

//overlay with colors

func colorOverlay(color: UIColor) -> Filter {
    return  { image in
        let colorImage: CIImage = colorGenerator(color)(image)
        return compositeSource(colorImage)(image)
    }
}

let url: NSURL = NSURL(string: "https://lh4.googleusercontent.com/-YCRFnjDOiwk/AAAAAAAAAAI/AAAAAAAAAAA/akhx39n7XyA/photo.jpg")!

let image: CIImage! = CIImage(contentsOfURL: url)

let blurRadius = 1.0
let blueColr = UIColor.blueColor().colorWithAlphaComponent(0.2)
// let blurredImage = colorOverlay(blueColr)(image)

let uiImage = UIImage(CIImage: image)

let imageView = UIImageView(image: uiImage)

let bounds = imageView.bounds
let view = UIView(frame: bounds)
view.backgroundColor = UIColor.lightGrayColor()
view.addSubview(imageView)
//XCPShowView("oneview", view: view)
//XCPShowView("2", view: view)

XCPlaygroundPage.currentPage.liveView = view

infix operator >>> { associativity left }
func >>> (op: Double, op2: Double ) -> Double {
    return op * op2
}

print(68.1 >>> 70.2)
