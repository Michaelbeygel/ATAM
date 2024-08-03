#include <asm/desc.h>

void my_store_idt(struct desc_ptr *idtr) {
    asm volatile("sidt %0" : "=m" (*idtr)::);
}

void my_load_idt(struct desc_ptr *idtr) {
    asm volatile("lidt %0" : : "m" (*idtr):);
}

void my_set_gate_offset(gate_desc *gate, unsigned long addr) {
    gate->offset_low = addr & 0xFFFF;
    gate->offset_middle = (addr >> 16) & 0xFFFF;
    gate->offset_high = (addr >> 32) & 0xFFFFFFFF;
}

unsigned long my_get_gate_offset(gate_desc *gate) {
    unsigned long dest = gate->offset_high;
    dest <<= 16;
    dest += gate->offset_middle;
    dest <<= 16;
    return dest + gate->offset_low;
}