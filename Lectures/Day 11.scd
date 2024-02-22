// Creates an event using the default SynthDef
().play;


x = Synth.new(\default);


x.set(\gate, 0);

// Basic Data patterns
p = Pseq([1,2,3,4], 5);

x = p.asStream; // creates a stream of data

x.next;

x.reset;

x.nextN(20);

p = Prand([20,30,40,50], inf);

x = p.asStream;

x.next;

x.nextN(30);

// Pbind
(
    p = Pbind(
        \freq, 1000,
        \dur, 1,
        \amp, 0.5,
        \sustain, 0.1
    ).play;
)


p.stop;
p.resume;



// Events more info
()

(freq:400, amp:0.2, sustain:1).class;

(freq:400, amp:0.2, sustain:1).play;



p = Pbind(\freq, 440, \sustain, 0.1).play;


// Patterns inside a Pbind
(
    p = Pbind(
        \freq, Pseq([400, 500, 600, 700, 800], inf),
        \sustain, 0.01,
        \dur, Prand([0.2,0.1], inf)
    );

    x = p.play;
)



(
    p = Pbind(
        \freq, Pseq((4..8) * 100, inf),
        \sustain, 0.01,
        \dur, Prand([0.2,0.1], inf)
    );

    x = p.play;
)


// \degree parameter && \scale
(
    p = Pbind(
        \scale, Scale.minor,
        \degree, Pseq([0,1,2,3,4,5,6,7], inf), //degrees inex at 0; 0 is tonic
        \sustain, 0.1,
        \dur, 0.2
    );

    x = p.play;
)

Scale.directory;



// \note param
(
    p = Pbind(
        \note, Pseq((0..11), inf),
        \sustain, 0.1,
        \dur, 0.2
    );

    x = p.play;
)


// \nidinote param
(
    p = Pbind(
        \midinote, Pseq([60, 64, 67, 72, 76].mirror, inf),
        \sustain, 0.1,
        \dur, 0.2
    );

    x = p.play;
)