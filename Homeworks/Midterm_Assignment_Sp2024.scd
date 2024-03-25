/*******MIDTERM ASSIGNMENT********/

//BUILD A GENERATIVE PATTERN MACHINE

//PART 1. Design and test 2 SynthDefs using Blip.ar and VarSaw.ar

//Requirements:
//-Each SynthDef must have discernible pitch.
//-Each must be stereophonic. (Use a different method of multi-channel expansion for each.)
//-Each must have an envelope. (Use a different method for each.)
//-Each must have basic control of freq, amp, envelope parameters (atk, rel, or similar, etc.), and pan at a minimum.
//-Blip should have control of nharm, and VarSaw should have control of width. Create arguments for both in your SynthDef.
//-Both SynthDefs must utilize some sort of frequency detuning. (Hint: You might use some form of randomness, like LFNoise1 or detune a frequency in one of the two stereo channels of a 'freq' array. Use a different method for each.)

//Boot the server
s.boot;

/********LOAD SYNTHDEFS**********/
(
//Blip.ar SynthDef
(
SynthDef.new(\blip, {
	arg freq=440, dur=0.1, lev=1, amp=0.05, pan=0, out=0, nharm=200;
	var sig, env;
	env = EnvGen.kr(Env.triangle(dur,lev),doneAction:2);
	sig = Blip.ar([freq, freq], nharm);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)



//VarSaw.ar SynthDef
(
SynthDef.new(\varSaw, {
	arg freq=440, atk=0.1, rel=1, amp=0.05, pan=0, out=0, width=0.5;
	var sig, env;
	env = EnvGen.kr(Env.perc(atk,rel),doneAction:2);
	sig = VarSaw.ar([freq, freq * 0.2.midiratio], width:width);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)


)

//TEST
Synth(\blip);
Synth(\varSaw);





//PART 2. Create Pbinds to control each SynthDef
//-Each Pbind must address all of the controllable parameters from PART 1.
//-Do not hardwire any parameters. Each should have some form of contrained randomness. (Use the various data patterns you've learned to accomplish this: Pseq,Prand,Pxrand,Pwrand,Pexprand,and Pwhite.)
//-Use degree and scale for handling pitch in each of the Pbinds.
//-Wrap the degree parameter and a 'lev' parameter into a 'Pdefn' for each Pbind. (The user should be able to change degree patterns and the output level during performance.) [The ability to change scales is EXTRA CREDIT.] The output level will be controlled by a Slider for each instrument in the GUI, which controls the 'lev' parameter. Create 'lev' arguments in both of your SynthDefs.)
//-Create numerous pitch-degree pattern possibilities. (You must include at least FIVE. Each can be triggered by a button in the GUI.)
//-You can create chords using arrays of pitches within your larger degree array... [[0,2,4],4,5,6,7] would add tonic triad on the first degree of the scale being used.
//-Clearly comment all of your Pbinds and what you're attempting to do with each pattern parameter.
//-Remember to use the 'quant' message to ensure all of your Pbinds are synced.
//It should look like this: ~blip.play(quant:1)

//LOAD ALL OF THIS FIRST
(
/*****PBinds*****/
//Blip.ar Pbind
(
~blipStrtPbind = Pbind(
	\instrument, \blip,
	\freq, Pdefn(\freqBlip, 440),
	\dur, Pwrand([Pexprand(0.05,0.25),Pexprand(0.25,0.5)],[0.8,0.2],inf),
	\lev, Pdefn(\levBlip, Pxrand(0.25,0.5,0.75,1,1.25)),
	\amp, Pdefn(\ampBlip, Pwhite(0.1,0.5,inf)),
	\pan, Pdefn(\panAll, 0),
	\out, 0,
	\nharm, Pdefn(\nharmBlip, Pwrand([200, Pexprand(199,100)],[0.6,0.4], inf)),
	\scale, Pdefn(\scaleAll, Scale.minorPentatonic),
	\degree, Pdefn(\degBlip, Pxrand([[0,2,4],[1,3,4],[2,3,5],[1,2,4],[2,4,5]], inf)),
	\tempo, Pdefn(\tempoAll, 1);
);
)



//VarSaw.ar Pbind
(
~varsawStrtPbind = Pbind(
	\instrument, \varSaw,
	\freq, Pdefn(\freqVarSaw, 440),
	\lev, Pdefn(\levVarSaw, 1),
	\atk, Pdefn(\atkVarSaw, Pwhite(0.01,0.1,inf)),
	\rel, Pdefn(\relVarSaw, Pexprand(0.1,0.5,inf)),
	\amp, Pdefn(\ampVarSaw, Pwhite(0.1,0.5,inf)),
	\pan, Pdefn(\panAll, 0),
	\out, 0,
	\width, Pdefn(\widthVarSaw, Pwhite(0.01,1,inf)),
	\scale, Pdefn(\scaleAll, Scale.minorPentatonic),
	\degree, Pdefn(\degVarSaw, Pxrand([[0,2,4],[1,3,4],[2,3,5],[1,2,4],[2,4,5]], inf)),
	\tempo, Pdefn(\tempoAll, 1);
);
)


)




//PART 3. Create a GUI which can control the following:

//-Buttons to change the pitch (degree) pattern within each Pbind (at least five)
//-Be able to change the volume of each SynthDef (2 sliders, 'lev' argument in each SynthDef and their Pbinds)
//-Make your GUI clean, colorful, intuitive and inviting, and be sure to implement StaticText to label sections of your GUI with text.
//-Consider dividing sections of your GUI with panels (CompositeView.new)

/*****GUI CODE GOES HERE*****/
(
w.close;
w = Window.new("There Might Be Music", Rect.new(200,200,550,800));
w.front;

~txtBkg = Color.white;
~txtClr = Color.red;

~panelBlip = CompositeView.new(w, Rect.new(0,0,270,300))
.background_(Color.gray);

~panelVarSaw = CompositeView.new(w, Rect.new(280,0,270,300))
.background_(Color.gray);

~panelAll = CompositeView.new(w, Rect.new(0,310,550,490))
.background_(Color.gray);

// MAIN LABELS //

~textBlip = StaticText(~panelBlip, Rect.new(60,25,150,25))
.string_("Blip Instrument Controls")
.font_(Font("Monaco", 14))
.background_(~txtBkg)
.stringColor_(~txtClr);

~textVarSaw = StaticText.new(~panelVarSaw, Rect.new(57.5,25,155,25))
.string_("Saw Instrument Controls")
.font_(Font("Monaco", 14))
.background_(~txtBkg)
.stringColor_(~txtClr);

// VOLUME SLIDERS //

~volBlip = CompositeView.new(~panelBlip, Rect.new(15,50,50,200));

~volBlipSlider = Slider.new(~volBlip, Rect.new(15,10,20,160))
.action_({
	arg sld;
	Pdefn(\levBlip, sld.value)
})
.valueAction_(1);
~volBlipTxt = StaticText.new(~volBlip, Rect.new(0,175,50,25))
.string_("Volume")
.font_(Font("Monaco", 14))
.background_(~txtBkg)
.stringColor_(~txtClr);

~volVarSaw = CompositeView.new(~panelVarSaw, Rect.new(15,50,50,200));

~volVarSawSlider = Slider.new(~volVarSaw, Rect.new(15,10,20,160))
.action_({
	arg sld;
	Pdefn(\levVarSaw, sld.value)
})
.valueAction_(1);
~volVarSawTxt = StaticText.new(~volVarSaw, Rect.new(0,175,50,25))
.string_("Volume")
.font_(Font("Monaco", 14))
.background_(~txtBkg)
.stringColor_(~txtClr);

// FREQUENCY KNOBS //

~freqBlip = CompositeView(~panelBlip, Rect.new(135,60,70,70));

~freqBlipKnob = Knob.new(~freqBlip, Rect.new(10,0,50,50))
.action_({
	arg knb;
	Pdefn(\freqBlip, (440 + 440 * knb.value.midiratio));
});
~freqBlipTxt = StaticText.new(~freqBlip, Rect.new(0,50,70,20))
.string_("Frequency")
.font_(Font("Monaco", 14))
.background_(~txtBkg)
.stringColor_(~txtClr);

~freqVarSaw = CompositeView(~panelVarSaw, Rect.new(135,60,70,70));

~freqVarSawKnob = Knob.new(~freqVarSaw, Rect.new(10,0,50,50))
.action_({
	arg knb;
	Pdefn(\freqVarSaw, (440 + 440 * knb.value.midiratio));
});
~freqVarSawTxt = StaticText.new(~freqVarSaw, Rect.new(0,50,70,20))
.string_("Frequency")
.font_(Font("Monaco", 14))
.background_(~txtBkg)
.stringColor_(~txtClr);

// NHARM SLIDER //

~nharmBlip = CompositeView.new(~panelBlip, Rect.new(90,150,160,50));

~nharmSlider = Slider.new(~nharmBlip, Rect.new(0,0,160,20))
.action_({
	arg sld;
	Pdefn(\nharmBlip, 200 * sld.value);
})
.valueAction_(1);
~nharmBlipTxt = StaticText.new(~nharmBlip, Rect.new(12.5,25,135,25))
.string_("Number of Harmonics")
.font_(Font("Monaco", 14))
.background_(~txtBkg)
.stringColor_(~txtClr);

// WIDTH SLIDER //

~widthVarSaw = CompositeView.new(~panelVarSaw, Rect.new(90,150,160,50));

~widthSlider = Slider.new(~widthVarSaw, Rect.new(0,0,160,20))
.action_({
	arg sld;
	Pdefn(\widthVarSaw, 200 * sld.value);
})
.valueAction_(1);
~widthVarSawTxt = StaticText.new(~widthVarSaw, Rect.new(60,25,40,25))
.string_("Width")
.font_(Font("Monaco", 14))
.background_(~txtBkg)
.stringColor_(~txtClr);

// STOP BUTTONS //

~blipStream = ~blipStrtPbind;

~stopBlip = Button.new(~panelBlip, Rect.new(130,210,80,30))
.action_({
	arg btn;
	if (btn.value == 1) {
		~blipStream.play;
	} {
		~blipStream.stop;
	}
})
.states_([["OFF"], ["ON"]]);

~varsawStream = ~varsawStrtPbind;

~stopVarSaw = Button.new(~panelVarSaw, Rect.new(130,210,80,30))
.action_({
	arg btn;
	if (btn.value == 1) {
		~varsawStream.play;
	} {
		~varsawStream.stop;
	}
})
.states_([["OFF"], ["ON"]]);


// SCALE //

~scaleBtn = PopUpMenu.new(~panelAll, Rect.new(22.5,10,130,50))
.items_(["Aeolian", "Dorian", "Gong", "Ionian", "Major", "Minor", "Minor Pentatonic"])
.action_({
	arg i;
	~scales = [Scale.aeolian, Scale.dorian, Scale.gong, Scale.ionian, Scale.major, Scale.minor, Scale.minorPentatonic];
	Pdefn(\scaleAll, ~scales[i.value]);
})
.valueAction_(6);

// DEGREE BUTTONS //

~degrees = CompositeView(~panelAll, Rect.new(390,10,150,125));

~degreeBtn1 = Button.new(~degrees, Rect(0,0,50,50))
.action_({
	arg btn;
	Pdefn(\degBlip, Pxrand([[0,2,4],[1,3,4],[2,3,5],[1,2,4],[2,4,5]], inf));
	Pdefn(\degVarSaw, Pxrand([[0,2,4],[1,3,4],[2,3,5],[1,2,4],[2,4,5]], inf));
})
.states_([["1"]]);
~degreeBtn2 = Button.new(~degrees, Rect(50,0,50,50))
.action_({
	arg btn;
	Pdefn(\degBlip, Pxrand([[1,3,5],[2,4,5],[3,4,6],[2,3,5],[3,5,6]], inf));
	Pdefn(\degVarSaw, Pxrand([[1,3,5],[2,4,5],[3,4,6],[2,3,5],[3,5,6]], inf));
})
.states_([["2"]]);
~degreeBtn3 = Button.new(~degrees, Rect(100,0,50,50))
.action_({
	arg btn;
	Pdefn(\degBlip, Pxrand([[2,4,6],[3,5,6],[4,5,7],[3,4,6],[4,6,7]], inf));
	Pdefn(\degVarSaw, Pxrand([[2,4,6],[3,5,6],[4,5,7],[3,4,6],[4,6,7]], inf));
})
.states_([["3"]]);
~degreeBtn4 = Button.new(~degrees, Rect(0,50,50,50))
.action_({
	arg btn;
	Pdefn(\degBlip, Pxrand([[0,2,4],[3,5,6],[2,3,5],[3,4,6],[2,4,5]], inf));
	Pdefn(\degVarSaw, Pxrand([[0,2,4],[3,5,6],[2,3,5],[3,4,6],[2,4,5]], inf));
})
.states_([["4"]]);
~degreeBtn5 = Button.new(~degrees, Rect(50,50,50,50))
.action_({
	arg btn;
	Pdefn(\degBlip, Pxrand([[2,4,6],[1,3,4],[4,5,7],[1,2,4],[4,6,7]], inf));
	Pdefn(\degVarSaw, Pxrand([[2,4,6],[1,3,4],[4,5,7],[1,2,4],[4,6,7]], inf));
})
.states_([["5"]]);
~degreeBtn6 = Button.new(~degrees, Rect(100,50,50,50))
.action_({
	arg btn;
	Pdefn(\degBlip, Pxrand([[0,2,4],[1,3,5],[2,3,5],[3,4,6],[2,4,5]], inf));
	Pdefn(\degVarSaw, Pxrand([[0,2,4],[1,3,5],[2,3,5],[3,4,6],[2,4,5]], inf));
})
.states_([["6"]]);
~degreeTxt = StaticText(~degrees, Rect(25,100,100,25))
.string_("Degree Changer")
.font_(Font("Monaco", 14))
.background_(~txtBkg)
.stringColor_(~txtClr);

// TEMPO KNOB //

~tempo = CompositeView.new(~panelAll, Rect.new(62.5,60,50,75));

~tempoKnob = Knob.new(~tempo, Rect.new(0,0,50,50))
.action_({
	arg knb;
	Pdefn(\tempoAll, (knb.value + 0.25)/0.5);
})
.valueAction_(0.25);
~tempoTxt = StaticText.new(~tempo, Rect.new(0,50,50,25))
.string_("Tempo")
.font_(Font("Monaco", 14))
.background_(~txtBkg)
.stringColor_(~txtClr);

// PAN SLIDER //

~pan = CompositeView.new(~panelAll, Rect.new(175,85,200,50));

~panSlider = Slider.new(~pan, Rect.new(0,0,200,25))
.action_({
	arg sld;
	Pdefn(\panAll, sld.value);
})
.valueAction_(0.5);
~panTxtLeft = StaticText.new(~pan, Rect(0,25,25,25))
.string_("Left")
.font_(Font("Monaco", 14))
.background_(~txtBkg)
.stringColor_(~txtClr);
~panTxtRight = StaticText.new(~pan, Rect(165,25,35,25))
.string_("Right")
.font_(Font("Monaco", 14))
.background_(~txtBkg)
.stringColor_(~txtClr);
~panTxtPan = StaticText.new(~pan, Rect(88,25,24,25))
.string_("Pan")
.font_(Font("Monaco", 14))
.background_(~txtBkg)
.stringColor_(~txtClr);

// STOP ALL BUTTON //

~stopAllBtn = Button.new(~panelAll, Rect.new(250,10,50,50))
.action_({
	arg btn;
	if (btn.value == 1) {
		~varsawStream.play;
		~blipStream.play;
	} {
		~varsawStream.stop;
		~blipStream.stop;
	}
})
.states_([["ALL OFF"], ["ALL ON"]]);


)






//Extra Credit (5 pts. each):
////-Be able to start and stop both of the Pbinds with a single button in your GUI. (I would recommend using an 'if' statement in this case.)
//-Be able to change the global pitch scale with a multi-state button. (at least 2 scale choices [major/minor would work]). HINTS: Create global variables to handle changing scales (Scale.major, Scale.minor, etc.). Put the scale possibilities into an array. You'll need to wrap the \scale parameter in your Pbinds in a Pdefn to be able to change them at run-time.
//Give your GUI the ability to change tempo using a knob (hints: Knob value should control the \stretch parameter in your Pbinds. Research .linlin for scaling/remapping knob values to a useful scale for stretch values. Caution: a stretch value of 0.0 will overload the server and likely crash your computer. You *must* scale the value to avoid this.)






