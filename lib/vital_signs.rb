module VitalSigns
end

require 'active_support/core_ext/class'
require 'active_support/core_ext/hash'
require 'active_support/cache'
$libdir = File.join( File.dirname(__FILE__), 'vital_signs' )
require File.join( $libdir, 'sensors' )
require File.join( $libdir, 'config' )

if defined? Rails
  require File.join( $libdir, 'engine' )
else
end

