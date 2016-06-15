Pod::Spec.new do |s|

  s.name = 'ActivityKit'
  s.version = '1.0.2'
  s.summary = 'Custom application activities for iOS.'
  s.homepage = 'https://github.com/ccrazy88/activity-kit'
  s.author = { 'Chrisna Aing' => 'chrisna@udacity.com' }
  s.source = { :git => 'https://github.com/ccrazy88/activity-kit.git',
               :tag => s.version.to_s }
  s.license = { :type => 'MIT', :file => 'LICENSE' }

  s.platform = :ios, '8.0'
  s.frameworks = 'Foundation'

  s.source_files = 'Sources/ActivityKit/**/*.{h,m,swift}'

end
