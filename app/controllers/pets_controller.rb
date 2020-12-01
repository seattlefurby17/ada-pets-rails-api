class PetsController < ApplicationController
  def index
    @pets = Pet.order(:name)
    render json: { ok: "YEAH" }, status: :ok
  end
end
