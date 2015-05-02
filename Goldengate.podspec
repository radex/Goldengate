Pod::Spec.new do |s|
  s.name = 'Goldengate'
  s.version = '0.0.1'
  s.license = 'MIT'
  s.summary = 'Bridging Swift and JavaScript worlds'
  s.homepage = 'https://github.com/radex/Goldengate'
  s.authors = { 'Radek Pietruszewski' => 'this.is@radex.io' }
  s.source = { :git => 'https://github.com/radex/Goldengate.git', :tag => s.version.to_s }
  
  s.requires_arc = true
  # s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'

  s.source_files = 'Goldengate/*.{swift,m,h}'
  s.framework = 'WebKit'
  s.framework = 'Cocoa'
end