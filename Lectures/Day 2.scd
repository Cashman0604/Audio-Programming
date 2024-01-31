ServerOptions.devices;

/* Review
1. Create function that adds 3 cubed to 4
2. Declare a local variable basicFunction
3. Retrieve and print result
*/
// OK Version
(var basicFunction, result;
	basicFunction = {3.cubed + 4};
	result = basicFunction.value;
)

// BETTER
(var basicFunction, result;
	basicFunction = {arg input; input.cubed + 4};
result = basicFunction.value(3);
)

// BEST
(var basicFunction, result;
	basicFunction = {arg input, offset; input.cubed + offset};
result = basicFunction.value(3,4);
)


// MAKE SOME NOISE

(
~noise = {
	PinkNoise.ar!2 * 0.1;
};
)

~noise.play;


(
~noise = {
	arg amp = 0.1;
	PinkNoise.ar!2 * amp;
};
)


(
~noise = {
	arg amp = 0.1;
	var sig; // signal
	sig = PinkNoise.ar!2;
	sig = sig * amp;
};
)

// Change runtime args
~noise.play(args: ['amp',0.3]);


// ENDING IT ALL
x = ~noise.play;
// kill specific noise instead of all with Ctrl + .
x.free;


// SERVER CMDS
// Ways to view sound in SC
s.meter; // show the meters

s.scope; // oscillascope

FreqScope.new; // Frequency viewer

s.makeGui; // GUI?!?
// ^ has record function


// More PinkNoise
(
~noise = {
	arg amp = 0.1;
	var sig;
	sig = {PinkNoise.ar}.dup;
	// dup makes a copy of PinkNoise in each channel
	// not same audio
	sig = sig * amp;
};
)

~noise.play(args: [\amp, 0.1]);

{PinkNoise.ar}.dup(3); // Play in x channels

// ! is easier


// MESSING WITH SINE TONES
// Ex 1 Random Sine tones
(
~rand_Texture = {
	var sig, freq;
	freq = {
		exprand(40, 10000); // exponential random
	}!32;
	sig = SinOsc.ar(freq) * 0.05;
	sig = Splay.ar(sig);
};
)

~rand_Texture.play;