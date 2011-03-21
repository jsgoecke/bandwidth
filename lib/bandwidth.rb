$: << File.expand_path(File.dirname(__FILE__))
%w(nokogiri crack httpi hashie bandwidth/bandwidth bandwidth/string_patch).each { |lib| require lib }