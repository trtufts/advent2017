require 'csv'

##
# Given a spreadsheet of values in TSV form, calculate the checksum.
# 
# For each row, determines the difference between max and min value;
# the checksum is the sum of all these differences.
#
# @param path_to_tsv [String] filepath to the input tsv
def checksum(path_to_tsv)
	spreadsheet = parse_tsv path_to_tsv
	compute_spreadsheet_checksum(
		spreadsheet, 
		method(:compute_row_value_difference))
end

##
# Same as :checksum but using a new row computation function.
#
# This row computation function will find the only divisible pair of numbers,
# then divide them and return the result.
def checksum_division(path_to_tsv)
	spreadsheet = parse_tsv path_to_tsv
	compute_spreadsheet_checksum(
		spreadsheet, 
		method(:compute_row_value_quotient))
end

##
# Parses the tsv at path_to_tsv and returns it as 2D array.
# The first index is row, the second is column.
def parse_tsv(path_to_tsv)
	tsv = CSV.read(path_to_tsv, { :col_sep => "\t" })
	# convert strings to ints
	tsv.map do |row| 
		row.map { |value| value.to_i }
	end
end

# Calculates the difference between the min and max values of a row
def compute_row_value_difference(row)
	max_value = row.max
	min_value = row.min
	max_value - min_value
end

# Calculates the quotient of the only divisible pair of numbers
def compute_row_value_quotient(row)
	sorted_row = row.sort

	# Check numerators from the end of the sorted_row,
	# moving to the next denominator when you reach numerator / 2
	sorted_row.reverse_each do |numerator|
		sorted_row.each do |denominator|
			break if denominator * 2 > numerator

			if numerator % denominator == 0
				return numerator / denominator
			end
		end
	end
end

##
# Reduces each row to a single value with :compute_row_value_method,
# then sums up the results
def compute_spreadsheet_checksum(spreadsheet, compute_row_value_method)
	reduced_rows = spreadsheet.map{ |row| compute_row_value_method.call row }
	reduced_rows.reduce(0, :+)
end