Pod::Spec.new do |s|
  s.name         = "KIRefreshView"
  s.version      = "0.1.1"
  s.summary      = "KIRefreshView"

  s.description  = <<-DESC
                   KIRefreshView.
                   DESC

  s.homepage     = "https://github.com/smartwalle/KIRefreshView"
  s.license      = "MIT"
  s.author       = { "SmartWalle" => "smartwalle@gmail.com" }
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/smartwalle/KIRefreshView.git", :branch => "master" }
  s.source_files  = "KIRefreshView/KIRefreshView/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.resources     = "KIRefreshView/KIRefreshView/*.png"
  s.requires_arc  = true
end
