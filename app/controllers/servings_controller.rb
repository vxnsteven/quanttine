class ServingsController < ApplicationController
  def index
    @school_meals = SchoolMeal.all.order("date DESC")
  end

  def new
    @school_meals = SchoolMeal.where(date: Date.tomorrow).order("created_at ASC")
  end

  def create
    @food_supply = FoodSupply.find_by(name: params[:food_name])

    if SchoolMeal.find_by(date: params[:date], school_id: current_admin.school_id) == nil
      @school_meal = SchoolMeal.create!(date: params[:date], school_id: current_admin.school_id)
    else
      @school_meal = SchoolMeal.find_by(date: params[:date], school_id: current_admin.school_id)
    end

    @serving = Serving.create!(meal_category: params[:meal_category], school_meal_id: @school_meal.id, food_supply_id: @food_supply.id)
    
    if @serving.save
      redirect_to new_admin_serving_path(current_admin.id)
      flash[:success] = "Aliment ajouté"
    else
      render "new"
      flash[:error]
    end
  end
  
  def destroy
    @serving = Serving.find_by(id: params[:id])
    @school_meal = @serving.school_meal
    @school_meal.destroy
    @serving.destroy
    redirect_to new_admin_serving_path(current_admin)
    flash[:success] = "Aliment supprimé"
  end

  # def edit
  #   @serving = Serving.find(params[:id])
  # end

  # def update
  #   @serving = Serving.find(params[:id])
  #   @food_supply = FoodSupply.find_by(name: params[:food_name])
  #   @serving.update(food_supply_id: FoodSupply.find_by(name: params[:food_supply_id]).servings.first.id)
  #   redirect_to admin_servings_path(current_admin)
  # end

  # private

  # def serving_params
  #   params.require(:food_supply).permit(:food_supply_id)
  # end

  # def food_supply_params
  #   params.require(:serving).permit(:name)
  # end

end
