'''
Ring	Numbers
1		8
2		16
3		24
4		32
'''

##
# Finds the Manhattan distance between the square number in the input.
# Squares a allocated in a counterclockwise spiral out from 1.
#
# @param square [Fixnum] number of the square to start from
def spiral(square)
	ring, previous_corner = find_ring_and_corner_square(square)
	x_pole, y_pole = find_between_poles(square, ring, previous_corner)
	find_distance(square, x_pole, y_pole, ring)
end

##
# Finds which ring this square is in and the largest corner of the ring before.
#
# We consider the first ring to be the 0th ring, with 1 number,
# then each ring has 8 * (Ring #) squares in it.
#
# If we subtract the 1 in the center,
# we can categorize by mutliples of 8 and rounding up.
#
# The 1st ring has 2 -> 9, which is 1 to 8
# 	( x.fdiv 8 ).ceil => 1
# The 2nd ring has 10 -> 25 which is 9 to 24
# 	( x.fdiv 8 ).ceil => (2 or 3)
# The 3rd ring has 26 -> 49 which is 25 to 48
# 	( x.fdiv 8 ).ceil => (4 or 5 or 6)
#
# After we find the multiple,
# we can search up the rings until we find which it belongs to
def find_ring_and_corner_square(square)
	shifted_square = square - 1
	
	multiples = (shifted_square.fdiv 8).ceil

	candidate_ring = 0
	corner_multiple = 0
	max_mulitple = 0

	while multiples > max_mulitple
		candidate_ring += 1

		# Store the previous ring's max for finding the corner square
		corner_multiple = max_mulitple

		# There are (Ring #) multiples in each ring
		max_mulitple += candidate_ring
	end

	largest_corner = (corner_multiple * 8) + 1
	[candidate_ring, largest_corner]
end

##
# Pole squares are at 3, 12, 9, and 6 on the clock face in order.
# 
# Once we find 3 o'clock,
# we can find the other poles in order by adding 1/4 the ring size
#
# We want to find which two poles the square is between
def find_between_poles(square, ring, previous_corner)
	# Each ring takes 1 additional move before hitting y=0,
	# The three pole is that many steps up from when the last ring ended
	three_pole = previous_corner + ring

	squares_in_ring = ring * 8
	quarter_step = squares_in_ring / 4

	twelve_pole = three_pole + quarter_step

	return [twelve_pole, three_pole] if square.between?(three_pole, twelve_pole)

	nine_pole = twelve_pole + quarter_step

	return [twelve_pole, nine_pole] if square.between?(twelve_pole, nine_pole)

	six_pole = nine_pole + quarter_step

	return [six_pole, nine_pole] if square.between?(nine_pole, six_pole)

	# If we haven't returned yet, 
	# we're in the weird bottom right corner that wraps around values
	[six_pole, three_pole]
end

##
# We can calculate x offset from 12 and 6, and y offset from 3 and 9.
# The manhattan distance is the sum of the absolute offsets.
def find_distance(square, x_pole, y_pole, ring)
	x_offset = calculate_offset(square, x_pole, ring)
	y_offset = calculate_offset(square, y_pole, ring)
	x_offset + y_offset
end

##
# We don't want to count around corners,
# So cap the offset at the distance to the corner (Ring #)
def calculate_offset(square, pole, ring)
	difference = (square - pole).abs
	[difference, ring].min
end