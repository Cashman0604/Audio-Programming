// Part 1
(
SynthDef.new(\saw, {
	arg freq=400, atk=0.01, rel=1. amp=0.2, out=0;
	var sig, env;
	env = EnvGen.kr(Env.perc(atk,rel),doneAction:2);
	sig = Saw.ar([freq, freq * 0.2.midiratio], width:0.5);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

Synth(\saw);

// Pbind
(
p = Pbind(
	\instrument, \saw,
	\dur, 0.2,
	\scale, Scale.minorPentatonic,
	\degree, Pxrand([0,1,2,3,4,5], inf),
	\amp, Pexprand(0.05,0.3),
	\atk, 0.01,
	\rel, 0.3,
	\out, 0
);

x = p.play;
)


// Pdefn
(
p = Pbind(
	\instrument, \saw,
	\dur, 0.2,
	\scale, Scale.minorPentatonic,
	\degree, Pdefn(\defVarSaw, Pxrand([0,1,2,3,4,5], inf)),
	\amp, Pexprand(0.05,0.3),
	\atk, Pdefn(\atkVarSaw,0.01),
	\rel, 0.3,
	\out, 0
);

x = p.play;
)

// Test for Pdefn
Pdefn(\defVarSaw, Pxrand([2,3,4,5,6,7,8], inf));

Pdefn(\atkVarSaw,0.05)

// Part 3 - GUI
(
w.close;
w = Window.new("Music Man", Rect.new(1200,400,600,400));
w.front;
)

// Composite View
(
//w.close;
w = Window.new("Music Man", Rect.new(1200,400,600,400));
w.front;

~panel1= CompositeView.new(w, Rect.new(0,0,300,175))
.background_(Color.grey);

~panel2= CompositeView.new(w, Rect.new(300,0,300,175))
.background_(Color.black);

// Static text
~staticBlipTxt = StaticText.new(~panel1, Rect.new(45,25,202,25))
.string_("Blip Instrument Controls")
.font_(Font("Monaco", 14))
.background_(Color.white)
.stringColor_(Color.red);

~staticVarTxt = StaticText.new(~panel2, Rect.new(50,25,195,25))
.string_("Saw Instrument Controls")
.font_(Font("Monaco", 14))
.background_(Color.white)
.stringColor_(Color.red);

~slSawLev = Slider.new(~panel2, Rect.new(75,125,150,25))
.action_({
	arg sl;
	sl.value.postln;
	Pdefn(\sawLev, sl.value)
})
.valueAction_(1);

// Start/Stop button for saw
~sawStartBtn = Button.new(~panel2, Rect(125,62,50,50))
.action_({
	arg btn;
	if (btn.value == 1) {
		~sawStream = ~sawStartPatt.play;
	} {
		~sawStream.stop;
	}
})
.states_([["OFF"], ["ON"]]);
)


(
SynthDef.new(\saw, {
	arg freq=400, atk=0.01, rel=1. amp=0.2, lev=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env.perc(atk,rel),doneAction:2);
	sig = Saw.ar([freq, freq * 0.2.midiratio], width:0.5);
	sig = sig * env * amp * lev;
	Out.ar(out, sig);
}).add;
)

Synth(\saw);


(
~sawStartPatt = Pbind(
	\instrument, \saw,
	\dur, 0.25,
	\scale, Scale.minorPentatonic,
	\degree, Pdefn(\defVarSaw, Pxrand([[0,2,4],[1,3,4],1,2,3,4,5], inf)),
	\amp, Pexprand(0.05,0.3),
	\atk, Pdefn(\atkVarSaw,0.01),
	\rel, 0.3,
	\lev, Pdefn(\sawLev, 1),
	\out, 0
);
)

(
~blipStartPatt = Pbind(
	\instrument, \saw,
	\dur, Pwrand([0.5,0.25],[0.9,0.1],inf),
	\scale, Scale.minorPentatonic,
	\degree, Pdefn(\defVarSaw, Pxrand([[0,2,4],[1,3,4],1,2,3,4,5], inf)),
	\octave, 2,
    \amp, Pexprand(0.05,0.3),
	\atk, Pdefn(\atkVarSaw,0.01),
	\rel, 0.3,
	\lev, Pdefn(\sawLev, 1),
	\out, 0
);
)

~sawStream = ~sawStartPatt.play(quant:1);
~blipStream = ~blipStartPatt.play(quant:1);