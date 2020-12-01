require "test_helper"

describe PetsController do
  it "must get index" do
    get pets_path
    # making sure it returning json
    must_respond_with :success
    expect(response.header['Content-Type']).must_include 'json'
  end

  it "will return all the proper fileds for a list of pets" do 
    pet_fields = ["id", "name", "age", "owner", "species"].sort

    # Act
    get pets_path

    # Get the body of the response as an array or hash
    
    body = JSON.parse(response.body)

    # Assert
    expect(body).must_be_instance_of Array

    body.each do |pet|
      expect(pet).must_be_instance_of Hash 
      expect(pet.keys.sort).must_equal pet_fields 
    end
  end

  it "returns an empty array if no pet exits" do
    # Arrange
    Pet.destroy_all

    # Act
    get pets_path
    body = JSON.parse(response.body)

    # Assert
    expect(body).must_be_instance_of Array
    expect(body).must_equal []
    expect(body.length).must_equal 0
  end


end
