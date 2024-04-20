# fault_tolerance
# [$ whois](https://www.brennan.gg/)

# **[System_V5 demo](https://youtu.be/sJcxpZKU-E0)**  

Build instructions    
1) point to ip_repo
2) cd /path..../fault_tolerance-main/vivado
3) source design_1.tcl

**Soft_core CPU**: [MicroBlaze](https://www.xilinx.com/products/design-tools/microblaze.html)  
**FPGA Board**: [Nexys-A7-50T](https://www.xilinx.com/support/university/xup-boards/DigilentNexysA7.html)  
**Vivado Version**: 2022.2

---

**Background Provided:**   
The usage of terrestrial processors in harsh environments, such as space is not straightforward, as processors face unique challenges due to the effects of radiation-induced temporary faults, also called Single-Event-Upsets (SEUs). An SEU occurs when a charged particle hits the silicon transferring enough energy in order to provoke a bit flip in a memory cell or a transient logic pulse in the combinational logic. These radiation induced errors are the major concern in space applications, with potentially serious consequences for the Spacecraft, including loss of information, functional failure, or loss of control. This project investigates the use of modular redundancy techniques to mitigate the effects of SEUs thus creating fault-tolerant processing systems for mission critical applications. An MicoBlaze soft-core will be selected and instantiated multiple times in the design. Each MicoBlaze core will run identical mission critical computations. This allows the system to compare output results from identical data paths. Errors can be detected and discarded by comparing the output results from the duplicated cores. Fault-tolerance techniques such as Duplication with Compare (DWC) and Triple Modular Redundancy (TMR) will be candidates for implementation. Specification:

1. Identify a suitable RISV-V soft core Processor([MicroBlaze-V](https://www.xilinx.com/products/design-tools/microblaze-v.html#overview)). If None found to be suitable a [MicoBlaze](https://www.xilinx.com/products/design-tools/microblaze.html)/[PicoBlaze](https://www.xilinx.com/products/intellectual-property/picoblaze.html) can be used.
2. Duplicate With Compare (DWC) module to be designed tested and implemented([`link to IP`](https://github.com/Fuscior/fault_tolerance/tree/main/ip_repo/dwc_04_01_1_0)).
3. A custom testbench developed to evaluate performance and fault-tolerance.

# FPGA utilization, LUTS:  

|       device  |         2Core % |      3Core % |     DWC IP % |     TMR IP % | `DWC system %` | `TMR system %` |
| ------------- | :-------------: |------------- |------------- |------------- |------------- |------------- |
| `MMCM`  |                  20%  |         20%  |         NA%  |        TBD%  |        20%  |        TBD%  |
| `BUFG`  |                  13%  |         13%  |         NA%  |        TBD%  |        16%  |        TBD%  |
| `I/O`  |                    2%  |          2%  |         NA%  |        TBD%  |        15%  |        TBD%  |
| `BRAM`  |                  43%  |         64%  |         NA%  |        TBD%  |        24%  |        TBD%  |
| `FF`  |                     3%  |          5%  |         ~1%  |        TBD%  |         5%  |        TBD%  |
| `LUTRAM`  |                 3%  |          4%  |          ~%  |        TBD%  |         3%  |        TBD%  |
| `LUT`  |                    8%  |         11%  |         ~1%  |        TBD%  |         9%  |        TBD%  |

![image](https://github.com/Fuscior/fault_tolerance/blob/main/docs/code/images/demo_image_2.jpg)  

# System flowchart
![image](https://github.com/Fuscior/fault_tolerance/blob/main/docs/code/images/High_level_system_diagram.png)

# DWC flowchart  
![image](https://github.com/Fuscior/fault_tolerance/blob/main/docs/code/images/DWC_control_path.png)

# System Flowchart 
![image](https://github.com/Fuscior/fault_tolerance/blob/main/docs/code/images/High_level_System_flow.png)


