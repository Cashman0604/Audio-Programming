// .do loops

// below all do same thing
4.do { arg i; i.postln }; // auto create array and performs funct  (0,1,2,3)

[0,1,2,3].do {arg i; i.postln};

(0..3).do{arg i; i.postln};

// .do loop challenge
(
    SynthDef(\sine, {
        arg freq=440, amp=0.2;
        var sig, env;
        env = EnvGen.kr(Env.perc(0.01, 0.05), doneAction:2);
        sig = SinOsc.ar(freq!2);
        sig = sig * env * amp;
        Out.ar(0, sig);
    }).add;
)

Synth(\sine);

// Routine
(
    r = Routine{
        var startNote = 60;
	    var steps = [2,2,1,2,2,2,1];
        2.do {
            steps.do{
                arg i;
			    startNote.postln;
                startNote = startNote + i;
                Synth(\sine, [\freq, startNote.midicps]);
                0.1.wait;
            };
        };
    };
)

r.play;


// .while loops
(
    c = 0;
    {
        {c < 20}.while{
            Synth(\sine, [\freq, rrand(60, 96).midicps, \amp, exprand(0.125, 0.25)]);
            w = rrand(0.1,0.25);
            c = c + w;
		    c.postln;
		    w.wait;
        };
    }.fork;
)
// .fork performs same action as Routine{...}.play;


// Buffers
~glass = Buffer.read(s, "C:/Users/belkn/OneDrive/Documents/GitHub/Audio-Programming/Lectures/Day-9/sounds/glass.wav")

~glass.play;

Buffer.freeAll;

(
    SynthDef(\bufPlay, {
        arg buf=0, rate=1, spos=0, amp=0.5, panpos=0;
        var sig;
        sig = PlayBuf.ar(
            numChannels:1, bufnum:buf, rate: BufRateScale.kr(buf) * rate,
            trigger: 1, startPos: spos, doneAction:2
        );
        sig = sig * amp;
        sig = Pan2.ar(sig, panpos);
        Out.ar(0, sig);
    }).add;
)

Synth(\bufPlay);

// .while loop
(
    c = 0;
    {
        {c < 20}.while{
            x = [0, 4, 7];
            t = [-4, -2, 0, 2, 4].choose;
            (x + t).do{
                arg note;
                Synth(\bufPlay,
                    [\buf, 0, \rate, [-1,1].choose * note.midiratio,
                    \spos, rrand((~glass.numFrames * 0.01), (~glass.numFrames * 0.35)),
                    \panpos, rrand(-1, 1), \amp, exprand(0.25,0.5)]
                );
            };
            w = rrand(1, 3);
            c = c + w;
            c.postln;
            w.wait;
        };
    }.fork;
)