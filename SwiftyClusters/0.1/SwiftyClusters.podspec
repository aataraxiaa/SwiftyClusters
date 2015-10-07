Pod::Spec.new do |s|
 
  # 1
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.name = "SwiftyClusters"
  s.summary = "SwiftyClusters - Add annotation clustering to any iOS Map"
  s.requires_arc = true
 
  # 2
  s.version = "0.1"
 
  # 3
  s.license = { :type => "MIT", :file => "LICENSE" }
 
  # 4 - Replace with your name and e-mail address
  s.author = { "Pete Smith" => "peadar81@gmail.com" }

 
  # 5 - Replace this URL with your own Github page's URL (from the address bar)
  s.homepage = "https://github.com/superpeteblaze/SwiftyClusters"
 
  # 6 - Replace this URL with your own Git URL from "Quick Setup"
  s.source = { :git => "https://github.com/superpeteblaze/SwiftyClusters.git", :tag => "#{s.version}"} 
 
  # 7
  s.framework = "MapKit"
  
  # 8
  s.source_files = "SwiftyClusters/**/*.{swift}"

end