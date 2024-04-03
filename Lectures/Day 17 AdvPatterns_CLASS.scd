//ADVANCED PATTERNS and CUSTOM CLOCKS

//Load these first
(
SynthDef(\tone,{
	arg freq=440, amp=0.1, atk=0.01, rel=0.1, out=0;
	var sig, env;
	env = EnvGen.kr(Env.perc(atk,rel),doneAction:2);
	sig = SinOsc.ar(freq!2);
	sig = sig * env * amp;
	Out.ar(out,sig)
}).add;
)

(
SynthDef(\noise,{
	arg amp=0.2, atk=0.01, rel=0.1, out=0;
	var sig, env;
	env = EnvGen.kr(Env.perc(atk,rel),doneAction:2);
	sig = PinkNoise.ar(amp!2);
	sig = sig * env * amp;
	Out.ar(out,sig)
}).add;
)

//Test
Synth(\tone);
Synth(\noise);

//Load a pattern
(
~tonePatt = Pbind(
	\instrument, \tone,
	\freq, Pseq([200,300,400,500],inf),
	\amp, 0.1,
	\dur, 1
);
)

//Test the pattern
~toneStream = ~tonePatt.play;
~toneStream.stop;


// Pdefn
(
~tonePatt = Pbind(
	\instrument, \tone,
	\freq, Pdefn(\freqTone, Pseq([200,300,400,500],inf)),
	\amp, 0.1,
	\dur, 1
);
)


// Better than Pdefn = Pbindef
(
Pbindef(\p).clear;

Pbindef(\p, 
	\instrument, \tone,
	\freq, Pseq([200,300,400,500],inf),
	\amp, 0.1,
	\dur, 1
	).play;
)

Pbindef(\p).stop;

Pbindef(\p).play(t);



// Tempo Clock
TempoClock.default.tempo;

TempoClock.default.beats;

t = TempoClock.new(108/60);

t.beats;

t.beatsPerBar;

t.tempo;

// Post the current beat in the post window
~postBeats = {t.beats.postln};

t.schedAbs(t.nextBar, {~postBeats.value});

// tempo clock trick
~postBeats = {t.beats.postln; 1};
t.schedAbs(t.nextBar, {~postBeats.value});

// CMD+. removes custon tempo clocks

// Clump it together
(
t = TempoClock.new(108/60);
~postBeats = {t.beats.postln; 1};
t.schedAbs(0, {~postBeats.value});
)

(
t.schedAbs(16, {t.tempo_(180/60)});
t.schedAbs(24, {t.tempo_(60/60)});
)

// Now...
(
t = TempoClock.new(60/60);
~postBeats = {t.beats.postln; 1};
t.schedAbs(0, {~postBeats.value});


{
Pbindef(\tone,
		\instrument, \tone,\
		\scale, Scale.minor,
		\degrees, Pseq([
			4,\,1,2,
			3,\,2,1,
			0,\,\,2,
			4,\,3,2,
			1,\,\,2,
			3,\,4,\,
			2,\,0,\,
			0,\,\,\
		], inf),
		\dur, 0.25
).play(t, quant:4);
}.defer(1);

{
	Pbindef(\hh).clear;
	Pbindef(\hh,
		\instrument, \noise,
		\amp, Pseq([0.2,0.2,0.2,0.2,0.2,0.2,0.7,0.2], inf),
		\dur, 0.25,
	).play(t, quant:4);
}.defer(4);

{t.schedAbs(20, {t.tempo_(180/60);})}.defer(10);

)
