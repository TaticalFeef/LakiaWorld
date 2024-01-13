#define INITIALIZE(D)																															\
	if(!D.Initialize()) {world << "opanenem"};		\
		D.initialized = TRUE;

#define FINALIZE(D)																																\
	if(!D.Finalize()) {world << "opanenem"};		\
		D.finalized = TRUE;