class PetsController < ApplicationController
  def index
    # @pets = Pet.order(:name)
    # render json: { ok: "YEAH" }, status: :ok
    pets = Pet.order(:name)
    render json: pets.as_json(only: [:id, :name, :age, :owner, :species]),
                              status: :ok
  end

  def show
    
  end
end
