require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Bandwidth" do
  before(:each) do
    # You will need to set the environment variable BANDWIDTH_DEVELPOR_KEY to a valid one from Bandwidth in order to run a test
    @bandwidth = Bandwidth.new({ :developer_key => ENV['BANDWIDTH_DEVELOPER_KEY'],
                                 :use_lab_uris  => true,
                                 :log_level     => :debug })
  end
  
  describe "string patch" do
    it 'should camelize a string' do
      "foo_bar".camelize.should == 'FooBar'
    end
    
    it 'should uncapitalize a string' do
      "FooBar".uncapitalize.should == 'fooBar'
    end
    
    it 'should camelize and uncapitlize a string' do
      "foo_bar".camelize.uncapitalize.should == 'fooBar'
    end
    
    it 'should leave the ID alone' do
      "foobar_IDs".camelize.uncapitalize.should == 'foobarIDs'
    end
  end
  
  describe "numbers" do
    it "should instantiate a Bandwidth::Numbers class" do
      @bandwidth.instance_of?(Bandwidth).should == true
    end
    
    it "should raise a no method error if an unknown method is called" do
      begin
        @bandwidth.foobar
      rescue => error
        error.class.should == NoMethodError
        error.to_s.should  == "The method foobar does not exist."
      end
    end
        
    it "should get a response when searching for area codes" do
      result = @bandwidth.area_code_number_search :area_code => '720', :max_quantity => 10
      result[:body]['numberSearchResponse'].nil?.should == false 
    end
    
    it "should get a response when searching for area codes when params passed as camelCase too" do
      result = @bandwidth.area_code_number_search :areaCode => '720', :maxQuantity => 10
      result[:body]['numberSearchResponse'].nil?.should == false 
    end
    
    it "should return the result body as a Hashie::Mash class" do
      result = @bandwidth.area_code_number_search :area_code => '720', :max_quantity => 10
      result[:body].instance_of?(Hashie::Mash).should == true
    end
    
    it "should get a response when searching by area code and prefix (aka - NPA and NXX)" do
      result = @bandwidth.npa_nxx_number_search(:npa_nxx => '720263')
      result[:body][:numberSearchResponse].nil? == false
    end
    
    it "should get a response when searching for a toll free number" do
      result = @bandwidth.tollfree_number_search :max_quantity => 10
      result.body.numberSearchResponse.nil?.should == false
    end
    
    it "should get a response when retrieving for a number order" do
      result = @bandwidth.get_number_order(:get_type => 'orderID', :get_value => 'C2594E54-015A-4D4E-81A8-F05B76610877')
      result.body.getResponse.nil?.should == false
    end
  end
  
  describe "cdrs" do
    it "should get a resopnse when retrieving cdrs" do
      result = @bandwidth.get_cdr_archive(:get_type => 'Daily', :get_value => '20110221')
      result['headers']['Content-Type'].should == 'application/zip'
    end
  end
  
  describe "xml builder" do
    it "should build a valid area code search XML document" do
      params = { :npa_nxx => '303', :max_quantity => '3' } 
      result = @bandwidth.build_xml(:area_code_number_search, params)
      Crack::XML.parse(result).should == {
                                              "areaCodeNumberSearch" => {
                                                  "developerKey" => ENV['BANDWIDTH_DEVELOPER_KEY'],
                                                     "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
                                                   "maxQuantity" => "3",
                                                        "npaNxx" => "303",
                                                     "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                                                         "xmlns" => "http://www.bandwidth.com/api/"
                                              }
                                          }
    end
    
    it "should build a valid basic number order document" do
      params = { :order_name => 'Foobar 0',
                 :ext_ref_ID => 'Foobar 1',
                 :number_IDs => [ { :id => '1' }, { :id => '2' }],
                 :subscriber => 'Tropo',
                 :end_points => { :host => 'sip.tropo.com' } } 
      result = @bandwidth.build_xml(:basic_number_order, params)

      Crack::XML.parse(result).should == {
                                             "basicNumberOrder" => {
                                                 "developerKey" => ENV['BANDWIDTH_DEVELOPER_KEY'],
                                                   "subscriber" => "Tropo",
                                                    "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
                                                     "extRefID" => "Foobar 1",
                                                    "orderName" => "Foobar 0",
                                                    "numberIDs" => {
                                                     "id" => [
                                                         "1",
                                                         "2"
                                                     ]
                                                 },
                                                    "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                                                        "xmlns" => "http://www.bandwidth.com/api/",
                                                    "endPoints" => {
                                                     "host" => "sip.tropo.com"
                                                 }
                                             }
                                          }
    end
  end
end
