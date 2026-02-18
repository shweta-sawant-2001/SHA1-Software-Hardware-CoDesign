#include <stdint.h>
#include <stdio.h>
#include "utils.h"

unsigned int get_length_in_bytes(const char *message) {
    unsigned int len=0;
    while(message[len] != '\0') len++;
    return len;
}

void print_block(unsigned char *message) {
    for(int i=0;i<64;i+=4){
        printf("%02x%02x%02x%02x\n", message[i], message[i+1], message[i+2], message[i+3]);
    }
}

uint32_t endianess_conversion(uint32_t data) {
    return ((data>>24)&0xff) | ((data<<8)&0xff0000) | ((data>>8)&0xff00) | ((data<<24)&0xff000000);
}
