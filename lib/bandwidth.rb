$: << File.expand_path(File.dirname(__FILE__))
%w(savon hashie bandwidth/bandwidth).each { |lib| require lib }