(
SynthDef(\sound, {
	arg amp=0.2, gate=1, freq=440, lowR1=(-0.5), lowR2=(-0.01), highR1=0.5, highR2=0.01;
	var sig, lowRange, highRange, freqCtrl, cutOff, env;
	env = EnvGen.kr(Env.adsr(5,0.3,1,5), gate, doneAction: 2);
	lowRange = LFNoise2.kr(0.2).range(lowR1, lowR2);
	highRange = LFNoise2.kr(0.2).range(highR1, highR2);
	freqCtrl = freq * LFNoise2.kr(LFNoise2.kr(0.5).range(0.1,2)).range(lowRange,highRange).midiratio;
	sig = Saw.ar(freqCtrl);
	cutOff = LFNoise2.kr(0.3).range(4000,18000);
	sig = LPF.ar(sig, cutOff);
	sig = sig * amp * env;
	sig = Splay.ar(sig);
	Out.ar(0,sig)
}).add;
)

Synth(\sound);

(
x = 20.collect{
	Synth(\sound, [\freq, [55,110,220,440,660,880,990].choose]);
}
)

(
x.do{
	arg synth;
	synth.set(\gate, 0)
}
)

(
~chord1 = [21,33,45,57,64,69,71]; //Asus9
~chord2 = [14,26,38,50,57,64]; //Dsus
~sus = 55;
~res = 54;

Routine{
	x = 20.collect{
		Synth(\sound, [\freq, ~chord1.midicps.choose]);
	};
	6.wait;
	x.do{
		arg synth;
		synth.set(\gate, 0)
	};

	x = 20.collect{
			Synth(\sound, [\freq, (~chord1-4).midicps.choose]);
	};
	6.wait;
	x.do{
		arg synth;
		synth.set(\gate, 0)
	};

	x = 20.collect{
		Synth(\sound, [\freq, (~chord2).midicps.choose]);
	};

	y = 4.collect{
		Synth(\sound, [\freq, ~sus.midicps]);
	};
	6.wait;
	y.do{
		arg synth;
		synth.set(\freq, ~res.midicps);
	};
	5.wait;

	x.do{
		arg synth;
		synth.set(\gate, 0)
	};
	y.do{
		arg synth;
		synth.set(\gate, 0)
	};

}.play;
)