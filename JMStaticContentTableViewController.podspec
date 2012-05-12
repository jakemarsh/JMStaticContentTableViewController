Pod::Spec.new do |s|
	s.name 			= 'JMStaticContentTableViewController'
	s.version 	= '0.0.1'
	s.license  	= 'MIT'
  s.summary 	= 'A subclass-able way to cleanly and neatly implement a table view controller much like those in Settings.app, with nice-looking fields to collect or display information.'
  s.homepage 	= 'https://github.com/jakemarsh/JMStaticContentTableViewController'
  s.authors 	= { 'Jake Marsh' => 'jake@deallocatedobjects.com' }
  s.source 		= { :git => 'git://github.com/jakemarsh/JMStaticContentTableViewController.git', :tag => '0.0.1' }

  s.platform  = :ios

  s.source_files = ['JMStaticContentTableViewController/JMStaticContentTableViewBlocks.h', 'JMStaticContentTableViewController/JMStaticContentTableViewController.*', 'JMStaticContentTableViewController/JMStaticContentTableViewSection.*', 'JMStaticContentTableViewController/JMStaticContentTableViewCell.*', 'JMStaticContentTableViewController/StaticTextFieldTableViewCell.*']
end