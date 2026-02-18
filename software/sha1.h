#ifndef SHA1_H
#define SHA1_H
#include <stdint.h>
void sha_1(uint32_t *hash_ptr, const uint32_t *message, const uint32_t *prev_hash);
#endif
