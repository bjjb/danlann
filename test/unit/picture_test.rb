require File.expand_path(File.join(File.dirname(__FILE__), "..", 'test_helper'))

class PictureTest < ActiveSupport::TestCase
  fixtures :users, :pictures

  def setup
    @user = users(:bill)
    @picture = pictures(:eifel_tower)
  end

  test "a picture has a user" do
    assert_equal @user, @picture.user 
  end

  test "pictures are fleximages" do
    assert_kind_of Fleximage::Model::InstanceMethods, @picture
    assert_kind_of Fleximage::Model::ClassMethods, Picture
  end

  test "the name is required" do
    @picture.name = nil
    assert !@picture.valid?
    assert_equal 'is too short (minimum is 2 characters)', @picture.errors.on(:name)
  end

  test "the name can't be too long" do
    @picture.name = "x" * 31
    assert !@picture.valid?
    assert_equal 'is too long (maximum is 30 characters)', @picture.errors.on(:name)
  end

  test "the description can't be too long" do
    @picture.description = "b" * 10001
    assert !@picture.valid?
    assert_equal 'is too long (maximum is 10000 characters)', @picture.errors.on(:description)
  end

  test "the group size is configurable" do
    assert_respond_to @picture, "group_size"
    assert_respond_to Picture, "group_size"
    assert_respond_to @picture, "group_size="
    assert_respond_to Picture, "group_size="
  end
end
