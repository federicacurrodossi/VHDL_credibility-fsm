# VHDL_Project

---

**Specification**  
The assigned project involves the development of a hardware module that reads a sequence of words from memory. The module receives a serial input of `i_k` words, each with a value between 0 and 255, where 0 represents an unspecified value, and a memory address `i_add` that points to the first word of the sequence. The word sequence is stored starting from `i_add` at every 2 bytes. The module must complete the sequence by replacing the 0s with the last non-zero value read and writing a credibility value in the byte following each word. The credibility value is initialized to 31 and must be decremented each time a 0 is read in the word sequence, without ever becoming negative.

**Component**  
The interface of the component to be implemented is as follows:

![image](https://github.com/user-attachments/assets/df310d10-3854-4aad-b5fc-55369a818364)


**Input Signals:**
- **i_clk**: Clock signal.
- **i_rst**: Asynchronous reset signal that reinitializes the module.
- **i_start**: Synchronous start operation signal.
- **i_add**: Synchronous signal that contains the address of the first word of the sequence.
- **i_k**: Synchronous signal that specifies the number of words in the sequence.
- **i_mem_data**: Signal that contains the value of the word read from memory.

**Output Signals:**
- **o_done**: Signal indicating the completion of the module's processing.
- **o_mem_en**: Signal to enable communication with memory, both for reading and writing.
- **o_mem_we**: Signal to enable writing to memory. It should be 0 in the case of reading.
- **o_mem_addr**: Signal containing the memory address from which to read or write a value.
- **o_mem_data**: Signal that contains the value to be written to memory.

---
![image](https://github.com/user-attachments/assets/49010b66-221d-47c1-a9ea-942376271dc1)


