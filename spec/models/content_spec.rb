require 'spec_helper'

describe Content do

  before do
    @content = FactoryGirl.create(:content)
  end

  it { should respond_to(:upload_file_name) }

  it { should respond_to(:password) }
end
