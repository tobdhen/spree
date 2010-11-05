require 'spec_helper'

describe UserSessionsController do
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs).as_null_object
  end
  
  before(:each) do
    request.env['warden'] = mock(Warden, :authenticate => mock_user, :authenticate! => mock_user)
  end

  context "#create" do
    context "when current_order is associated with a guest user" do
      #let(:user) { mock User }
      let(:order) { mock_model Order, :user => mock_user }

      before do
        controller.stub :authorize!
        controller.stub :current_order => order
      end

      it "should associate the order with the newly authenticated user" do
        registered_user = mock_model User
        controller.stub :current_user => registered_user
        order.should_receive(:associate_user!).with registered_user
        post :create, {}, { :order_id => 1 }
      end

      it "should destroy the session token for guest_user" do
        controller.stub :current_user => @mock_user
        order.stub :associate_user!
        post :create, {}, { :order_id => 1, :guest_token => "foo" }
        session[:guest_token].should be_nil
      end

    end
  end

end
