Pod::Spec.new do |s|
  s.name             = 'NMEasyTipView'
  s.version          = '1.1'
  s.summary          = 'Fully customisable tooltip view for iOS.'

  s.description      = <<-DESC
Objective-C alternative for EasyTipView implemented swift.
                       DESC

  s.homepage         = 'https://github.com/nitishmakhija/EasyTipView'
  s.license          = { :type => 'MIT', :file => 'License.md' }
  s.author           = { 'Nitish Makhija' => 'nitishmakhija@gmail.com' }
  s.source           = { :git => 'https://github.com/nitishmakhija/EasyTipView.git', :tag => '1.1' }

  s.ios.deployment_target = '8.0'
  s.source_files = 'Source/*'

end
