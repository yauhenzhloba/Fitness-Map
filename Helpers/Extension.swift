

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingCatchWithUrlString(urlString: String) {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage{
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            
            
            DispatchQueue.main.async {
                
                if let downloadImage = UIImage(data: data!) {
                    
                    imageCache.setObject(downloadImage, forKey: urlString as NSString)
                    self.image = downloadImage
                    print("ASYNC")
                }
                
                //self.image = UIImage(data: data!)
                //self.tableView.reloadData()
            }
            //cell.imageViewMsg?.image = UIImage(data: data!)
            
            
        }).resume()
        
    }
    
}
