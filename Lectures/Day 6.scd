// SynthDef

// Steps to creating a synthdef:
// 1. Give it a name.
// 2. Add to server (using .add method)
// 3. Ass Out.ar to output sig


(
    SynthDef(\saw, {
        arg freq=440, amp=0.05, gate=1;
        var sig, env;
        env = EnvGen.kr(Env.adsr(0.3, 0.3, 0.5, 3), gate, doneAction:2);
        sig = Saw.ar(freq)!2 * amp *env;
        Out.ar(0, sig);
    }).add;
)

Synth.new(\saw);

(
    x = [33,45,52,61].collect{
        arg note;
        Synth.new(\saw, [\freq, note.midicps]);
    };
)

x[0].set(\gate, 0);
x[1].set(\gate, 0);
x[2].set(\gate, 0);
x[3].set(\gate, 0);

(
    x.do{
        arg synth;
        synth.set(\gate, 0);
    };
)



// Dolby THX sound

(
    x = {
        arg amp=0.05, freq=440;
        var lowRange, highRange, freqCtrl, sig;
        lowRange = Line.kr(-2, -0.1, 15);
        highRange = Line.kr(2, 0.1, 14);
        freqCtrl = freq * LFNoise1.kr(2!12).range(lowRange, highRange).midiratio;
        sig = Saw.ar(freqCtrl);
        sig = sig * amp;
        sig = Splay.ar(sig);
    }.play;
)


(
    SynthDef(\saw, {
        arg amp=0.05, freq=440, gate=1;
        var lowRange, highRange, freqCtrl, sig, env;
        lowRange = Line.kr(-10, -0.1, 10);
        highRange = Line.kr(10, 0.1, 10);
        freqCtrl = freq * LFNoise1.kr(0.3).range(lowRange, highRange).midiratio;
        env = EnvGen.kr(Env.adsr(0.5,0.1,1,4), gate, doneAction:2);
        sig = {Saw.ar(freqCtrl)}!12;
        sig = sig * amp * env;
        sig = Splay.ar(sig);
        Out.ar(0, sig);
    }).add;
)

(
    x = 20.collect{
        Synth(\saw, [\amp, 0.02, \freq, [55,110,220,440,660,880].choose]);
    };
)

(
    x.do{
        arg synth;
        synth.set(\gate, 0);
    };
)