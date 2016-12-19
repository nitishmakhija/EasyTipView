Pod::Spec.new do |s|

    s.name              = 'RCEasyTipView'
    s.version           = '1.0.0'
    s.summary           = 'Elegant tooltip view written in Objective-C'
    s.homepage          = 'https://github.com/nitishmakhija/EasyTipView'
    s.license           = {
        :type => 'MIT',
    }
    s.author            = {
        'Nitish Makhija' => 'nitishmakhija@gmail.com'
    }
    s.source            = {
        :git => 'https://github.com/nitishmakhija/EasyTipView.git',
        :tag => s.version
    }
    s.source_files      = 'Source/*'
    s.requires_arc      = true

end
