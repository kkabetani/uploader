require 'spec_helper'

describe "contents/edit" do
  before(:each) do
    @content = assign(:content, stub_model(Content,
      :upload_file_name => "MyString",
      :upload_file => ""
    ))
  end

  it "renders the edit content form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", content_path(@content), "post" do
      assert_select "input#content_upload_file_name[name=?]", "content[upload_file_name]"
      assert_select "input#content_upload_file[name=?]", "content[upload_file]"
    end
  end
end
