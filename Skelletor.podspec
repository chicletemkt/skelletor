# coding: utf-8
Pod::Spec.new do |s|
  s.name         = "Skelletor"
  s.version      = "1.0.4"
  s.summary      = "A set of small routines to speed-up development."
  s.description  = <<-DESC
Skelletor is a set of classes that implements several boiler plate code used
for different scenarios. Those classes are as much generalized as possible and
are designed so you don't have to rewrite it all over and over again.
                   DESC
  s.homepage     = "https://github.com/chicletemkt/skelletor"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Ronaldo Faria Lima" => "ronaldo@chicletemkt.com" }
  s.social_media_url   = "http://twitter.com/ron_lima"
  s.platform     = :ios, "11.0"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
  s.source       = { :git => "https://github.com/chicletemkt/skelletor.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "Skelletor/**/*.{swift}"
  s.exclude_files = "Classes/Exclude"
  s.ios.frameworks = "UIKit", "Foundation", "AVFoundation", "CoreData", "MediaPlayer"
end
