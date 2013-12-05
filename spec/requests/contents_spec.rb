require 'spec_helper'

describe "Contents" do
  
  subject { page }

  describe "root page" do

    describe "display" do
      let!(:content) { FactoryGirl.create(:content) }
      before { visit root_path }

      it { should have_selector('li', text: content.upload_file_name) }
      it { should have_link(content.upload_file_name) }
    end

    describe "execute upload" do
      before do
        visit root_path
        attach_file "Upload file", Rails.root.join("spec").join("test.txt")
      end

      context "with password" do
        before do
          fill_in "Password", with: "password"
        end

        it "should create Content" do
          expect { click_button("Upload") }.to change(Content, :count).by(1)
        end

        it "should redirect root page" do
          click_button("Upload")
          content = Content.last
          expect(current_path).to eq(content_path(content))
          
        end

        it "should have secure password" do
          click_button("Upload")
          content = Content.last
          # content.password は String なので、
          # BCrypt::Password に変換して比較する
          # 比較演算子は BCrypt::Password で再定義されている
          hoge = BCrypt::Password.new(content.password)
          (hoge == "password").should be (true)
        end

        it "should display success message" do
          click_button("Upload")
          expect(page).to have_text("Upload success")
        end
      end
      
      context "non password" do
        it "should create Content" do
          expect { click_button("Upload") }.to change(Content, :count).by(1)
        end

        it "should display success message" do
          click_button("Upload")
          should have_content("Upload success")
        end
      end
    end
    describe "ファイルを選択せずにアップロードした場合" do

      it "エラーメッセージが表示される" do
        visit root_path
        click_button("Upload")
        should have_content("ファイルを選択してください")
      end
    end
  end

  describe "show page" do

    let!(:content) { FactoryGirl.create(:content_with_password) }
    before { visit content_path(content) }

    describe "display" do
      it { should have_selector('h2', text: content.upload_file_name) }
    end

    describe "Back" do
      it "root page" do
        click_link "Back"
        expect(page).to have_content "Uploader"
      end
    end

    describe "execute download" do
      it "download file" do
        click_button("Download")
        response_headers['Content-Type'].should eq 'text/plain'
      end
    end

    describe "execute delete" do

      context "valid password" do
        before do
          fill_in "Password", with: "password"
        end
        it "success delete file" do
          expect { click_button("Delete") }.to change(Content, :count).by(-1)
        end

        it "should display success message" do
          click_button("Delete")
          should have_content("Delete success.")
        end
      end
      
      context "invalid password" do
        before do
          fill_in "Password", with: "hogehoge"
        end
        it "should fail delete file" do
          expect { click_button("Delete") }.to change(Content, :count).by(0)
        end

        it "should display fail message" do
          click_button("Delete")
          should have_content("Delete fail.")
        end
      end
    end
  end
end
