import math
import strconv
const (
	ndecimals = 6				// number of decimals to round
	ndecimals_visual = 3 		// number of decimals to round
	zero = Cplx{0, 0,Glob{}}
	one = Cplx{1,0,Glob{}}
	minus_one = Cplx{-1,0,Glob{}}
)
struct Glob {
	mut:
	maxqbits			int = 100
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
fn main() {
	mut cero := Cplx{0, 0,Glob{}}
	mut uno := Cplx{1, 0,Glob{}}
	mut menos_uno := Cplx{-1, 0,Glob{}}
	mut imaginary := Cplx{0,1,Glob{}}
	mut menos_imaginary := Cplx{0,-1,Glob{}}
	mut z1 := Cplx{2,3,Glob{}}
	mut z2 := Cplx{2.123,-3.87,Glob{}}

	print1(cero.tostr())
	print1(uno.tostr())
	print1(menos_uno.tostr())
	print1(cero.to_str(true))
	print1(uno.to_str(true))
	print1(menos_uno.to_str(true))
	//mut glob := Glob{}
	//mut cplx := Cplx{}
	print1(imaginary.tostr())
	print1(menos_imaginary.tostr())
	print1(imaginary.to_str(true))
	print1(menos_imaginary.to_str(true))	
	print1(z1.tostr())
	print1(z2.tostr())
	
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
	mut tit := "" + glob.charl.str() + glob.charl.str() + " " + title + " "
	tit = glob.completeline(tit)
	println("")
 	glob.line2(false)
	println(tit)
	glob.line2(false)
}
fn (glob Glob) completeline(line string) string {
	mut lineret := line
	for lineret.len < glob.mchar {
		lineret = lineret + glob.charl.str()
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
