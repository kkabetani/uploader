require 'spec_helper'

describe ContentsController do

  describe "GET index" do
    it "hoge" do
      get :index
      expect(response).to be_success
    end
  end


  describe "POST create" do
    #let(:content) { FactoryGirl.create(:content) }

    it "redirect content page" do
      #content = FactoryGirl.attributes_for(:content)
      upload_file = Rack::Test::UploadedFile.new('spec/fixtures/test.txt', 'text/plain')
      post :create, content: { upload_file: upload_file }
      expect(response).to redirect_to(content_path(assigns(:content).id))
    end

    it "root page" do
      upload_file = nil
      post :create, content: { upload_file: upload_file }
      expect(response).to render_template(:index)
    end
  end

end
