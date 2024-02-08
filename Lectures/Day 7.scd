
// VarSaw width example
(
    x = {
        arg width=0.5;
        VarSaw.ar(220, width:width) * 0.03;
    }.play();
)

x.set(\width, 0.6);

FreqScope.new;

(
SynthDef(\varSaw, {
    arg freq=440, amp=0.1, rel=2.5, relW=2.5;
    var sig, envW, env;
    env = EnvGen.kr(Env([0,1,0.5,0.5,0], [1.5,0.5,1,rel], [0,-3,0,3]), doneAction:2);
    envW = EnvGen.kr(Env([0.8,0.1,0.8], [1.5,relW], [-4,4]), doneAction:2);
    sig = VarSaw.ar(freq, width:envW)!2;
    sig = sig * amp * env;
    Out.ar(0, sig);
}).add;
)

Synth(\varSaw, args:[\freq, 220, \amp, 0.1]);


(
    Routine{
        Synth(\varSaw, args:[\freq, 220, \amp, 0.1]);
        2.wait;
        Synth(\varSaw, args:[\freq, 440, \amp, 0.1]);
    }.play;
)

(
    Routine{
        x = [36, 43, 52];
        x.collect{
            arg note;
            Synth(\varSaw, args:[\freq, note.midicps, \amp, 0.1]);
        };
        3.wait;
        (x+3).collect{
            arg note;
            Synth(\varSaw, args:[\freq, note.midicps, \amp, 0.1]);
        };
        3.wait;
        (x+6).collect{
            arg note;
            Synth(\varSaw, args:[\freq, note.midicps, \amp, 0.1]);
        };
        7.wait;

        x.collect{
            arg note;
            Synth(\varSaw, args:[\freq, note.midicps, \amp, 0.1]);
        };
        1.wait;
        (x+12).collect{
            arg note;
            Synth(\varSaw, args:[\freq, note.midicps, \amp, 0.1]);
        };
        3.wait;
        (x+3).collect{
            arg note;
            Synth(\varSaw, args:[\freq, note.midicps, \amp, 0.1]);
        };
        1.wait;
        (x+15).collect{
            arg note;
            Synth(\varSaw, args:[\freq, note.midicps, \amp, 0.1]);
        };
        3.wait;
        (x+6).collect{
            arg note;
            Synth(\varSaw, args:[\freq, note.midicps, \amp, 0.1]);
        };
        1.wait;
        (x+18).collect{
            arg note;
            Synth(\varSaw, args:[\freq, note.midicps, \amp, 0.1, \rel, 8, \relW, 9.5]);
        };
        2.wait;
        (x+30).collect{
            arg note;
            Synth(\varSaw, args:[\freq, note.midicps, \amp, 0.1, \rel, 5, \relW, 6.5]);
        };
    }.play;
)