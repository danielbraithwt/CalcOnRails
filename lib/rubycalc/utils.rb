module Utils
	def Utils.is_a_number?(number)
		 number.match(/[0-9]+/)
	end

	def Utils.find_close_bracket(expression)
		# If there is no more open brackets then we can just return the first 
		# close bracket
		if expression.index("(") == nil
			return expression.index(")") if expression.index(")") != nil

			# If there was no close bracket then there is an error
			raise "Invalid Expression: Check your brackets"
		end

		
		index = expression.index(")") < expression.index("(") ? expression.index(")") : expression.index("(")
		return nil if index == nil
		open = 1

		while open != 0 do
			index = (expression.index(")", index+1) || expression.length) < (expression.index("(", index+1) || expression.length) ? expression.index(")", index+1) : expression.index("(", index+1)

			open += 1 if expression[index] == "("
			open -= 1 if expression[index] == ")"
		end

		return index
	end
end
