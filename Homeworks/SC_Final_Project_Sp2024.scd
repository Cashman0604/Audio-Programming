////SUPERCOLLIDER FINAL PROJECT////


//GENERAL PARAMETERS
/*

Create a piece (at least 1.5 minutes in length) of MUSIC or ABSTRACT SOUND DESIGN. It should include the following at a minimum:

(1) Two sound SynthDefs; you're free to use PlayBuf for recorded sounds for one of them if you would like. You may use SynthDefs from class or from your previous projects if you would like.
(2) One audio effect SynthDef with stereo input (reverb, for example). You may use the audio effect SynthDefs studied in class (reverb, delay, comb, etc.).
(3) A Dictionary which contains at least 4 “events” (patterns or one-shots [a one-shot could be an iterative Routine, for example]). You must fully customize your own Pbindefs. Use class examples for assistance, but DO NOT COPY.
(4) Screen capture a performance of your full piece and setup. Use OBS, Zoom or the capture software of choice. You can use SuperCollider to record your piece. Make sure that the final audio output is high-quality stereo.

SUBMIT:
(1) A link to your final performance in the comments.
(2) Your customized final piece file.

We will discuss how to create a project file that loads itself (with a single click) in class. Use the project file to house all of your project elements.

For the final class day on April 29th, 2024:
Video record at least TWO of your project's "events". You may record your entire project if you are that far along!

Share your video in class on the final class day!

*/

s.makeGui; //hit record in the GUI to begin recording stereo output from SC

(
r = Routine({
	e[\event0].value;
	8.wait;
	e[\event1].value;
	14.wait;
	e[\event2].value;
	8.wait;
	e[\event3].value;
	8.wait;
	e[\event4].value;
	12.wait;
	e[\event5].value;
	16.wait;
	e[\event6].value;
	14.wait;
	e[\event7].value;
	10.wait;
	e[\eventEND].value;
})
)

r.play;

(
//1. Server config
s = Server.local;

s.options.inDevice_("Default");

s.options.outDevice_("Headphones (High Definition Aud");

s.options.sampleRate_(48000);

ServerBoot.removeAll;
ServerQuit.removeAll;
ServerTree.removeAll;

//2. Initialize global variables

~out = 0;
~path = PathName(thisProcess.nowExecutingPath).parentPath;

//3. Define functions for the piece (for loading buffers, events, MIDIdef, GUI, etc.)
~makeBuffers = {
	~gCube = Buffer.read(s, ~path ++ "sounds/GameCube.mp3");
	~gCubeFull = Buffer.read(s, ~path ++ "sounds/GameCubeFull.mp3");
	~gCubeSHit = Buffer.read(s, ~path ++ "sounds/StartHit.wav");
	~gCubeEHit = Buffer.read(s, ~path ++ "sounds/EndHit.wav");
	// "~gCubeFull: ".post; ~gCubeFull.postln;
};

~makeBusses = {
	~mainBus = Bus.audio(s, 2);
};

~makeEvents = {
	// ~tempoClock = TempoClock(2);
    e = Dictionary.new;

	e.add(\event0 -> {
		"Event 0 - Chords and Start Hit".postln;
		Pbindef(\chords,
			\instrument, \bpfSaw,
			\dur, 1,
			\midinote, Pxrand([
				[60,64,67,70],
				[60,63,67,70],
				[64,67,72],
				[58,62,65,67]
			], inf),
			\amp, Pexprand(1.25,1.6),
			\cfLo, 300,
			\cfHi, 800,
			\atk, 0.2,
			\rel, 1,
			\pan, Pwhite(-0.5,0.5,inf),
			\group, ~synthGrp,
			\out, ~mainBus
		).play;

		~gcStHit = Routine({
			(7.5).wait;
			{
				Synth.new(\bufPlayer, [
                        \buf, ~gCubeSHit,
                        \rate, 1,
                        \amp, exprand(1,1.5),
                        \pan, 0,
                        \out, ~mainBus
                    ], ~fxGrp);
			}.fork;
		}).play;
	});

    e.add(\event1 -> {
		~gcStHit.stop;
        ~gcFull = Routine({
            var plays = 1, rate = 0.75;
            var durInS = (~gCubeFull.numFrames / s.sampleRate).asInteger;
            {
                {
                    Synth.new(\bufPlayer, [
                        \buf, ~gCubeFull,
                        \rate, rate,
                        \spos, ~gCubeFull.numFrames * (1.0001 - (1/plays)),
                        \amp, exprand(0.1,0.5),
                        \pan, rrand (-0.5,0.5),
                        \out, ~mainBus
                    ], ~synthGrp);
                    plays = plays + 1;
                    if (plays > 2) { plays = 1; };
                }.fork;
				(((durInS * (1/plays)) + 0.2) / rate).wait;
            }.loop;
        }).play;
		"Event 1 - Add GameCube Notes".postln;
    });

	e.add(\event2 -> {
		~gcFull.stop;
		~gcHit = {
			{
					Synth.new(\bufPlayer, [
						\buf, ~gCube,
						\rate, ([-7,-5,-3,-1,0,2,4,5,7]+6).choose.midiratio,
						\amp, exprand(0.9,1.6),
						\pan, rrand(-1,1),
						\out, ~mainBus
					], ~synthGrp);
				(exprand(0.1,0.5)).wait;
				}.loop;
			}.fork;
		Pbindef(\chords,
			\amp, Pexprand(1.4,1.7),
			\cfLo, 100,
			\chHi, 1000
		).play;
		"Event 2 - Add Random GameCube Notes".postln;
	});

	e.add(\event3 -> {
		var hits = [0,5,4,-2,1,0,-6,-1,-3];
		~gcMel = {
			var i = 0;
			{
				Synth.new(\bufPlayer, [
					\buf, ~gCube,
					\rate, hits[i].midiratio,
					\amp, exprand(0.9,1.6),
					\pan, rrand(-1,1),
					\out, ~mainBus
				], ~synthGrp);
				i = i + 1;
				if (i > (hits.size - 1)) {
					i = 0;
					if (~gcHit.isPlaying) {~gcHit.stop;};
				};
				(0.25).wait;
			}.loop;
		}.fork;
		"Event 3 - Add defined structure".postln;
	});

	e.add(\event4 -> {
		Pbindef(\notes,
			\instrument, \bpfSaw,
			\dur, 1,
			\freq, ([[0,2,5],[0,3,7],[-3,0,2,7],[-2,2,7]].choose).midiratio,
			\amp, Pexprand(0.8,1.2),
			\pan, Pwhite(-1,1),
			\rel, Pwhite(1,2),
			\cfLo, 100,
			\cfHi, 300,
			\out, ~mainBus,
			\group, ~synthGrp
		).play;
		"Event 4 - Add low thumping".postln;
	});

	e.add(\event5 -> {
		var hits = [-3,0,4,2,-1,2,5,4];
		~gcFull = Routine({
            var plays = 1, rate = 1;
            var durInS = (~gCubeFull.numFrames / s.sampleRate).asInteger;
            {
                {
                    Synth.new(\bufPlayer, [
                        \buf, ~gCubeFull,
                        \rate, rate,
                        \spos, ~gCubeFull.numFrames * (1.0001 - (1/plays)),
                        \amp, exprand(0.05,0.25),
                        \pan, rrand (-0.5,0.5),
                        \out, ~mainBus
                    ], ~synthGrp);
                    plays = plays + 1;
                    if (plays > 2) { plays = 1; };
                }.fork;
				(((durInS * (1/plays)) + 0.2) / rate).wait;
            }.loop;
        }).play;

		~gcMel.stop;

		~gcMel = {
			var i = 0;
			{
				Synth.new(\bufPlayer, [
					\buf, ~gCube,
					\rate, hits[i].midiratio,
					\amp, exprand(1.2,1.6),
					\pan, rrand(-1,1),
					\out, ~mainBus
				], ~synthGrp);
				i = i + 1;
				if (i > (hits.size - 1)) {
					i = 0;
					if (~gcHit.isPlaying) {~gcHit.stop;};
				};
				(0.25).wait;
			}.loop;
		}.fork;
		"Event 5 - Add Gamecube Notes and change structure ".postln;
	});

	e.add(\event6 -> {
		~gcMel.stop;

		Pbindef(\notes,
			\freq, ([0,2,4,5,7,9,10].choose).midiratio
		).play;
		Pbindef(\chords).stop;
		Pbindef(\chords,
			\instrument, \bpfSaw,
			\dur, 1,
			\midinote, Pxrand([
				[57,60,64],
				[62,65,70,72],
				[58,62,65,67],
				[64,67,70]
			], inf),
			\amp, Pexprand(1.25,1.6),
			\cfLo, 300,
			\cfHi, 800,
			\atk, 0.2,
			\rel, 1,
			\pan, Pwhite(-0.5,0.5,inf),
			\group, ~synthGrp,
			\out, ~mainBus
		).play;
		"Event 6 - Stop structure and change low hits and chords".postln;
	});

	e.add(\event7 -> {
		~gcFull.stop;
		~gcEnHit = Routine({
			{
				3.wait;
				Synth.new(\bufPlayer, [
                        \buf, ~gCubeEHit,
                        \rate, 1,
                        \amp, exprand(1.2,1.7),
                        \pan, 0,
                        \out, ~mainBus
                    ], ~fxGrp);
			}.fork;
		}).play;
		"Event 7 - Play the final Hit sound".postln;
	});



	e.add(\eventEND -> {
		~gcStHit.stop;
		~gcEnHit.stop;
		~gcFull.stop;
		~gcHit.stop;
		~gcMel.stop;
		Pbindef(\notes).stop;
		Pbindef(\chords).stop;
		"Event End".postln;
	});
};

~cleanup = {
	ServerBoot.removeAll;
	ServerQuit.removeAll;
	ServerTree.removeAll;
};

~makeNodes = {
	~synthGrp = Group.new;
	~fxGrp = Group.after(~synthGrp);
	~reverbSynth = Synth.new(\reverb, [
		\mix, 0.5,
		\room, 0.5,
		\damp, 0.2,
		\in, ~mainBus,
		\out, ~out
	],
	~fxGrp
	);
};

//4. Register the functions with ServerBoot, ServerQuit, ServerTree
ServerBoot.add(~makeBuffers);
ServerBoot.add(~makeBusses);
ServerQuit.add(~cleanup);

//5. Boot the server and load remaining elements
s.waitForBoot({
	s.sync; // wait till everything above is ready

	// SynthDefs
	SynthDef.new(\bufPlayer, {
		arg buf=0, rate=1, amp=1, spos=0, pan=0, out=0;
		var sig;
		sig = PlayBuf.ar(
			numChannels: 2,
			bufnum: buf,
			rate: BufRateScale.kr(buf) * rate,
			startPos: spos,
			doneAction: 2
		);
		sig = Pan2.ar(sig, pan);
		sig = sig * amp;
		Out.ar(out, sig);
	}).add;

	SynthDef(\bpfSaw, {
		arg freq=440, amp=0.5, rqLo=0.05, rqHi=0.1, cfLo=100, cfHi=5000, atk=2, dec=0.5, susT=1.5, rel=2, pan=0, out=0;
		var sig, env, rq, cf;
		cf = {LFNoise1.kr(LFNoise1.kr(0.5).range(0.2,1)).range(cfLo,cfHi)}!2;
		rq = {LFNoise1.kr(1).range(rqLo, rqHi)}!2;
		env = EnvGen.kr(Env.new([0,1,0.5,0.5,0],[atk,dec,susT,rel]), doneAction:2);
		sig = Saw.ar(freq * {LFNoise1.kr(0.5).range(1.001,1.008)}!2);
		sig = BPF.ar(sig, cf, rq);
		sig = Balance2.ar(sig[0],sig[1],pan);
		sig = sig * env * amp;
		Out.ar(out, sig);
	}).add;


	SynthDef.new(\reverb, {
		arg in, mix=0.5, room=0.5, damp=0.2, out=0;
		var sig;
		sig = In.ar(in, 2);
		sig = FreeVerb.ar(sig, mix, room, damp);
		Out.ar(out,sig);
	}).add;

	s.sync;

	ServerTree.add(~makeNodes);
	ServerTree.add(~makeEvents);
	s.freeAll;

	s.sync;

	"Loading Complete".postln;
	// "~gCubeFull after loading: ".post; ~gCubeFull.postln;
});

)

r.play;



































