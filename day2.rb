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
	compute_spreadsheet_checksum(spreadsheet)
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
def compute_row_value(row)
	max_value = row.max
	min_value = row.min
	max_value - min_value
end

##
# Reduces each row to a single value with :compute_row_value,
# then sums up the results
def compute_spreadsheet_checksum(spreadsheet)
	reduced_rows = spreadsheet.map{ |row| compute_row_value row }
	reduced_rows.reduce(0, :+)
end