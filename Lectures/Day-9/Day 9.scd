// Buffers
b = Buffer.read(s, "/sounds/glass.wav");

b.play;

b.numChannels;
b.bufnum;
b.duration;
b.sampleRate;
b.numFrames; // duration * sampleRate

~numSamples = b.numChannels * b.sampleRate * b.duration;

Buffer.freeAll;

// SynthDef with Buffers

(
    SynthDef.new(\bufplay, {
        arg buf=0, rate=1, amp=0.5, spos=0, panpos=0;
        var sig;
        sig = PlayBuf.ar(
            1, buf, BufRateScale.kr(buf) * rate,
            trigger: 1, startPos: spos,
            doneAction:2
        );
        sig = sig * amp;
        sig = Pan2.ar(sig, panpos);
        Out.ar(0, sig);
    }).add;
)

Synth(\bufplay);

(
    x = Synth.new(\bufplay, args:[
        \buf, b.bufnum,
        \rate, rrand(0.5, 4),
        \spos, rrand((b.numFrames * 0.005), (b.numFrames * 0.3)),
        \amp, exprand(0.5, 2.0)
    ]);
)


// Routine
(
    r = Routine {
        {
            Synth.new(\bufplay, args:[
                \buf, b.bufnum,
                \rate, rrand(0.5, 4),
                \spos, rrand((b.numFrames * 0.005), (b.numFrames * 0.3)),
                \amp, exprand(0.5, 2.0)
            ]);
            rrand(0.01,1).wait;
        }.loop;
    }play;
)

// Tuned
(
    r = Routine {
        {
            Synth.new(\bufplay, args:[
                \buf, b.bufnum,
                \rate, [-12,-7,-5,-2,0,2,4,5,7].choose.midiratio,
                \spos, rrand((b.numFrames * 0.005), (b.numFrames * 0.3)),
                \amp, exprand(0.5, 2.0)
            ]);
            rrand(0.01,1).wait;
        }.loop;
    }play;
)

r.stop;