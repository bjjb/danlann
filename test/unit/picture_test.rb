require File.expand_path(File.join(File.dirname(__FILE__), "..", 'test_helper'))

class PictureTest < ActiveSupport::TestCase
  Picture.connection.add_column(:pictures, :image_file_data, :text)
  Picture.connection.remove_column(:pictures, :image_directory)

  def setup
    work = File.expand_path(File.join(Rails.root, 'tmp'))
    FileUtils.mkdir(work) unless File.directory?(work)
    Picture.image_directory = work
  end

  def teardown
  end

  test "the eifel tower is valid" do
    debugger
    assert pictures(:eifel_tower).errors.valid?
  end
end
