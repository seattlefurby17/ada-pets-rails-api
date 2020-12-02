require "test_helper"

describe PetsController do
  describe 'index' do 
    PET_FIELDS = ["id", "name", "age", "owner", "species"].sort

    def check_response(expected_type:, expected_status: :success)
      must_respond_with expected_status
      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
       expect(body).must_be_instance_of expected_type
       return body
    end

    it "must get index" do
      get pets_path
      check_response(expected_type: Array)
      # making sure it returning json
      # must_respond_with :success
      # expect(response.header['Content-Type']).must_include 'json'
    end

    it "will return all the proper fileds for a list of pets" do 

      # Act
      get pets_path

      # Get the body of the response as an array or hash
      # body = JSON.parse(response.body)
      body = check_response(expected_type: Array)
      # # Assert
      # expect(body).must_be_instance_of Array

      body.each do |pet|
        expect(pet).must_be_instance_of Hash 
        expect(pet.keys.sort).must_equal PET_FIELDS
      end
    end

    it "returns an empty array if no pet exits" do
      # Arrange
      Pet.destroy_all

      # Act
      get pets_path
      # body = JSON.parse(response.body)

      # # Assert
      # expect(body).must_be_instance_of Array
      body = check_response(expected_type: Array)
      expect(body).must_equal []
      expect(body.length).must_equal 0
    end

    describe "show" do
      # Nominal 
      it "will return a hash with the proper fields for an existing pet" do
        # Arrange
        pet = pets(:luna)

        # Act
        get pet_path(pet.id)
        
        # Assert
        # must_respond_with :ok
        check_response(expected_type: Hash)

        # Get the body of the response as an array or hash
        # body = JSON.parse(response.body)
        body = check_response(expected_type: Hash)
        # #making sure it returning json
        # must_respond_with :success
        # expect(response.header['Content-Type']).must_include 'json'

        # expect(body).must_be_instance_of Hash
        expect(body.keys.sort).must_equal PET_FIELDS

      end

      #Edge Case
      it "will retrun a 404 request with json for a non-existent pet" do
        get pet_path(-1)
        # check_response(expected_type: Hash)
        # body = check_response(expected_type: Hash)
        
        must_respond_with :not_found
        body = JSON.parse(response.body)
        expect(body).must_be_instance_of Hash
        expect(body['ok']).must_equal false
        expect(body['message']).must_equal 'No pet found'
        
      end
    end
  end 
      
  describe 'create' do
     # arrange
    let(:pet_params) {
      {
        pet: {
          name: 'kobi',
          age: 3, 
          owner: 'solo', 
          species: 'feline'
        }
      }
    }
    it 'can create a new pet' do
      # act and assert 
      # pet was addedd to db
      expect{
        post pets_path, params: pet_params
      }.must_differ "Pet.count", 1
      
      # response code 201 was created
      must_respond_with :created
    end

    it 'responds with bad_request status for invalid data' do
      pet_params[:pet][:name] = nil

      # pet count doesn't change
      expect{
        post pets_path, params: pet_params
      }.wont_change "Pet.count"

      must_respond_with :bad_request 
      # check_response(expected_type: Hash)

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body["errors"].keys).must_include "name"

    end

  end

end
