require "rubycalc/expression_builder"

class CalculatorController < ApplicationController
		
	layout false

	def index
	end

	def calculate
		puts "CalculatorController >  Action"

		# Create the expression builder
		puts "Expression #{params[:expression]}"
		expression = params[:expression] || ""

		eb = ExpressionBuilder.new
		eb.add_line(params[:expression])

		@result = eb.evaluate
	end

end
