MEMORY
{
    RAM   (rwx)  : ORIGIN = 0x20000000, LENGTH = 20K
    FLASH (rx)   : ORIGIN = 0x8000000 , LENGTH = 64K
}

_estack = ORIGIN(RAM) + LENGTH(RAM);


SECTIONS
{
    .isr_vector :
        {
	    . = ALIGN(4);
	    KEEP(*(.isr_vector))
	    . = ALIGN(4);
	} > FLASH
    .text :
	{
	    . = ALIGN(4);
	    *(.text)
	    *(.text*)
	    . = ALIGN(4);
	} > FLASH

    .rodata :
	{
	    . = ALIGN(4);
	    *(.rodata)
	    *(.rodata*)
	    . = ALIGN(4);
	} > FLASH

    _sidata = LOADADDR(.data);

    .data :
	{
	   . = ALIGN(4);
	   _sdata = .;
	   *(.data)
	   *(.data*)
	   . = ALIGN(4);
	   _edata = .;
	} > RAM AT > FLASH

     .bss :
	{
	   . = ALIGN(4);
	   _sbss = .;
	   __bss_start_ = .;
	   *(.bss)
	   *(.bss*)
	   . = ALIGN(4);
	   _ebss = .;
	   __end__ = .;
	   end = .;
	} > RAM


}
