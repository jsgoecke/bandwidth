require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Bandwidth" do
  before(:each) do
    # You will need to set the developer_key to a valid one from Bandwidth in order to run a test
    @bandwidth = Bandwidth.new({ :developer_key => 'your developer key',
                                 :use_lab_uris  => true,
                                 :log_level     => :debug })
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
      pending('It appears Bandwidth has not provided access to this just yet.')
      result = @bandwidth.get_cdr_archive(:get_type => 'Daily', :get_value => '20110221')
      result.should == nil
    end
  end
end
