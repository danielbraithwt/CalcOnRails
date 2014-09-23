require 'rubycalc/utils'

class Node
	include Utils

	@info
	@left
	@right
	@operator

	def initialize(expression)
		expression = expression.to_s
		expression = expression.strip

		@operator = true

		if expression[0] == "-" || expression[0] == "+"
			@info = expression
			@operator = false

			# Make sure its a number
			raise "Invalid Expression: Check syntax" if !Utils::is_a_number?(@info[1, @info.length])

			return
		end


		if expression.index('-')
			@info = "-"
			split_expression(expression)

		elsif expression.index('+')
			@info = "+"
			split_expression(expression)

		elsif expression.index('*')
			@info = "*"
			split_expression(expression)

		elsif expression.index('/')
			@info = "/"
			split_expression(expression)

		else
			@info = expression

			# Make sure its a number
			raise "Invalid Expression: Check syntax" if !Utils::is_a_number?(@info)

			@operator = false

		end
	end

	def evaluate
		# If its not a operator then return its value
		return @info.to_f unless @operator
		
		# Peform nodes operator on the result of evaluate on the left
		# and right nodes
		return @left.evaluate / @right.evaluate if @info == "/"
		return @left.evaluate * @right.evaluate if @info == "*"
		return @left.evaluate + @right.evaluate if @info == "+"
		return @left.evaluate - @right.evaluate if @info == "-"

	end

	private

	def split_expression(expression)
		# Splits the expression at the correct operator and then
		# create the two new nodes
		@left = Node.new(expression[0, expression.index(@info)])
		@right = Node.new(expression[expression.index(@info)+1, expression.length])
	end

	


end
