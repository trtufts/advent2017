##
# Calculates the inverse captcha by summing all digits that match the next
# digit in the list.  The list is circular, so the digit after the last 
# digit is the first digit.
#
# @param captcha [Fixnum] Sequence of digits as a number
def inverse_captcha(captcha)
	captcha_digits = to_digits(captcha)
	calculate_inverse(captcha_digits, 1)
end

##
# Same as :inverse_captcha but the checked digit is halfway around
# the circular list.  This list is assumed even
#
# @param captcha [Fixnum] Sequence of digits as a number
def inverse_captcha_half_step(captcha)
	captcha_digits = to_digits(captcha)
	step_size = captcha_digits.size / 2
	calculate_inverse(captcha_digits, step_size)
end

# Turns a Fixnum into an Enumerable of its digits
def to_digits(captcha)
	captcha.to_s.chars.map(&:to_i)
end

# Calculates the inverse captcha from an Enumerable of digits
def calculate_inverse(digits, step_size)
	sum = 0

	digits.each_with_index { |val,index|
		# Modulo by the array size to wrap back
		next_index = (index+step_size) % digits.size
		if val == digits[next_index]
			sum += val.to_i
		end
	}
	sum
end