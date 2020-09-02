class Api::CategoriesController < ApplicationController
  def index
    puts "-----------------"
    puts "受け取ったカテゴリのID"
    puts params[:category_id]
    puts "-----------------"
    category = Category.find(params[:category_id])
    @categories = category.children
    puts "-----------------"
    puts "子孫カテゴリ"
    puts @categories.pluck(:name)
    puts "-----------------"
  end
end