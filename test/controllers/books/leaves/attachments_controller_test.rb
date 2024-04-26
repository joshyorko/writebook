require "test_helper"

class Books::Leaves::AttachmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in :kevin
  end

  test "attach a file" do
    assert_changes -> { Attachment.count }, 1 do
      post book_leaf_attachments_url(books(:handbook).id, leaves(:welcome_page).id), params: {
        file: fixture_file_upload("reading.webp", "image/webp")
      }, xhr: true
    end

    assert_response :success

    attachment = Attachment.last

    assert_equal leaves(:welcome_page), attachment.attachable
    assert_equal "reading.webp", attachment.file.filename.to_s
    assert attachment.slug =~ /\Areading-[[:alnum:]]{6}.webp\z/

    get attachment_url(attachment.slug, ext: "webp")

    assert_response :redirect
    assert_match /\/rails\/active_storage\/.*\/reading\.webp/, @response.redirect_url
  end
end
