
#include <stdio.h>
#include <stdbool.h>
#include "platform.h"
#include "xil_printf.h"

#include "xparameters.h"
#include "xil_exception.h"	//isr


u32 *baseaddr_p = (u32 *) XPAR_DWC_04_01_0_S00_AXI_BASEADDR;					//Base Address of the dwc_
volatile unsigned int *setReg = (unsigned int *)XPAR_DWC_04_01_0_S00_AXI_BASEADDR;	//set register

void debug_print(void);
void myIsr(void *CallbackRef);
void enable_ISR(void);

//u32 arraya[11]={4096,2048,0,1024,4096,2048,4096,1024};
u32 mathched_array[11];

//u32 arraya[5]={0,1,2,4,8,15};	//red
u32 arraya[8]={8,8,8,64,64,64,2048,2048,2048};	//blue

u32 counter=0;
u32 hold_flag=1;

bool flip;

int main()
{
    init_platform();
    enable_ISR();

    print("mb_0");

    while(1){
			hold_flag=1;

			//write_data_a(arraya[flip]);
			write_data_a(arraya[counter]);

			for(int x=0; x<9999999; x++){}


			while(hold_flag){
			} //hold for ip block

			counter++;
			if(counter==8){
				counter=0;
			}
    }

    for(int x=0; x<11; x++){
    	xil_printf("matched array: 0x%08x \n\r", mathched_array[x]);
    }
    cleanup_platform();
    return 0;
}

//-----debug print reg values-----------------------------------------------------------
void debug_print(void){
	xil_printf("start of debug print\n\n\r");
	xil_printf("MicoBlaze_0\n\r");
	xil_printf("Read from register 0 set_reg_a: 0x%08x \n\r", *(baseaddr_p + 0));
	xil_printf("Read from register 1 set_reg_b: 0x%08x \n\r", *(baseaddr_p + 1));
	xil_printf("Read from register 2 data_a: 0x%08x \n\r", *(baseaddr_p + 2));
	xil_printf("Read from register 3 data_b: 0x%08x \n\r", *(baseaddr_p + 3));
	xil_printf("Read from register 5 match: 0x%08x \n\r", *(baseaddr_p + 3));
	xil_printf("Read from register 5 done: 0x%08x \n\r", *(baseaddr_p + 5));
	xil_printf("Read from register 6 ready_0: 0x%08x \n\r", *(baseaddr_p + 6));
	xil_printf("Read from register 7 ready_0: 0x%08x \n\r", *(baseaddr_p + 7));
	xil_printf("Read from register 13 clear: 0x%08x \n\r", *(baseaddr_p + 13));
	xil_printf("Read from register 14 reset: 0x%08x \n\r", *(baseaddr_p + 14));
	xil_printf("End of debug print\n\n\r");
}
//-----end debug print reg values-------------------------------------------------------

void write_data_a(u32 A){
	*(baseaddr_p + 2) = A;	//write data
	*(baseaddr_p + 0) = 1;
	//setBit(setReg, 0);		//set LSB
}

//-----set register---------------------------------------------------------------------
 void setBit(unsigned int *setReg, int bitNumber){
	unsigned int value = *setReg;	//set_data register

	value |= (1 << bitNumber);	//set the desited bit

	*setReg = value;	//write the updated value
 }
 //-----end set register-----------------------------------------------------------------
 //-----enable interupt------------------------------------------------------------------
 void enable_ISR(void){
	// Connect ISR to the interrupt controller
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, myIsr, NULL);
	Xil_ExceptionEnable();

	// Enable MicroBlaze interrupts globally
	microblaze_enable_interrupts();
 }
 //-----end enable interupt--------------------------------------------------------------

 void myIsr(void *CallbackRef) {
     xil_printf("Interrupt_0 occurred!\n\r");
     *(baseaddr_p + 0) = 0;

     mathched_array[counter]=*(baseaddr_p + 5);

     hold_flag=0;
 }

 void clearBit(unsigned int *setReg, int bitNumber) {
     // Read the current value
     unsigned int value = *setReg;

     // Clear the desired bit
     value &= ~(1 << bitNumber);

     // Write the updated value back
     *setReg = value;
 }
