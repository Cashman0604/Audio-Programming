// Env.new

e = Env.new([0,1,0], [1,1], [3, -1]);
e.plot;


(
    f = {
        var sig, env;
        env = EnvGen.kr(Env.new([0,0.5,0.2,0.2,0.5,0],[0.1,0.1,3,0.2,1]), doneAction:2);
        // doneAction:2 removes it from server when done
        sig = PinkNoise.ar!2;
        sig = BPF.ar(sig, 1000, 0.1);
        sig = sig * env;
    }.play;
)

s.plotTree; // show node tree

(
    f = {
        var sig, env;
        env = EnvGen.kr(e, doneAction:2).poll;
        sig = PinkNoise.ar!2;
        sig = BPF.ar(sig, 660, 0.5);
        sig = sig * env;
    }.play;
)

// Env.perc
(
    x = {
        var sig, env;
        env = EnvGen.kr(Env.perc(0.01, 1, 1), doneAction:2);
        sig = PinkNoise.ar!2;
        sig = BPF.ar(sig, 1000, 0.1);
        sig = sig * env;
    }.play;
)

// Env.adsr
(
    x = {
        arg gate;
        var sig, env;
        env = EnvGen.kr(Env.adsr(0.01, 0.3, 0.3, 1), gate:gate, doneAction:2);
        sig = PinkNoise.ar!2;
        sig = BPF.ar(sig, 1000, 0.1);
        sig = sig * env;
    }.play;
)

x.set(\gate, 1);
x.set(\gate, 0);