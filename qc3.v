import math
import strconv
const (
	ndecimals = 6				// number of decimals to round
	ndecimals_visual = 3 		// number of decimals to round
	maxqbits = 100
)
struct Glob {
	mut:
	round_base			f64 = math.pow(10,ndecimals)
	round_base_visual	f64 = math.pow(10,ndecimals_visual)
	// aux for out data in console
	mchar				int = 120 						// max chars in a line to output console information
	charl 				byte = `*`
}
struct Cplx {
	mut:
	rv		f64 	// real value
	iv		f64		// imaginary value
	glob	Glob
}
struct CCplx {
	mut:
	cplx		Cplx
}

fn main() {
	mut glob := Glob{}
	mut bin := Bin{}
	mut bin2 := Bin{}
	mut bin3 := Bin{}

	glob.title(" 35 in binary with 8 bits")
	bin.bin2(35, 8)
	print2(1," bin.toStr() : " + bin.tostr())
	print2(1," number in decimal: " + bin.toint().str())
	print2(1," indMax = " + bin.indmax.str())

	// groups: 2 - 6 --> xx xxxxxx
	mut group := [2,6]
	bin.setgroups( group )
	print1(" group 2 - 6 bin.toStr() : " + bin.tostr())
	bin.swap(1, 4)
	print1(" swap 1 - 4  bin.toStr() : " + bin.tostr())
	print1(" swap 1 - 4  bin.toInt() : " + bin.toint().str())

	glob.title(" 345 in binary with 12 bits")
	bin2.bin2(345, 12)
	print2(1," bin.toStr() :  " + bin2.tostr())
	print2(1," indMax = " + bin2.indmax.str())
	group2 := [ 2, 4, 6 ]
	bin2.setgroups(group2)
	print1(" group 2-4-6 bin.toStr() : " + bin2.tostr() + "\n")
	glob.title(" Delete bit ")
	print2(1,"2047 in binary with 12 bits")
	print2(1," grouped: 2-2-4-4")
			
	bin3.bin2(2047, 12)
	group3 := [2, 2, 4, 4 ]
	bin3.setgroups(group3)
	print2(2," bin.toStr() :  " + bin3.tostr())
	print2(2," indMax = " + bin3.indmax.str())
	print2(2," bin.toInt() :  " + bin3.toint().str())
	print2(1," delete bit 0 (first right) and group 2-2-4-3:")
	bin3.delbit(0)

	group3_2 := [ 2, 2, 4, 3 ]
	bin3.setgroups(group3_2)
	print2(2," bin.toStr() :  " + bin3.tostr())
	print2(2," indMax = " + bin3.indmax.str())
	print2(2," bin.toInt() :  " + bin3.toint().str())
	
	println('test')
}
// =============== Struct Global ======================
fn (glob Glob) round(n f64) f64 {
	return math.round(n * glob.round_base) / f64(glob.round_base)
}
fn (glob Glob) visual_round(n f64) f64 {
	return math.round(n * glob.round_base_visual) / f64(glob.round_base_visual)
}
// aux for out information to console
fn print1(lin string) {
	print2(0,lin)
}
fn print2(level int, lin string) {
	mut l := " >" + lin
	l = l.replace("\n", "\n  ")
	for i := 0; i < level; i++ {
		l = l.replace("\n", "\n  ")
		l = "  " + l
	}
	println(l)
}
fn (glob Glob) line1() { 			// writes a underline
	glob.line2(true)
}
fn (glob Glob) line2(jump bool) {
	if jump {
		println("\n" + glob.completeline("") + "\n")
	}else {
		println(glob.completeline(""))
	} 
}
fn (glob Glob) title(title string) { 
	mut tit := "" + glob.charl.ascii_str() + glob.charl.ascii_str() + " " + title + " "
	tit = glob.completeline(tit)
	println("")
 	glob.line2(false)
	println(tit)
	glob.line2(false)
}
fn (glob Glob) completeline(line string) string {
	mut lineret := line
	for lineret.len < glob.mchar {
		lineret = lineret + glob.charl.ascii_str()
	}
	return lineret
}
// ===================Struct Cplx ========================
// constructor
fn (mut c Cplx) cplx(rv f64, iv f64) {
	c.rv = rv
	c.iv = iv
	c.round()
}
// square modulus
fn (c Cplx) mod2() f64 {
	result := f64 ((math.pow(c.rv, 2) + math.pow(c.iv, 2)))
	return c.glob.round(result)
}
fn (mut c Cplx) round() {
	c.rv = c.glob.round(c.rv)
	c.iv = c.glob.round(c.iv)
}
// modulus
fn (c Cplx) mod() f64 {
	return f64(math.sqrt(c.mod2()))
}

fn (c Cplx) isnotzero() bool {
	return !c.iszero()
}
fn (c Cplx) iszero() bool {
	return c.rv == 0 && c.iv == 0
}
fn (mut c Cplx) tostr() string {
	return c.to_str(false)
}
fn (mut c Cplx) to_str(forcelong bool) string {
	rv_ := c.glob.visual_round(c.rv)
	iv_ := c.glob.visual_round(c.iv)
	
	mut s := if rv_ >= 0 { "( " } else { "(" }		 // negative sign or space
	if c.iv >= 0 {
		s += strconv.f64_to_str(rv_,2) + " + " + strconv.f64_to_str(iv_,2) + "i " + ")"
	} else {
		s += strconv.f64_to_str(rv_,2) + " - " + strconv.f64_to_str(-iv_,2) + "i " + ")"
	}
	if !forcelong {
		if rv_ != 0 && iv_ == 0 {
			if rv_ >= 0 {
				s = " " + strconv.f64_to_str(rv_,2) + ""
			} else {
				s = strconv.f64_to_str(rv_,2) + ""
			}
		} else if iv_ != 0 && rv_ == 0 {
			if iv_ >= 0 {
				s = " " + strconv.f64_to_str(iv_,2) + "i"
			} else {
				s = strconv.f64_to_str(iv_,2) + "i"
			}
		} else if iv_ == 0 && rv_ == 0 {
			s = " 0.0"
		}
	}
	return s
}
// ===================Struct CCplx ========================
fn (mut cc CCplx) add(c1 Cplx, c2 Cplx) Cplx {
	mut res := Cplx{0, 0,Glob{}}
	res.rv = c1.rv + c2.rv
	res.iv = c1.iv + c2.iv
	res.round()
	return res
}
fn (mut cc CCplx) mul(c1 Cplx, c2 Cplx) Cplx {
	mut res := Cplx{0, 0,Glob{}}
	res.rv = c1.rv * c2.rv - c1.iv * c2.iv
	res.iv = c1.rv * c2.iv + c1.iv * c2.rv
	res.round()
	return res
}
fn eq(c1 Cplx,c2 Cplx) bool {
	return c1.rv == c2.rv && c1.iv == c2.iv
}
// ===================Struct Bin ========================
struct Bin {
	mut:
	groups		[]int = []int{len:1}
						// groups of bits. p.e. 2, 3, 8 --> 
	                  	//   --> data: 1011101101010 --> 10 111 01101010 
	                  	//      (2, 3 and 8 bits)
	
	bindata		[]int = []int{len:maxqbits, init: 0}	// Less weight bit is bindata[0]
	indmax		int = -1 								// how many
}
// constructors
fn (mut bin Bin) bin1(n int) {
	bin.constructor(n, 0)
}
fn (mut bin Bin) bin2(n int, max_bits int) {
	bin.constructor(n, max_bits)
}
fn (mut bin Bin) constructor(base10_number int, how_many_bits int) {  // 0 to 2 ^ how_many_bits - 1  
	//bin.groups[0] = 0
	mut num := base10_number
	for ind := 0; num > 0; ind++ {
		mod := int(num % 2)
		num = int(num / 2)
		bin.bindata[ind] = mod
		bin.indmax++
	}
	if how_many_bits - 1 > bin.indmax {
		bin.indmax = how_many_bits - 1
	}
}
fn (mut bin Bin) getbit(bit int) int {
	if bit > bin.indmax {
		return 0
	}
	return bin.bindata[bit]
}
fn (mut bin Bin) delbit(bit int) {  // 0 to n - 1
	// change  p.e.   1000101  delBit(1) --> 100011  (deleted the second bit)   
	for i := bit; i < bin.indmax; i++ {
		bin.bindata[ i ] = bin.bindata[ i + 1 ]
	}
	bin.bindata[ bin.indmax ] = 0
	bin.indmax -= 1
}
fn (mut bin Bin) clone() Bin {
	mut ret := Bin{}
	ret.bindata = bin.bindata
	ret.groups = bin.groups	
	ret.indmax = bin.indmax
	return ret
}
fn (mut bin Bin) setgroups(groups []int)  {
	mut sumbits := 0
	for i := 0; i < groups.len; i++ {
		sumbits += groups[i]
	}
	if sumbits == bin.indmax + 1 {
		bin.groups = groups
	} 
}
fn (mut bin Bin) swap(bit1 int, bit2 int) {
	data := bin.bindata[bit1]
	bin.bindata[bit1] = bin.bindata[bit2]
	bin.bindata[bit2] = data
	if bit1 > bin.indmax {
		bin.indmax = bit1
	}
	if bit2 > bin.indmax {
		bin.indmax = bit2
	}
}
fn (mut bin Bin) tostr() string {
	mut ret := ""
	mut withgroups := bin.groups.len > 0
	
	mut indexgroup := 0
	mut maxgroup := 0
	if withgroups {
		maxgroup = bin.groups[indexgroup]
		indexgroup++
	}
	for i := bin.indmax; i >= 0; i-- {
		ret = ret + bin.bindata[i].str()
		if withgroups {
			maxgroup--
			if maxgroup == 0 && i > 0 {
				ret = ret + " "
				maxgroup = bin.groups[indexgroup]
				indexgroup++
			}
		}
	}
	return ret
}
fn (mut bin Bin) toint() int {
	mut n := 0
	for index := bin.indmax; index >= 0; index-- {
		n = n + int(math.pow(2, index)) * bin.bindata[index]
	}
	return n
}
