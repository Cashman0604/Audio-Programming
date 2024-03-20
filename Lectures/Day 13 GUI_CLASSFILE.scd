// GUI

// Make a basic window
(
w = Window.new;
w.front;
)


Window.closeAll;

(
w.close;
w = Window.new("Music Machine", Rect.new(200, 200, 400, 600));
// first two args are distance front bottom left
w.front;
)

(
w.close;
w = Window.new("Music Machine", Rect.new(rrand(200,800), 200, 400, 600));
w.front;
w.view.background = Color.rand;
)

(
w.close;
w = Window.new("Music Machine", Rect.new(rrand(200,800), 200, 400, 600));
w.front;
// Other implementation - trailing method
w.view.background_(Color.rand)
.param_()
.param2_();
)


(
w.close;
w = Window.new("Music Machine", Rect.new(rrand(200,800), 200, 400, 600));
w.front;
w.view.background_(Color.new(0.75,0.75,0.75));
)


// add a slider
(
w.close;
w = Window.new("Music Machine", Rect.new(rrand(200,800), 200, 400, 600));
w.front;
w.view.background_(Color.new(0.75,0.75,0.75));

~sl = Slider.new(w, Rect.new(50,50,50,150))
.action_({
	arg sl;
	sl.value.postln;
}).value_(0.3547679879876879684776878) //.value essentially only sets graphical value of slider
.valueAction_(0.3547679879876879684776878) //actually sends value to action
.background_(Color.rand);
)


// add button
(
w.close;
w = Window.new("Music Machine", Rect.new(rrand(200,800), 200, 400, 600));
w.front;
w.view.background_(Color.new(0.75,0.75,0.75));

~sl = Slider.new(w, Rect.new(50,50,50,150))
.action_({
	arg sl;
	sl.value.postln;
}).value_(0.5)
.background_(Color.rand);

~btn = Button.new(w, Rect(150,50,75,25))
.action_({
	arg btn;
	btn.value.postln();
})
)



// Multi-State Button
(
w.close;
w = Window.new("Music Machine", Rect.new(rrand(200,800), 200, 400, 600));
w.front;
w.view.background_(Color.new(0.75,0.75,0.75));

~sl = Slider.new(w, Rect.new(50,50,50,150))
.action_({
	arg sl;
	sl.value.postln;
}).value_(0.5)
.background_(Color.rand);

~btn = Button.new(w, Rect(150,50,75,25))
.action_({
	arg btn;
	btn.value.postln();
})
.states_([
	["OFF", Color.black, Color.red],
	["ON", Color.green, Color.black],
	["EH"]
])
.value_(0);
)




//Our SynthDef. We'll need this later...
(
SynthDef(\sine, {
	arg freq=440, amp=0.1, pan=0, atk=0.01, sus=0.5, rel=2, gate=1, out=0;
	var sig, env, freqOffset;
	freqOffset = LFNoise1.kr(1).range(1.001,1.05);
	env = EnvGen.kr(Env.asr(atk,sus,rel), gate);
	sig = SinOsc.ar([freq, (freq * freqOffset)]);
	sig = Pan2.ar(sig, pan);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth(\sine, [\amp, 0.05]);
x.release;

// Two-State Button for on/off to ctrl synth gate
(
// ~tone.free

~tone = Synth(\sine, [\gate,0]);

w.close;
w = Window.new("Music Machine", Rect.new(rrand(200,800), 200, 400, 600));
w.front;
w.view.background_(Color.new(0.75,0.75,0.75));

~sl = Slider.new(w, Rect.new(50,50,50,150))
.action_({
	arg sl;
	sl.value.postln;
}).value_(0.5)
.background_(Color.rand);

~btn = Button.new(w, Rect(150,50,75,25))
.action_({
	arg btn;
	~tone.set(\gate, btn.value);
})
.states_([
	["OFF", Color.black, Color.red],
	["ON", Color.green, Color.black]
]);
)


