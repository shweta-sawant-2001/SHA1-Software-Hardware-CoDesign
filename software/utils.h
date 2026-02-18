#ifndef UTILS_H
#define UTILS_H
#include <stdint.h>
unsigned int get_length_in_bytes(const char *message);
void print_block(unsigned char *message);
uint32_t endianess_conversion(uint32_t data);
#endif
