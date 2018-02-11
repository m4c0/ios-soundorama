Pod::Spec.new do |spec|
  spec.name = 'Soundorama'
  spec.version = '0.0.1'
  spec.summary = 'An old iOS library to wrap some audio related stuff'
  spec.homepage = 'https://github.com/m4c0/ios-soundorama'
  spec.license = { :type => 'GPLv3', :file => 'LICENSE' }
  spec.author = {
    'Eduardo Costa' => 'm4c0@github.com',
  }
  spec.source = { :git => 'https://github.com/m4c0/ios-soundorama.git', :tag => "v#{spec.version}" }
  spec.source_files = 'Soundorama/*.{h,m}'
  spec.requires_arc = true
  spec.ios.deployment_target = '6.0'
  spec.dependency 'MoCategories', '0.0.1'
end


