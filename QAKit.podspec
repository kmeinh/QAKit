Pod::Spec.new do |s|
  s.name         = "QAKit"
  s.module_name  = "QAKit"
  s.version      = "0.0.3"
  s.license      = "MIT"
  s.summary      = "QAKit provides handy functions to make QA easier."
  s.homepage     = "https://github.com/konDeichmann/QAKit"
  s.author       = { "Konstantin Deichmann" => "k.deichmann@mac.com" }
  s.source       = { :git => "https://github.com/konDeichmann/QAKit.git", :tag => "0.0.3" }

  s.ios.deployment_target = "8.0"

  s.source_files  = "QAKit/**/*.swift"

  s.requires_arc = true
end