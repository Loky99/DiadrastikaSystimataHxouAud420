(
Ndef(\ro_v19, {
	var freq = 50.rrand(100).debug('base freq');
	var seed = thisThread.randSeed = 2000000000.rand.debug('seed');
	var gen = [LFNoise2,LFNoise0,SinOsc,LFPulse,LFSaw];
	var sig = Splay.ar({
		var i = 5.exprand(50).asInteger;
		Median.ar(
			4.exprand(20),
			EnvGen.ar(
				Env(
					[0] ++ Array.fill(i-1, {
						gen.choose.kr(
							0.3.coin.if({ gen.choose.kr(0.02.exprand(0.2)).exprange(0.2,2) }, { 0.2.exprand(2) }),
							mul: 0.3.coin.if({ gen.choose.kr(0.06.exprand(10)).range(0.2,2) }, { 0.2.rrand(2) })
						)
					}) ++ [0],
					Array.rand(i-2, 0.2,2.0).normalizeSum,
					[[-6.0.rrand(6),\sin].choose] ++ Array.fill(i-2, {
						[\sin ! 1.rrand(7), -6.0.rrand(6) ! 1.rrand(5)].flat.choose
					}) ++ [[-6.0.rrand(6),\sin].choose]
				).circle,
				timeScale: Duty.kr( // freq
					Drand([2,4,8,16], inf), 0,
					Dwrand([1,2,4,8,16,32,64]*freq, ((14..7) ** 1.rrand(3)).normalizeSum, inf)
					* 0.8.coin.if({ Duty.kr(
						[Dxrand, Drand].choose.new([0.125,0.25,0.5,1,2,4,6,8,12], inf), 0,
						Dshuf({ (0..20).choose.midiratio } ! 2.exprand(8), inf)
					) }, { (0..20).choose.midiratio })
				).reciprocal
			)
		) * EnvGen.kr(
			Env.perc(
				0.02.exprand(0.5) * 0.3.coin.if({ Duty.kr(
					Drand([0.5,1,2,4,8,12,16], inf), 0,
					Dshuf({ [1,2,3,4].choose } ! 1.exprand(9), inf)
				) }, { 1 }),
				0.1.exprand(5) * 0.8.coin.if({ Duty.kr(
					Drand([0.5,1,2,4,8,12,16], inf), 0,
					Dshuf({ [1,2,4,8,16].choose.reciprocal } ! 1.exprand(9), inf)
				) }, { 2 }),
				LFNoise2.kr(0.2.exprand(10)).range(0.05,2),
				LFNoise2.kr(0.2.exprand(10)).range(-4,4),
			).circle
		);
	} ! 3.rrand(9).debug('source'));
	BHiShelf.ar(
		GVerb.ar(
			Rotate2.ar(sig[0], sig[1], Duty.kr(Drand([2,4,8],inf), 0, Drand([-2,2,0],inf)) * LFSaw.kr(0.2.exprand(2))),
			40.rrand(150).debug('room')
		),
		LFNoise2.kr(0.2.exprand(0.5)).range(4000,8000),
		LFNoise2.kr(0.2.exprand(2)).range(1,5),
		LFNoise2.kr(0.2.exprand(2)).range(-30,-15)
	);
}).play
)