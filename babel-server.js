require('babel/register');

if (process.env.NODE_ENV !== 'production') {
	if (!require('piping')({hook: true, includeModules: true})) {
		return;
	}
}

require('./src/server/server');
