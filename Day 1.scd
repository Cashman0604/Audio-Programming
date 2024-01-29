/* // Two side to SC //
sclang // language/logic side
aka interpreter

scsynth // server side
makes sound

// Server Cmds //
Server.local.boot;
s.boot;
Server.local.quit;
s.quit;

*/

s.boot;
s.quit;

// SHORTCUTS //
/*
Boot Ctrl - B
Cleal Terminal Ctrl - Shift - P
Stop Sound Global Ctrl - .
*/

// Functions //

{ } // def inside braces
{}.play; // play on server
{PinkNoise.ar*0.1}.play; // ar means Audio Rate
// * White Noise - Equal energy by frequency
// * Pink Noise - Equal Energy per octave


// SinOsc //

{SinOsc.ar(freq: 220, mul: 0.5)*0.1}.play()

// * 0 is Left channel, 1 is right channel


// Simple Literal CMDS //

5.squared;

x = {5.squared);
x.value;

~myFunc ={5.squared};

(
var myFunc, result;
myFunc = {5.squared};
result = myFunc.value;
)


// Multi Channel
{SinOsc.ar([220,4400])*0.05}.play;

{SinOsc.ar(440) * 0.1!2}.play;



// FM Synthesis
{SinOsc.ar(440 + SinOsc.ar(220, mul: 100)) * 0.1!2}.play;

{SinOsc.ar(420 + SinOsc.ar(MouseY.kr(42, 10000), mul: MouseX.kr(0, 10000))) * 0.1!2}.play();