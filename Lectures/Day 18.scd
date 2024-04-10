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
    "Put Input Device Name Here"
);


s.options.outDevice_(
    "Put Output Device Name Here"
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