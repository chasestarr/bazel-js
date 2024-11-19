// @ts-expect-error
global.globalJestEnvInit = function() {
	// @ts-expect-error
	global.foo = 'bar';
}
