require 'rubycalc/node'
require 'rubycalc/utils'

class Calculator
	include Utils

	def self.evaluate(expressions)

		assignments = {}
		expressions = expressions.downcase
		
		expressions.split(";").each do |expression|

			# Figure out what variable to assign the variable to
			assignment = "ans"
			if expression.index("=")
				assignment = expression[0,expression.index("=")].strip
				expression = expression[expression.index("=")+1, expression.length].strip
			end

			# Replace variable names with there numbers
			assignments.each do |variable, value|
				expression = expression.gsub(variable, value.to_s)
			end
			
			# Parse various parts of the expression
			expression = parse_constants(expression)
			expression = parse_functions(expression)
			expression = parse_brackets(expression) if expression.include?("(")
			expression = parse_exponents(expression) if expression.include?("^")

			head = Node.new(expression)
			assignments[assignment] = head.evaluate
			#return head.evaluate
		end

		return assignments["ans"]
	end

	private 

	# Function takes an expression and evaluates the brackets in the 
	# expression
	def self.parse_brackets(expression)
		open = 1
		start = expression.index("(")

		if !start
			head = Node.new(expression.strip)
			return head.evaluate
		end

		index = start
		while index && open != 0 do 

			if expression.index("(", index+1) && (expression.index("(", index+1) < expression.index(")", index+1))
				index = expression.index("(", index+1)
			elsif expression.index(")", index+1)
				index = expression.index(")", index+1)
			else
				raise "Invalid Expression: Check the brackets"	
			end

			if expression[index] == "("
				open = open + 1
			elsif expression[index] == ")" 
				open = open - 1
			end

			if start && open == 0
				parsed = parse_brackets(expression[start+1, index-1].strip)
				beginning = expression[0,start-1] || ""
				ending =  expression[index+1,expression.length] || ""

				expression =  beginning + parsed.to_s + ending

				start = expression.index("(")
				open = open + 1 if start
			end

		end

		return expression
	end

	# Function takes an expression and evaulates the powers
	# in the expression
	def self.parse_exponents(expression)

		pow = expression.index("^")

		while pow do
			#expstart = expression.rindex(" ", pow) || 0
			#expend = expression.index(" ", pow) || expression.length
			
			expstart = expression.rindex(/[+|-|*|\/|\s]/, pow) || 0
			expend = expression.index(/[+|-|*|\/|\s]/, pow) || expression.length

			
			# Check to make sure its valid
			raise "Invalid Expression: Check your powers!" if !Utils::is_a_number?(expression[expstart,pow]) || !Utils::is_a_number?(expression[pow+1,expend])

			poweval = expression[expstart, pow].strip.to_i ** expression[pow+1,expend].strip.to_i
			expression = expression[0,expstart] + poweval.to_s + expression[expend,expression.length]

			pow = expression.index("^")
		end
		
		return expression
	end

	def self.parse_functions(expression)

		# Replace natural log functions
		while expression.index("ln(") do
			start = expression.index("ln(")
			finish = Utils::find_close_bracket(expression[start+2, expression.length])+2
			raise "Invalid Expression: Check your functions" if finish == nil

			expression = expression[0, start] + (Math.log(Calculator.evaluate(expression[start+3, finish-3]).to_f)).to_s + expression[finish+1, expression.length]
		end

		# Replace log functions
		while expression.index("log(") do
			start = expression.index("log(")
			finish = Utils::find_close_bracket(expression[start+3, expression.length])+3
			raise "Invalid Expression: Check your functions" if finish == nil


			expression = expression[0, start] + (Math.log(Calculator.evaluate(expression[start+4, finish-4]).to_f, 10)).to_s + expression[finish+1, expression.length]
		end

		# Replace arcsinh functions
		while expression.index("arcsinh(") do
			start = expression.index("arcsinh(")
			finish = Utils::find_close_bracket(expression[start+7, expression.length])+7
			raise "Invalid Expression: Check your functions" if finish == nil


			expression = expression[0, start] + (Math.asinh(Calculator.evaluate(expression[start+8, finish-8]).to_f)).to_s + expression[finish+1, expression.length]
		end

		# Replace sinh functions
		while expression.index("sinh(") do
			start = expression.index("sinh(")
			finish = Utils::find_close_bracket(expression[start+4, expression.length])+4
			raise "Invalid Expression: Check your functions" if finish == nil


			expression = expression[0, start] + (Math.sinh(Calculator.evaluate(expression[start+5, finish-5]).to_f)).to_s + expression[finish+1, expression.length]
		end

		# Replace arcsin functions
		while expression.index("arcsin(") do
			start = expression.index("arcsin(")
			finish = Utils::find_close_bracket(expression[start+6, expression.length])+6
			raise "Invalid Expression: Check your functions" if finish == nil


			expression = expression[0, start] + (Math.asin(Calculator.evaluate(expression[start+7, finish-7]).to_f)).to_s + expression[finish+1, expression.length]
		end

		# Replace sin functions
		while expression.index("sin(") do
			start = expression.index("sin(")
			finish = Utils::find_close_bracket(expression[start+3, expression.length])+3
			raise "Invalid Expression: Check your functions" if finish == nil


			expression = expression[0, start] + (Math.sin(Calculator.evaluate(expression[start+4, finish-4]).to_f)).to_s + expression[finish+1, expression.length]
		end

		# Replace cosh functions
		while expression.index("cosh(") do
			start = expression.index("cosh(")
			finish = Utils::find_close_bracket(expression[start+4, expression.length])+4
			raise "Invalid Expression: Check your functions" if finish == nil


			expression = expression[0, start] + (Math.cosh(Calculator.evaluate(expression[start+5, finish-5]).to_f)).to_s + expression[finish+1, expression.length]
		end

		# Replace arccos functions
		while expression.index("arccos(") do
			start = expression.index("arccos(")
			finish = Utils::find_close_bracket(expression[start+6, expression.length])+6
			raise "Invalid Expression: Check your functions" if finish == nil


			expression = expression[0, start] + (Math.acos(Calculator.evaluate(expression[start+7, finish-7]).to_f)).to_s + expression[finish+1, expression.length]
		end

		# Replace cos functions
		while expression.index("cos(") do
			start = expression.index("cos(")
			finish = Utils::find_close_bracket(expression[start+3, expression.length])+3
			raise "Invalid Expression: Check your functions" if finish == nil


			expression = expression[0, start] + (Math.cos(Calculator.evaluate(expression[start+4, finish-4]).to_f)).to_s + expression[finish+1, expression.length]
		end

		# Replace arctanh functions
		while expression.index("arctanh(") do
			start = expression.index("arctanh(")
			finish = Utils::find_close_bracket(expression[start+7, expression.length])+7
			raise "Invalid Expression: Check your functions" if finish == nil


			expression = expression[0, start] + (Math.atanh(Calculator.evaluate(expression[start+8, finish-8]).to_f)).to_s + expression[finish+1, expression.length]
		end

		# Replace tanh functions
		while expression.index("tanh(") do
			start = expression.index("tanh(")
			finish = Utils::find_close_bracket(expression[start+4, expression.length])+4
			raise "Invalid Expression: Check your functions" if finish == nil


			expression = expression[0, start] + (Math.tanh(Calculator.evaluate(expression[start+5, finish-5]).to_f)).to_s + expression[finish+1, expression.length]
		end	
		
		# Replace arctan functions
		while expression.index("arctan(") do
			start = expression.index("arctan(")
			finish = Utils::find_close_bracket(expression[start+6, expression.length])+6
			raise "Invalid Expression: Check your functions" if finish == nil


			expression = expression[0, start] + (Math.atan(Calculator.evaluate(expression[start+7, finish-7]).to_f)).to_s + expression[finish+1, expression.length]
		end

		# Replace tan functions
		while expression.index("tan(") do
			start = expression.index("tan(")
			finish = Utils::find_close_bracket(expression[start+3, expression.length])+3
			raise "Invalid Expression: Check your functions" if finish == nil


			expression = expression[0, start] + (Math.tan(Calculator.evaluate(expression[start+4, finish-4]).to_f)).to_s + expression[finish+1, expression.length]
		end

		return expression
	end

	def self.parse_constants(expression)
		# Replace the two letters pi with the constant pi
		while expression.index("pi") do
			expression = expression[0, expression.index("pi")] + (Math::PI).to_s + expression[expression.index("pi")+2, expression.length]
		end

		# Replace the letter e with the constant e
		while expression.index("e") do
			expression = expression[0, expression.index("e")] + (Math::E).to_s + expression[expression.index("e")+1, expression.length]
		end


		
		return expression
	end

end
