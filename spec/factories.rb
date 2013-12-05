FactoryGirl.define do
  factory :content do
    upload_file_name  "test.txt"
    upload_file       Rack::Test::UploadedFile.new('spec/fixtures/test.txt', 'text/plain').read

    factory :content_with_password do
      password        "password"
    end
  end
end
