
foreach file [glob d:/tmp/*.wav] {
puts "Processing: $file"
update

snack::sound snd -load $file

set fd [open [file rootname $file].f0 w]
puts $fd [join [snd pitch -method esps] \n]
close $fd

set fd [open [file rootname $file].frm w]
puts $fd [join [snd formant -numformants 4 -windowtype Hamming -windowlength .020 -framelength .01  -lpctype 1 -lpcorder 12 -preemphasisfactor .7] \n]
close $fd
} 