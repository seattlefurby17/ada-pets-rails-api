class PetsController < ApplicationController
  def index
    # @pets = Pet.order(:name)
    # render json: { ok: "YEAH" }, status: :ok
    pets = Pet.order(:name)
    render json: pets.as_json(only: [:id, :name, :age, :owner, :species]),
                              status: :ok
  end

  def show
    pet = Pet.find_by(id: params[:id])

    if pet.nil?
      render json: {
        ok: false,
        message: 'No pet found'
      }, status: :not_found
      return
    end

    render json: pet.as_json(only: [:id, :name, :age, :owner, :species]),
                            status: :ok
  end

  def create
    pet = Pet.new(pet_params)
    if pet.save
      render json: pet.as_json, status: :created
    else
      
    end
  end

  private

  def pet_params
    return params.require(:pet).permit(:name, :age, :owner, :species)
  end

end
