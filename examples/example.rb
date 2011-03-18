require 'rubygems'
require 'lib/bandwidth'
require 'awesome_print'

bandwidth = Bandwidth.new(:developer_key   => 'your developer key', :use_lab_uris => true)

ap bandwidth.area_code_number_search :area_code => '720', :max_quantity => 1
