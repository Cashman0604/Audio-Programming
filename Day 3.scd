/*
Review
1. Create function using PinkNoise in stereo
2. Declare a user-defined gloabl var caalled noise.
3. Declare a local arg amp and a local var sig and use amp to scale the signal of the PinkNoise
4. Play the function using the .play method and define the amp as 0.05 at runtime (0.2 compile time)
*/

// Answer
~noise = {arg amp = 0.2; var sig = PinkNoise.ar * amp!2};
~noise.play(args:[\amp, 0.05]);

// Here, we use the global 'x' variable to have more control over the sound in real time

~noise = {arg amp = 0.2; var sig = PinkNoise.ar * amp!2};

x = ~noise.play(args:[\amp, 0.05]);

x.set(\amp, 0.02);

x.free;


// .ar method args

~noise = {arg amp = 0.2; var sig = PinkNoise.ar(mul:amp)!2};


// Other UGENs
SinOsc
Pulse
Saw
WhiteNoise
PinkNoise


// Using the SinOsc UGEN
(
    ~sound = {
        arg freq = 440, amp = 0.1;
        var sig = SinOsc.ar(freq, 0, amp)!2;
    }
)

x = ~sound.play(args:[\freq, 440, \amp, 0.1]);

x.set(\amp, 0.2);

x.free;


// All UGENs can be plotted
{SinOsc.ar(100)}.plot(1);

// ENVELOPES //

e = Env.new(levels:[0, 1, 0], times:[1, 1], curve:['lin']);

e = Env.new(levels:[0, 1, 0.2, 0.2, 0.5, 0], [0.1, 0.1, 3, 0.2, 1], 'lin').plot;

Window.closeAll; // Close all windows besides main one