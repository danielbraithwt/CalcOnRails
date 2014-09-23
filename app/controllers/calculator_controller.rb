class CalculatorController < ApplicationController
		
	layout false

	def index
	end

	def calculate
		puts "CalculatorController >  Action"
		@result = 2
	end

end
