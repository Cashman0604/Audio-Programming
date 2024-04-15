s.boot;
s.reboot;


// Device Setup

// Reference Site: http://doc.sccode.org/Reference/AudioDeviceSelection.html

// Mac OSX && Windows ISA
ServerOptions.devices;

"inputs ".post; ServerOptions.inDevices;
"outputs ".post; ServerOptions.outDevices;

// Windows
// o = Server.default.options;
// o.inDevice_();




// Change Device
(
s.options.inDevice_(
    "Desktop Microphone"
);


s.options.outDevice_(
    "Headphones"
);
)

s.reboot;

// Simple mic input
x = {SoundIn.ar(0!2)}.play;

x.free;



// Ring Modulator
(
x = {
    var sig, rmod;
    sig = SoundIn.ar(0!2);
    rmod = sig * SinOsc.ar(700);
    (sig + rmod) * 0.5;
}.play;
)

// SynthDef
(
SynthDef.new(\mic,{
    var sig;
    sig = SoundIn.ar(0!2);
    Out.ar(0, sig);
}).add;
)

Synth(\mic);

// With more arg for flexibility
(
SynthDef.new(\mic,{
    arg in=0, out=0, amp=1;
    var sig;
    sig = SoundIn.ar(in!2);
    Out.ar(out, sig);
}).add;
)


// Delay Line version
(
SynthDef.new(\mic,{
    arg in=0, out=0, delayTime=0.3, mix=(-0.5), amp=1;
    var sig, delay;
    sig = SoundIn.ar(in!2);
    delay = DelayL.ar(sig, 0.5, delayTime);
    sig = XFade2.ar(sig, delay, mix);
    Out.ar(out, sig);
}).add;
)

Synth(\mic);

// Comb delay CombL
(
SynthDef.new(\mic,{
    arg in=0, out=0, delayTime=0.3, decay=3, mix=(-0.5), amp=1;
    var sig, delay;
    sig = SoundIn.ar(in!2) * amp;
    delay = CombL.ar(sig, 0.5, delayTime, decay);
    sig = XFade2.ar(sig, delay, mix);
    Out.ar(out, sig);
}).add;
)

Synth(\mic, [\mix, 1.0]);

// ** DAY 19 ** //
// Variable delay time using oscillator
(
SynthDef.new(\mic,{
    arg in=0, out=0, delayTime=0.3, decay=3, mix=(-0.5), amp=1;
    var sig, delay;
    sig = SoundIn.ar(in!2) * amp;
    delay = CombL.ar(sig, 0.5, SinOsc.kr([0.3,0.32]).exprange(0.1,0.4), decay); // decay is how long it takes to reduce the signal by 60dB
    sig = XFade2.ar(sig, delay, mix);
    Out.ar(out, sig);
}).add;
)

Synth(\mic, [\mix, 1.0]);


{SinOsc.kr(0.3).exprange(0.1,0.4)}.plot(5);


// Split these apart to create signal flow/chain
(
SynthDef.new(\mic, {
    arg in=0, out=0, amp=1;
    var sig;
    sig = SoundIn.ar(in!2) * amp;
    Out.ar(out,sig);
}).add;
)

Synth(\mic);


(
SynthDef.new(\delay, {
    arg in=0, out=0, decay=3, mix=(-0.5), amp=1, delHz=0.25, delMin=0.1, delMax=0.4;
    var sig, delay;
    sig = In.ar(in, 2) * amp;
    delay = CombL.ar(
        sig, 0.5, SinOsc.kr([delHz, delHz * 0.9]).exprange(delMin, delMax), decay
    );
    sig = XFade2.ar(sig,delay,mix);
    Out.ar(out, sig);
}).add;
)

// Allocate a bus (two-channel private bus)
~delBus = Bus.audio(s, 2);

(
~micGrp = Group.new;
~delGrp = Group.after(~micGrp);

~micSynth = Synth(\mic, [\in, 0, \out, ~delBus], ~micGrp);
~delSynth = Synth(\delay, [\in, ~delBus, \out, 0], ~delGrp);
)