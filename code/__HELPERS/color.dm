#define HRC_ERROR 0
#define HRC_LEGIT 1

proc
	//These are support procs and shouldn't be called directly, as they are dumb procs that\
	do not check if data passed to them is valid. Any mess-ups related to calling these four\
	procs are solely your fault.
	hrc_sup_delimiter(_rgb)
		for(var/i=1;i<=length(_rgb);i++)
			if(text2ascii(_rgb,i) < 48 || text2ascii(_rgb,i) > 57) return copytext(_rgb,i,i+1)
		return HRC_ERROR
	hrc_sup_findchar(rawtext,char,casesensitive,offset,count) //proc I use elsewhere that proved useful here
		var/_c = 0
		for(var/i=(offset ? offset : 1);i<=length(rawtext);i++)
			if(!count && (copytext(rawtext,i,i+1) == char || (!casesensitive && lowertext(copytext(rawtext,i,i+1)) == lowertext(char)))) return i
			if(count && (copytext(rawtext,i,i+1) == char || (!casesensitive && lowertext(copytext(rawtext,i,i+1)) == lowertext(char)))) _c++
		return (count ? _c : HRC_ERROR)
	hrc_sup_givedec(value)
		var/i = _hexdigits.Find(lowertext(value))
		value = i-1
		return value
	hrc_sup_givehex(value)
		var/i = text2num(value)+1
		value = _hexdigits[i]
		return value
	hrc_sup_shorthex(hex)
		return "#[copytext(hex,2,3)][copytext(hex,2,3)][copytext(hex,3,4)][copytext(hex,3,4)][copytext(hex,4,5)][copytext(hex,4,5)]"
	//Primary function procs.
	hrc_hex2rgb(hex,returnlist=0)
		if(!istext(hex) || !hrc_ishex(hex)) return HRC_ERROR
		if(length(hex) == 4) hex = hrc_sup_shorthex(hex)
		var/_red = (hrc_sup_givedec(copytext(hex,2,3))*16)+hrc_sup_givedec(copytext(hex,3,4))
		var/_green = (hrc_sup_givedec(copytext(hex,4,5))*16)+hrc_sup_givedec(copytext(hex,5,6))
		var/_blue = (hrc_sup_givedec(copytext(hex,6,7))*16)+hrc_sup_givedec(copytext(hex,7,8))
		return (returnlist ? list(_red,_green,_blue) : "#[_red][_green][_blue]")
	hrc_invert(_val)
		var/_val_rgb[0]
		if(hrc_ishex(_val)) _val_rgb = hrc_hex2rgb(_val,1)
		else if(hrc_isrgb(_val))
			if(istype(_val,/list)) _val_rgb.Add(_val)
			else if(istext(_val))
				var/_d = hrc_sup_delimiter(_val)
				_val_rgb.Add(text2num(copytext(_val,1,findtext(_val,_d))),text2num(copytext(_val,findtext(_val,_d)+1,findtext(_val,_d,findtext(_val,_d)+1))),text2num(copytext(_val,findtext(_val,_d,findtext(_val,_d)+1)+1)))
		else return HRC_ERROR
		_val_rgb[1] = (255-_val_rgb[1])
		_val_rgb[2] = (255-_val_rgb[2])
		_val_rgb[3] = (255-_val_rgb[3])
		return (hrc_ishex(_val) ? rgb(_val_rgb[1],_val_rgb[2],_val_rgb[3]) : ((hrc_isrgb(_val) && istype(_val,/list)) ? _val_rgb : "[_val_rgb[1]],[_val_rgb[2]],[_val_rgb[3]]"))
	hrc_ishex(hex)
		if(!istext(hex) || text2ascii(hex,1) != 35 || (length(hex) != 4 && length(hex) != 7)) return HRC_ERROR
		for(var/i=2;i<=length(hex);i++)
			if(!_hexdigits.Find(lowertext(copytext(hex,i,i+1)))) return HRC_ERROR
		return HRC_LEGIT
	hrc_isrgb(_rgb)
		var/_d = hrc_sup_delimiter(_rgb)
		if(istext(_rgb) ? (!_d || hrc_sup_findchar(_rgb,_d,0,0,1) != 2 || length(_rgb) > 11 || length(_rgb) < 5) : (length(_rgb) < 3)) return HRC_ERROR
		var/_r = (istext(_rgb) ? text2num(copytext(_rgb,1,findtext(_rgb,_d))) : _rgb[1])
		var/_g = (istext(_rgb) ? text2num(copytext(_rgb,findtext(_rgb,_d)+1,findtext(_rgb,_d,findtext(_rgb,_d)+1))) : _rgb[2])
		var/_b = (istext(_rgb) ? text2num(copytext(_rgb,findtext(_rgb,_d,findtext(_rgb,_d)+1)+1)) : _rgb[3])
		if((_r == null || _r < 0 || _r > 255) || (_g == null || _g < 0 || _g > 255) || (_b == null || _b < 0 || _b > 255)) return HRC_ERROR
		return HRC_LEGIT
	hrc_rgb2hex(_rgb)
		if(!hrc_isrgb(_rgb) || (istype(_rgb,/list) && length(_rgb) < 3)) return HRC_ERROR
		var/_d = hrc_sup_delimiter(_rgb)
		var/_r = (istext(_rgb) ? text2num(copytext(_rgb,1,findtext(_rgb,_d))) : _rgb[1])
		var/_g = (istext(_rgb) ? text2num(copytext(_rgb,findtext(_rgb,_d)+1,findtext(_rgb,_d,findtext(_rgb,_d)+1))) : _rgb[2])
		var/_b = (istext(_rgb) ? text2num(copytext(_rgb,findtext(_rgb,_d,findtext(_rgb,_d)+1)+1)) : _rgb[3])
		return rgb(_r,_g,_b)

var/list/_hexdigits = list("0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f")