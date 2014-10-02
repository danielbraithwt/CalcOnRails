require "rubycalc/calculator.rb"

class ExpressionBuilder

	def initialize
		@lines = []
		@defined_variables = []
		@functions = ['log', 'ln', 'sin', 'cos', 'tan', 'arcsin', 'arccos',
				'arctan', 'sinh', 'cosh', 'tanh', 'arcsinh', 'arccosh', 'arctanh']
	end

	def add_line(line)

		# Get the assignment of this line
		assignment = "ans"
		if line.index("=")
			assignment = line.split("=")[0].strip
		end

		# Verify that if varaibles are used in the line they are correct
		verify_line(line[(line.index("=") || 0), line.length])

		# Add the lines assigne to the list of defined variables
		if assignment == "ans" && !variable_defined?("ans")
			@defined_variables << assignment
		elsif !variable_defined?(assignment)
			@defined_variables << assignment
		end
		
		# Add the line to the list of lines
		@lines << line
	end

	def set_variable(var_name, var_value)
		@defined_variables << var_name
		@lines << "#{var_name}=#{var_value}"
	end

	def variable_defined?(var)
		#return false if !@defined_variables
		return @defined_variables.include?(var)
	end

	def evaluate
		# Compile the expression and compute the result
		expression = compile_expression	
		result = Calculator.evaluate(expression)

		return result
	end

	def compile_expression
		expression = ""

		@lines.each do |line|
			expression += line + ";"
		end

		return expression
	end

	private

	def verify_line(line)

		# Split the line into the possible variables
		components = line.gsub(/[\d|(|)|+|\-|*|\/|^|=]+/, " ").split(/[\s]+/)
		
		# Make sure that all the variables have been defined
		components.each do |var|
			raise "Variable '#{var}' not defined yet!" if !variable_defined?(var) && !@functions.include?(var)  && var != ""
		end
	end


end
