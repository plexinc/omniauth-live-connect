require 'spec_helper'

describe OmniAuth::Strategies::LiveConnect do
  let(:access_token) { stub('AccessToken', :options => {}) }
  let(:parsed_response) { stub('ParsedResponse') }
  let(:response) { stub('Response', :parsed => parsed_response) }

  subject do
    OmniAuth::Strategies::LiveConnect.new({})
  end

  before(:each) do
    subject.stub!(:access_token).and_return(access_token)
  end

  context "client options" do
    it 'should have correct site' do
      subject.options.client_options.site.should eq("https://login.live.com")
    end

    it 'should have correct authorize url' do
      subject.options.client_options.authorize_url.should eq('https://login.live.com/oauth20_authorize.srf')
    end

    it 'should have correct token url' do
      subject.options.client_options.token_url.should eq('https://login.live.com/oauth20_token.srf')
    end
  end

  context "#raw_info" do
    it "should use relative paths" do
      access_token.should_receive(:get).with('https://apis.live.net/v5.0/me').and_return(response)
      subject.raw_info.should eq(parsed_response)
    end
  end

end
