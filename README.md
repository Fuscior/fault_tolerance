# fault_tolerance
Work in prog

Build instructions
tbd

Soft_core CPU: MicroBlaze
FPGA Board: Nexys-A7-50T
Vivado Version: 2022.2

Background Provided:
The usage of terrestrial processors in harsh environments, such as space is not straightforward, as processors face unique challenges due to the effects of radiation-induced temporary faults, also called Single-Event-Upsets (SEUs). An SEU occurs when a charged particle hits the silicon transferring enough energy in order to provoke a bit flip in a memory cell or a transient logic pulse in the combinational logic. These radiation induced errors are the major concern in space applications, with potentially serious consequences for the Spacecraft, including loss of information, functional failure, or loss of control. This project investigates the use of modular redundancy techniques to mitigate the effects of SEUs thus creating fault-tolerant processing systems for mission critical applications. An open source RISC-V soft-core will be selected and instantiated multiple times in the design. Each RISC-V core will run identical mission critical computations. This allows the system to compare output results from identical data paths. Errors can be detected and discarded by comparing the output results from the duplicated cores. Fault-tolerance techniques such as Duplication with Compare (DWC) and Triple Modular Redundancy (TMR) will be candidates for implementation. Specification:

    Identify a suitable RISV-V soft core Processor(MicroBlaze-V). If None found to be suitable a MicoBlaze/PicoBlaze can be used.
    Duplicate With Compare (DWC) module to be designed tested and implemented(link to IP).
    Triple Modular Redundancy (TMR) module to be designed tested and implemented(link to IP).
    Fault injection to be designed tested and implemented in simulation and hardware(link to IP).
    A custom testbench developed to evaluate performance and fault-tolerance.

FPGA utilization, LUTS:
device 	2Core % 	3Core % 	DWC IP % 	TMR IP % 	DWC system % 	TMR system %
MMCM 	20% 	20% 	TBD% 	TBD% 	TBD% 	TBD%
BUFG 	13% 	13% 	TBD% 	TBD% 	TBD% 	TBD%
I/O 	2% 	2% 	TBD% 	TBD% 	TBD% 	TBD%
BRAM 	43% 	64% 	TBD% 	TBD% 	TBD% 	TBD%
FF 	3% 	5% 	TBD% 	TBD% 	TBD% 	TBD%
LUTRAM 	3% 	4% 	TBD% 	TBD% 	TBD% 	TBD%
LUT 	8% 	11% 	TBD% 	TBD% 	TBD% 	TBD%
System flowchart

placeholder
DWC flowchart
placeholder
