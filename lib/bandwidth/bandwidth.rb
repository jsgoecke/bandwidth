class Bandwidth 
  # Available REST API methods
  API_METHODS = [ :get_telephone_number,
                  :get_number_order,
                  :get_number_orders,
                  :area_code_number_search,
                  :npa_nxx_number_search,
                  :rate_center_number_search,
                  :rate_center_number_order,
                  :tollfree_number_search,
                  :basic_number_order,
                  :change_number,
                  :sip_trunk_order,
                  :consumed_numbers,
                  :reserve_numbers,
                  :pbod,
                  :rate_center_block_order,
                  :get_rate_center_block_order,
                  :get_rate_center_block_orders,
                  :get_cdr_archive ]

  ##
  # Instantiate a Bandwdith object
  #
  # @param [required, Hash] params 
  # @option params [required, String] :developer_key assigned to you by Bandwidth
  # @option params [optional, Boolean] :processing_type whether to 'process' the request or only 'validate', default is 'process'
  # @option params [optional, Symbol] :log_level which level to set the logging at, off by default
  # @option params [optional, Boolean] :use_lab_uris if true, will use the Bandwidth Lab URIs rather than production
  # @return [Object] the instantiated Bandwdith object
  # @raise ArgumentError when the :developer_key is not present
  # @example Instantiate a Bandwdith object
  #   require 'rubygems'
  #   require 'bandwidth'
  #   bandwdith = Bandwidth.new(:developer_key => 'test')
  def initialize(params)
    raise ArgumentError, ":developer_key required" if params[:developer_key].nil?      
    
    if params[:log_level]
      HTTPI.log_level = params[:log_level]
    else
      HTTPI.log = false
    end
    
    @use_labs_uris   = params[:use_lab_uris] || false
    @developer_key   = params[:developer_key]
    @numbers_request = create_request(:numbers, params)
    @cdrs_request    = create_request(:cdrs, params)
  end
  
  ##
  # Provides the dispatcher to the available REST methods on the Bandwidth API
  #
  # @param [required, Symbol] the method name to invoke on the REST API
  # @param [optional, Hash] the parameters to pass to the method, should be symbols and may be all lowercase with underscores or camelCase
  # @return [Hashie::Mash Object] containing the results of the REST call
  # @raise NoMethodError if the method requested is not defined in the API_METHODS constant
  # @example Retrieve numbers available in an area code
  #   bandwidth.area_code_number_search :area_code => '720', :max_quantity => 10
  def method_missing(method_name, params={})
    raise NoMethodError, "The method #{method_name.to_s} does not exist." if API_METHODS.include?(method_name) == false
    
    if method_name == :get_cdr_archive
      @cdrs_request.body = build_xml(method_name, params)
                                                                   
      response = HTTPI.post @cdrs_request
      Hashie::Mash.new({ :code    => response.code,
                         :body    => response.raw_body,
                         :headers => response.headers })
    else
      @numbers_request.body = build_xml(method_name, params)                                  
      response = HTTPI.post @numbers_request
      Hashie::Mash.new({ :code    => response.code,
                         :body    => Crack::XML.parse(response.raw_body),
                         :headers => response.headers })
    end
  end
  
  ##
  # Builds the XML document for the method call
  #
  # @param [required, Symbol] the method name to invoke on the REST API
  # @param [optional, Hash] the parameters to pass to the method, should be symbols and may be all lowercase with underscores or camelCase
  # @return [String] the resulting XML document
  def build_xml(method_name, params)
    builder_params = params.merge({ :developer_key => @developer_key })
    
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.send(method_name.to_s.camelize.uncapitalize.to_sym, xml_namespaces) do
        builder_params.each do |parent_k, parent_v|
          if parent_v.instance_of?(Array)
            xml.send(parent_k.to_s.camelize.uncapitalize.to_sym) do
              parent_v.each do |item|
                item.each do |item_k, item_v|
                  symbol = (item_k.to_s + '_').to_sym
                  xml.send(symbol, item_v)
                end
              end
            end
          else
            xml.send(parent_k.to_s.camelize.uncapitalize.to_sym, parent_v)
          end
        end
      end
    end
    builder.to_xml
  end
  
  private
  
  ##
  # Creates the request
  #
  # @param [required, Symbol] type indicates if it is to create a :numbers request or a :cdrs request
  # @param [required, Hash] params to build the request with
  # @return [Object] the resulting request object
  def create_request(type, params)
    request = HTTPI::Request.new
    
    # Right now Bandwidth's Lab does not support SSL, but their production does
    if @use_labs_uris != true
      request.ssl                  = true
      request.auth.ssl.verify_mode = :none
    end
    
    request.headers = { 'Content-Type'                     => 'text/xml',
                        'X-BWC-IN-Control-Processing-Type' => params[:processing_type] || 'process' }
    
    if type == :numbers
      if @use_labs_uris == true
        request.url = 'http://labs.bandwidth.com/api/public/v2/numbers.api'
      else
        request.url = 'https://api.bandwidth.com/public/v2/numbers.api'
      end
    elsif type == :cdrs
      if @use_labs_uris == true
        request.url = 'http://labs.bandwidth.com/api/public/v2/cdr.api'
      else
        request.url = 'https://api.bandwidth.com/api/public/v2/cdrs.api'
      end
    end
    
    request
  end
  
  ##
  # Provides the required XML namespace details for the Bandwidth API
  #
  # @param [required, Symbol] method_name to add the XML namespace details to
  # @return [Hash] the resulting XML namespace attributes
  def xml_namespaces
    { 'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
      'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema',
      'xmlns'     => 'http://www.bandwidth.com/api/' }
  end
end