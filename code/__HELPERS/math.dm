/proc/normalize_angle(degrees)
	degrees = degrees % 360
	if (degrees < 0)
		degrees += 360
	return degrees

/proc/InRange(var/A, var/lower, var/upper)
	if(A < lower) return 0
	if(A > upper) return 0
	return 1

/proc/sign(x) //Should get bonus points for being the most compact code in the world!
	return x!=0?x/abs(x):0 //((x<0)?-1:((x>0)?1:0))

/proc/approach(current_value, target_value, amount)
	if(current_value < target_value)
		return min(current_value + amount, target_value)
	else if(current_value > target_value)
		return max(current_value - amount, target_value)
	else
		return current_value