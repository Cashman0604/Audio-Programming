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




//VarSaw.ar SynthDef




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




//VarSaw.ar Pbind



)


//PART 3. Create a GUI which can control the following:

//-Buttons to change the pitch (degree) pattern within each Pbind (at least five)
//-Be able to change the volume of each SynthDef (2 sliders, 'lev' argument in each SynthDef and their Pbinds)
//-Make your GUI clean, colorful, intuitive and inviting, and be sure to implement StaticText to label sections of your GUI with text.
//-Consider dividing sections of your GUI with panels (CompositeView.new)

/*****GUI CODE GOES HERE*****/
(
//w.close;

)








//Extra Credit (5 pts. each):
////-Be able to start and stop both of the Pbinds with a single button in your GUI. (I would recommend using an 'if' statement in this case.)
//-Be able to change the global pitch scale with a multi-state button. (at least 2 scale choices [major/minor would work]). HINTS: Create global variables to handle changing scales (Scale.major, Scale.minor, etc.). Put the scale possibilities into an array. You'll need to wrap the \scale parameter in your Pbinds in a Pdefn to be able to change them at run-time.
//Give your GUI the ability to change tempo using a knob (hints: Knob value should control the \stretch parameter in your Pbinds. Research .linlin for scaling/remapping knob values to a useful scale for stretch values. Caution: a stretch value of 0.0 will overload the server and likely crash your computer. You *must* scale the value to avoid this.)






