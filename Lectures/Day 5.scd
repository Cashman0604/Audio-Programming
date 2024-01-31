// LFNoise

{LFNoise1.ar(20);}.plot(1);


(
    f = {
        var sig, freq;
        freq = LFNoise0.ar(10).range(40, 10000).poll;
        sig = SinOsc.ar(freq)!2;
        sig = sig * 0.01;
    }.play;
)


(
    f = {
        arg amp=0.05, freq=440;
        var sig, freqCtrl;
        // as freq changes, range changes bc freq logorithmic
        // use midiratio to make ratio change instead of flat change
        freqCtrl = freq * LFNoise1.kr(2!4).range(-0.1,0.1).midiratio;
        freqCtrl.poll;
        sig = Saw.ar(freqCtrl) * amp;
        sig = Splay.ar(sig);
    }.play;
)

f.set(\freq, 60);


// SynthDef
(
    SynthDef.new(\saw, {
        arg amp=0.05, freq=440;
        var sig, freqCtrl;
        // as freq changes, range changes bc freq logorithmic
        // use midiratio to make ratio change instead of flat change
        freqCtrl = freq * LFNoise1.kr(2!4).range(-0.1,0.1).midiratio;
        // freqCtrl.poll;
        sig = Saw.ar(freqCtrl) * amp;
        sig = Splay.ar(sig);
        Out.ar(0, sig); // 0 sends to first hardware output
    }).add;
)

Synth.new(\saw, [\amp, 0.02, \freq, 220]);

(
    Synth.new(\saw, [\amp, 0.02, \freq, 220]);
    Synth.new(\saw, [\amp, 0.02, \freq, 277.183]);
    Synth.new(\saw, [\amp, 0.02, \freq, 660]);
    Synth.new(\saw, [\amp, 0.02, \freq, 880]);
)

// More musical
(
    SynthDef.new(\saw, {
        arg amp=0.05, freq=440;
        var sig, freqCtrl env;
        env = EnvGen.kr(Env.new(times:[2,3], curve:[-3,3]), doneAction:2);
        freqCtrl = freq * LFNoise1.kr(2!4).range(-0.1,0.1).midiratio;
        sig = Saw.ar(freqCtrl) * amp * env;
        sig = Splay.ar(sig);
        Out.ar(0, sig);
    }).add;
)

(
    Synth.new(\saw, [\amp, 0.02, \freq, 33.midicps]);
    Synth.new(\saw, [\amp, 0.02, \freq, 45.midicps]);
    Synth.new(\saw, [\amp, 0.02, \freq, 52.midicps]);
    Synth.new(\saw, [\amp, 0.02, \freq, 61.midicps]);
)

// Basic Iteration
(
    [33, 45, 52, 61].do({
        "hello".postln;
    })
)

(
    [33, 45, 52, 61].do{
        arg note;
        Synth.new(\saw, [\amp, 0.03, \freq, note.midicps])
    };
)