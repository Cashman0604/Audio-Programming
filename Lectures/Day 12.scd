// More advanced patterns
(
    p = Pbind(
        \degree, Pxrand([0,1,2,3,4,5,6,7], inf), //doesn't repeat notes 2 times in a row
        \sustain, 0.1,
        \amp, Pexprand(0.05,0.5), // logorithmic rrand; == to exprand
        // Pwhite for == to rrand (even distribution)
        \dur, 0.8
    );

    x = p.trace.play;
)

(
    p = Pbind(
        \degree, Pwrand([0,1,2], [0.95,0.04,0.01], inf), // randomize based on weights
        \sustain, 0.1,
        \amp, Pexprand(0.05,0.5),
        \dur, 0.8
    );

    x = p.trace.play;
)


exprand(0.1,1);



// Pbind with SynthDef
(
    SynthDef.new(\pbind_test, {
        arg freq=400, atk=0.01, rel=1, amp=0.2, out=0;
        var sig, env;
        env = EnvGen.kr(Env.perc(atk,rel), doneAction:2);
        sig = Saw.ar([freq, freq * 0.2.midiratio]);
        sig = sig * env * amp;
        Oot.ar(out, sig);
    }).add;
)

Synth(\pbind_test);

(
    p = Pbind(
        \instrument, \pbind_test,
        \dur, 0.2,
        \scale, Scale.minorPentatonic,
        \degree, Pxrand([0,1,2,3,4,5], inf),
        \amp, Pexprand(0.05,0.3),
        \atk, 0.01,
        \rel, Pwrand([0.3,1,2],[0.50,0.30,0.20], inf),
        \out, 0
    );

    x = p.play;
)