#ifndef EQEMU_NMS_DAILIFYER_H
#define EQEMU_NMS_DAILIFYER_H

#include "../common/types.h"

#include <string>

// NMS: one row of the Dailifyer challenge window. The quest side (NMS_dailifyer_utils.pl) decides
// every field; the server only packs them for the client.
struct DailifyerChallenge {
	uint32      id              = 0;
	uint8       status          = 0; // DailifyerStatus (eq_packet_structs.h)
	bool        completed       = false;
	uint32      lockout_seconds = 0;
	std::string name;
	std::string objective;
};

#endif
