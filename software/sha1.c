#include <stdint.h>
#include "sha1.h"
#include "utils.h"

// Rotate left macro
#define ROTL(a,b) (((a) << (b)) | ((a) >> (32-(b))))

void sha_1(uint32_t *hash_ptr, const uint32_t *message, const uint32_t *prev_hash) {
    uint32_t H[5];
    if(prev_hash) {
        for(int i=0;i<5;i++) H[i] = prev_hash[i];
    } else {
        // SHA-1 initial hash constants
        H[0]=0x67452301; H[1]=0xEFCDAB89;
        H[2]=0x98BADCFE; H[3]=0x10325476;
        H[4]=0xC3D2E1F0;
    }

    uint32_t W[80];
    for(int t=0;t<16;t++) W[t] = message[t];
    for(int t=16;t<80;t++) W[t] = ROTL(W[t-3] ^ W[t-8] ^ W[t-14] ^ W[t-16], 1);

    uint32_t a=H[0], b=H[1], c=H[2], d=H[3], e=H[4];

    for(int t=0;t<80;t++){
        uint32_t f, k;
        if(t<20){ f=(b & c) | ((~b) & d); k=0x5A827999; }
        else if(t<40){ f=b ^ c ^ d; k=0x6ED9EBA1; }
        else if(t<60){ f=(b & c) | (b & d) | (c & d); k=0x8F1BBCDC; }
        else{ f=b ^ c ^ d; k=0xCA62C1D6; }

        uint32_t temp = ROTL(a,5) + f + e + k + W[t];
        e = d; d = c; c = ROTL(b,30); b = a; a = temp;
    }

    H[0] += a; H[1] += b; H[2] += c; H[3] += d; H[4] += e;
    for(int i=0;i<5;i++) hash_ptr[i] = H[i];
}
