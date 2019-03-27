 import UIKit
 class SecondViewController: CDVViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        self.webView.frame = CGRect(
            x: self.view.bounds.origin.x,
            y: self.view.bounds.origin.y+40,
            width: self.view.bounds.width,
            height: self.view.bounds.height-40)
    }
 }
