Pod::Spec.new do |s|
  s.name         = "Attachment"
  s.version      = "1.0.0"
  s.summary      = "Use NSAttributedString to add subviews to UILabel or UITextView."
  s.homepage     = "https://github.com/iLiuChang/Attachment"
  s.license      = "MIT"
  s.authors      = { "iLiuChang" => "iliuchang@foxmail.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/iLiuChang/Attachment.git", :tag => s.version }
  s.requires_arc = true
  s.swift_version = "5.0"
  s.source_files = "Source/*.{swift}"
end
