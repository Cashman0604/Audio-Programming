(
SynthDef(\coolSaw, {
	arg atk=0.01, dec=0.1, susL=0.5, susT=0.5, rel=2, freq=440, width=0.5, amp=0.1, lev=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env.new([0,1,susL,susL,0],[atk,dec,susT,rel]),doneAction:2);
	sig = VarSaw.ar([freq,freq*1.01],width:width);
	sig = sig * amp * env * lev;
	sig = Out.ar(out,sig);
}).add;
)

Synth(\coolSaw);

(
//instantiate variable collections and patterns
~knobs = Array.fill(5,{nil});

~coolSaw = Pbind(
	\instrument, \coolSaw,
	\dur, Pwrand(
		[Pseq([0.25/3,0.25/3,0.25/3],1),
		 Pseq([0.25,Rest(0.25),0.125,0.125,0.25,Rest(0.5)],1),
		 Pseq([0.125,0.125,0.25],1),
		 0.25],
		 [0.03,0.10,0.10,0.77],inf),
	\scale, Scale.minor,
	\degree, Pseq([Pxrand([[0,2,4],1,2,3,4,6],30),Pseq([[3,5,7],4,5,6,7,9],4)],inf),
	\root, [-12,0],
	\octave, Pwrand([4,5,6,7],[0.1,0.8,0.08,0.02],inf),
	\width, Pexprand(0.5,0.95,inf),
	\amp, Pexprand(0.05,0.35,inf),
	\atk, Pdefn(\atkSaw, 0.001),
	\dec, Pdefn(\decSaw, 0.01),
	\susT, Pdefn(\susTSaw, 0.1),
	\susL, Pdefn(\susLSaw, 0.5),
	\rel, Pdefn(\relSaw, 0.1)

);
)

~coolSaw.play;

(
case {w.class == Window} {w.close};
w = Window.new("ADSR GUI", Rect(700,200,450,400));
w.front;
w.alwaysOnTop = true;
w.view.decorator = FlowLayout(w.view.bounds, 10@10, 10@10);

~startBtn = Button(w, 430@50)
.action_({
	arg btn;
	if (btn.value == 1) {
		~coolSawStream = ~coolSaw.play;
	} {
		~coolSawStream.stop;
	}
})
.states_([["OFF"],["ON"]]);

~adsrLabel = StaticText(w, 430@30)
.string_("ADSR")
.font_(Font("Monaco",size:16,bold:true))
.align_(\center);

~adsrPanel = CompositeView(w, 430@50)
.background_(Color.grey);
~adsrPanel.decorator = FlowLayout(~adsrPanel.bounds,20@10,10@10);

5.do{
	arg i;
	StaticText(~adsrPanel,30@30)
	.string_(
		case
		{i == 0} {"Atk"}
		{i == 1} {"Dec"}
		{i == 2} {"SusL"}
		{i == 3} {"SusT"}
		{i == 4} {"Rel"}
	)
	.font_(Font("Monaco",bold:true))
	.stringColor_(Color.white);

	~knobs[i] = Knob(~adsrPanel, 30@30)
	.action_({
		arg knb;
		case
		{i == 0} {Pdefn(\atkSaw, knb.value.linexp(0.0001,1.0,0.001,3.0))}
		{i == 1} {Pdefn(\decSaw, knb.value.linexp(0.0001,1.0,0.001,1.0))}
		{i == 2} {Pdefn(\susLSaw, knb.value)}
		{i == 3} {Pdefn(\susTSaw, knb.value.linexp(0.0001,1.0,0.001,6.0))}
		{i == 4} {Pdefn(\relSaw, knb.value.linexp(0.0001,1.0,0.001,6.0))}
	})
	.background_(Color.rand)
	.valueAction_(0.4)
	.mode_(\vert);
};

)



