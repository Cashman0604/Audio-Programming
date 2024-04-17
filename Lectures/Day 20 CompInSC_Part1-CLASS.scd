//Versatile SynthDef using a band-pass filtered Saw.ar
(
SynthDef(\bpfSaw, {
	arg freq=440, amp=0.5, rqLo=0.05, rqHi=0.1, cfLo=100, cfHi=5000, atk=2, dec=0.5, susT=1.5, rel=2, pan=0;
	var sig, env, rq, cf;
	//cf = SinOsc.ar(0.5).range(cfLo, cfHi); //Simple example of a BPF center frequency sweeping effect using SinOsc.ar
	cf = {LFNoise1.kr(LFNoise1.kr(0.5).range(0.2,1)).range(cfLo,cfHi)}!2; //Advanced version using nested LFNoise1 units to meander through the overtones of the Saw.ar with variable times (cfLo is the lowest possible frequency and cfHi is the highest)
	rq = {LFNoise1.kr(1).range(rqLo, rqHi)}!2; //rq is the 'reciprocal quality' value for the BPF below. It ranges from 0.0-1.0. Smaller values mean that more pitch will be heard. I'm using LFNoise1 to slightly alter the apparent pitch of the filter ranging from rqLo to rqHi. The lower this number the more prominent the sweeping center frequency
	env = EnvGen.kr(Env.new([0,1,0.5,0.5,0],[atk,dec,susT,rel]), doneAction:2); //Custom ADSR envelope (susT refers to the sustain time)
	sig = Saw.ar(freq * {LFNoise1.kr(0.5).range(1.001,1.008)}!2); //Using LFNoise1 to create a frequency offset to slightly detune
	sig = BPF.ar(sig, cf, rq); //band-pass filter to
	sig = Balance2.ar(sig[0],sig[1],pan); //Balance2 balances previously expanded signal in left and right channel to allow for panning. This is the more appropriate choice than Pan2, since the signal is multi-channel expanded (!2) above.
	sig = sig * env * amp;
	Out.ar(0, sig);
}).add;
)

FreqScope.new; //Load the FreqScope to see what is happening

Synth(\bpfSaw, [\rqHi, 0.1]); //Try adjusting the rqHi value up toward 1.0 to hear (and see) the difference in the pitch sweep.

//Let's make some chords
(
Pbindef(\chords).clear;
Pbindef(\chords,
	\instrument, \bpfSaw,
	\dur, 8,
	\midinote, Pxrand([ //Pxrand never repeats a chord twice in a row
		[36,48,55,64,71], //nesting arrays (chords) within the Pxrand list array.
		[38,57,65],
		[29,38,57,60,64],
		[31,53,57,60,64]
	], inf),
	\amp, Pexprand(0.3,0.5,inf), //slight amp changes
	\cfLo, 100,
	\cfHi, 600, //low value to create a darker quality of sound during the sweep. Higher cfHi value would create a brighter sound.
	\atk, 2,
	\rel, 8,
	\pan, Pwhite(-0.5,0.5,inf)
).play;
)

Pbindef(\chords).stop;

//Let's make a marimba
(
Pbindef(\marimba).clear;
Pbindef(\marimba,
	\instrument, \bpfSaw,
	\freq, Prand([1,2,4], inf), // Using freq param to alter the apparent rhythm using band pass filtered sub-audio saw tooth waves. Their freq is well below 20Hz (lowest audio rate humans can hear). Result is a resonant click sound that strongly resembles a marimba.
	\amp, 0.75,
	\rqLo, 0.005,
	\rqHi, 0.008,
	\cfLo, Prand((Scale.major.degrees+60).midicps, inf) * Prand([0.5,1,2,4], inf), // moving the filter, which is set to scale degrees in the major scale
	\cfHi, Pkey(\cfLo), //Pkey copies everything that cfLo is doing
).play;
)

Pbindef(\marimba).stop;




// Create a Performance dictionary of events
e = Dictionary.new;

(
e.add(\event1 -> { // event 1 start chords
	Pbindef(\chords,
		\instrument, \bpfSaw,
		\dur, 8,
		\midinote, Pxrand([
			[36,48,55,64,71], 
			[38,57,65],
			[29,38,57,60,64],
			[31,53,57,60,64]
		], inf),
		\amp, Pexprand(0.1, 0.2, inf),
		\cfLo, 100,
		\cfHi, 600,
		\atk, 4,
		\rel, 6,
		\pan, Pwhite(-0.5,0.5,inf)
	).play;
	"This is event 1 - Chords".postln
});

e.add(\event2 -> {
	Pbindef(\marimba,
		\instrument, \bpfSaw,
		\freq, Prand([1,3/2]),
		\amp, 0.5,
		\rqLo, 0.005,
		\rqHi, 0.008,
		\cfLo, Prand((Scale.major.degrees+60).midicps, inf) * Prand([0.5,1], inf),
		\cfHi, Pkey(\cfLo),
	).play;
	"This is event 2 - Add Marimba".postln;
});

e.add(\event3 -> {
	Pbindef(\marimba,
		\freq, Prand([1,3/2,2,4]),
		\cfLo, Prand((Scale.major.degrees+60).midicps, inf) * Prand([0.5,1,2], inf),
	).play;
	Pbindef(\chords,
		\cfHi, 1000 // brighten sound of chords
	).play;
	"This is event 3 - Expand Marimba".postln;
});

e.add(\event4 -> {
	Pbindef(\marimba,
		\freq, Prand([1,2,4,8]),
		\cfLo, Prand((Scale.major.degrees+60).midicps, inf) * Prand([0.5,1,2,4], inf),
	).play;
	Pbindef(\chords,
		\cfHi, 1500 
	).play;
	"This is event 4 - Expand Marimba".postln;
});

e.add(\event5 -> {
	{
		Pbindef(\marimba,
			\amp, Pseg(levels:[0.5,0],durs:10,curves:'lin',repeats:1) //Pseg is the envelope pattern to create a fade out 
		).play;
		Pbindef(\chords,
			\midinote, [36,48,55,64,71], // final C chord
			\cfHi, 600
		).play;
		20.wait;
		Pbindef(\chords).stop;
	}.fork;
	"This is event 5 - Fade Out".postln;
});

)

e[\event1].value; //Runs event 1
e[\event2].value; //Runs event 2
e[\event3].value; //Runs event 3
e[\event4].value; //Runs event 4
e[\event5].value; //Runs event 5