
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity project_reti_logiche is
Port (
  i_clk: in std_logic;
		i_rst : in std_logic;
		i_start: in std_logic;
		i_add: in std_logic_vector(15 downto 0);
		i_k: in std_logic_vector(9 downto 0);
		o_done : out std_logic;
		o_mem_addr: out std_logic_vector(15 downto 0);
		i_mem_data: in std_logic_vector(7 downto 0);
		o_mem_data: out std_logic_vector(7 downto 0);
		o_mem_we: out std_logic;
		o_mem_en: out std_logic
);

end project_reti_logiche;

architecture project_reti_logiche_arch of project_reti_logiche is

signal inc_c: std_logic;
signal k_load: std_logic;
signal add_load: std_logic;
signal dec_c: std_logic;
signal val_l: std_logic;
signal sel: std_logic;
signal inc_add: std_logic;
signal check: std_logic;
signal reset: std_logic;
signal i_value: std_logic_vector (7 downto 0);
signal cred: std_logic_vector (7 downto 0);
signal i_stop: std_logic; 
signal enable_comp: std_logic;
signal i_count: std_logic_vector(9 downto 0);
signal rst_count: std_logic;

component reg_cred is port(
i_clk : in std_logic;
i_rst: in std_logic;
i_dec_c: in std_logic;
i_rst_cred: in std_logic;
o_cred:  out std_logic_vector(7 downto 0)
);
end component;

component fsm is port(
i_clk: in std_logic;
i_rst: in std_logic;
i_start: in std_logic;
i_stop: in std_logic;
check: in std_logic;
rst_credibility: out std_logic;
inc_c: out std_logic;
o_done: out std_logic;
k_load: out std_logic;
rst_count: out std_logic;
inc_add:out std_logic;
add_load:out std_logic;
o_mem_en:out std_logic;
o_mem_we:out std_logic;
dec_c:out std_logic;
val_l:out std_logic;
sel:out std_logic;
enable_comp: out std_logic

);
end component fsm;

component reg_add is port(
i_clk : in std_logic;
i_rst: in std_logic; 
i_inc_add: in std_logic;
add_load: in std_logic;
i_add: in std_logic_vector(15 downto 0);
o_mem_addr:  out std_logic_vector(15 downto 0)
);
end component;

component counter is
Port (
i_clk : in std_logic;
i_rst: in std_logic;
inc_c: in std_logic;
rst_count: in std_logic;
o_c: out std_logic_vector(9 downto 0)
 );
 end component;
 
component reg_k is port( 
i_clk : in std_logic;
i_rst: in std_logic;
i_enable_comp: in std_logic;
i_count: in std_logic_vector(9 downto 0);
k_load: in std_logic;
i_k: in std_logic_vector(9 downto 0);
o_stop: out std_logic 
);
end component;


component reg_value is port(
i_clk : in std_logic;
i_rst: in std_logic; 
i_mem_data: in std_logic_vector(7 downto 0);
val_load: in std_logic;
o_data:  out std_logic_vector(7 downto 0);
o_check: out std_logic
);
end component reg_value;

component reg_out is
port (
i_clk: in std_logic;
i_rst: in std_logic;
sel : in std_logic;
i_value : in std_logic_vector(7 downto 0);
i_cred: in std_logic_vector(7 downto 0);
Y : out std_logic_vector(7 downto 0)
);
end component reg_out;

begin
reg_c : reg_cred port map(
i_clk=>i_clk,
i_rst=>i_rst,
i_dec_c=>dec_c,
i_rst_cred=>reset,
o_cred=>cred
);

reg_val : reg_value port map(
i_clk =>i_clk,
i_rst=>i_rst,
i_mem_data=>i_mem_data,
val_load=>val_l,
o_data=> i_value,
o_check=>check
--i_send=>write_val
);

reg_add_1 : reg_add port map(
i_clk =>i_clk,
i_rst=>i_rst,
i_inc_add=>inc_add,
add_load=>add_load,
i_add=>i_add,
o_mem_addr=>o_mem_addr
);

reg_k_1 : reg_k port map( 
i_clk =>i_clk,
i_rst=>i_rst,
i_k=>i_k,
i_enable_comp=>enable_comp,
k_load=>k_load,
o_stop=>i_stop,
i_count=>i_count
);

reg_out_1: reg_out port map(
i_clk=>i_clk,
i_rst=>i_rst,
sel=>sel,
i_value=>i_value,
i_cred=>cred,
Y=>o_mem_data
);

counter1: counter port map(
i_clk =>i_clk,
i_rst=>i_rst,
inc_c=>inc_c,
o_c=>i_count,
rst_count=>rst_count
 
);

fsm_1 : fsm port map(
i_clk=>i_clk,
i_rst=>i_rst,
i_start=>i_start,
check=>check,
inc_c=>inc_c,
o_done=>o_done,
k_load=>k_load,
inc_add=>inc_add,
i_stop=>i_stop,
add_load=>add_load,
rst_count=>rst_count,
o_mem_en=>o_mem_en,
o_mem_we=>o_mem_we,
rst_credibility=>reset,
dec_c=>dec_c,
val_l=>val_l,
sel=>sel,
enable_comp=>enable_comp
);

end project_reti_logiche_arch;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg_cred is port(
i_clk : in std_logic;
i_rst: in std_logic;
i_dec_c: in std_logic;
o_cred:  out std_logic_vector(7 downto 0);
i_rst_cred: in std_logic
);
end reg_cred; 

architecture reg_cred_arch of reg_cred is 

signal c: std_logic_vector(7 downto 0);

begin 
     
process(i_clk, i_rst) 
begin 
if(i_rst='1') then 
    c <= "00011111";
elsif(i_clk'event and i_clk='1') then
        if(i_rst_cred='1') then
             c<= "00011111";
        elsif(i_dec_c='1') then 
            if(c>"00000000") then 
               c<=c-1;
            else 
                c<="00000000";
            end if;
        end if;
end if;
end process;
o_cred<=c;
end reg_cred_arch;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg_add is port(
i_clk : in std_logic;
i_rst: in std_logic;
i_inc_add: in std_logic;
add_load: in std_logic;
i_add: in std_logic_vector(15 downto 0);
o_mem_addr:  out std_logic_vector(15 downto 0)
);
end reg_add;

architecture reg_add_arch of reg_add is 
signal add: std_logic_vector(15 downto 0);

begin

process(i_clk, i_rst)
begin
if(i_rst ='1') then 
    add<="0000000000000000";
    elsif(i_clk' event and i_clk='1') then
        if(add_load='1') then
            add<=i_add;
         elsif(i_inc_add='1') then 
            add <= add + 1;
          end if;
     end if;
     end process;
     o_mem_addr<=add;
end reg_add_arch;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reg_k is port( 
i_clk : in std_logic;
i_rst: in std_logic;
i_enable_comp: in std_logic;
i_count: in std_logic_vector(9 downto 0);
k_load: in std_logic;
i_k: in std_logic_vector(9 downto 0);
o_stop: out std_logic 
);
end reg_k;

architecture reg_k_arch of reg_k is 
signal k: std_logic_vector(9 downto 0);

begin 
process(i_clk, i_rst) 
begin 
if(i_rst='1') then 
	o_stop<='0';
elsif(i_clk'event and i_clk='1') then 
       if(k_load='1') then 
        k<=i_k;
       elsif i_enable_comp='1' then 
            if(k=i_count) then 
                 o_stop<='1';
            else
                 o_stop<='0';
            end if;
       end if;
end if;
 
end process;

end reg_k_arch;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_out is
port (
        i_rst: in std_logic;
        i_clk: in std_logic;
       sel : in std_logic;
      i_value : in std_logic_vector(7 downto 0);
i_cred: in std_logic_vector(7 downto 0);
      Y : out std_logic_vector(7 downto 0)
);
end reg_out;

architecture reg_out_arch of reg_out is
signal value : std_logic_vector(7 downto 0);

begin   
process(i_rst, i_clk)
begin
 if(i_rst='1')then
    value<="00000000";
 elsif(i_clk'event and i_clk='1') then 
    if(sel='0')then 
        value<=i_value;
    else
    value<=i_cred;
    end if;   
    end if;
    end process;
    Y<=value;
end reg_out_arch;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter is
Port (
i_clk : in std_logic;
i_rst: in std_logic;
inc_c: in std_logic;
rst_count: in std_logic;
o_c: out std_logic_vector(9 downto 0)
 );
end counter;

architecture counter_arch of counter is
signal count: std_logic_vector(9 downto 0);
begin

process(i_clk, i_rst) 
begin 
if(i_rst ='1') then 
    count<="0000000000";
elsif(i_clk' event and i_clk='1') then
        if(rst_count='1') then 
        count<="0000000000";
        elsif(inc_c='1') then 
        count<=count+"0000000001";
        end if;
end if;
end process;
o_c<=count;
end counter_arch;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is port(
i_clk: in std_logic;
i_rst: in std_logic;
i_start: in std_logic;
i_stop: in std_logic;
check: in std_logic;
rst_credibility: out std_logic;
inc_c: out std_logic;
o_done: out std_logic;
rst_count: out std_logic;
k_load: out std_logic;
inc_add:out std_logic;
add_load:out std_logic;
o_mem_en:out std_logic;
o_mem_we:out std_logic;
dec_c:out std_logic;
val_l:out std_logic;
sel:out std_logic;
enable_comp: out std_logic
);
end  fsm;

architecture fsm_arch of fsm is
type S is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15);
signal curr_state:S;
begin
process(i_clk,i_rst)
begin 
	if(i_rst='1') then 
	curr_state<=S0;
	elsif i_clk'event and i_clk='1' then
	case curr_state is
	   when S0=>
	   if(i_start='0') then curr_state<=S0;
	   else curr_state<=S1;
	   end if;
	   when S1=> curr_state<=S2;
	when S2=> curr_state<=S3;
when S3=> 
	if(i_stop='1') then curr_state<=S14;
	else curr_state<=S4;
	end if;
when S4=> curr_state<=S5;
when S5=> 
	if(check='0') then curr_state<=S15;
	else curr_state<=S6;
	end if;
when S15=> curr_state<=S2;
when S6=> curr_state<=S7;
when S7=> 
	if(i_stop='1') then curr_state<=S14;
	else curr_state<=S8;
	end if;
when S8=> curr_state<=S9;
when S9=> 
	if(check='0') then curr_state<=S11;
	else curr_state<=S10;
	end if;
when S10=>curr_state<=S5;
when S11=> curr_state<=S12;
when S12=> curr_state<=S13;
when S13=> curr_state<=S6;
when S14=> 
	if(i_start='1') then curr_state<=S14;
	else 
	curr_state<=S0;
	end if;
end case;
end if;
end process;

process(curr_state) 
begin 

--counter signals
inc_c<='0';
rst_count<='0';

--address signals
inc_add<='0';
add_load<='0';

--k register/comparator signals 
k_load<='0';
enable_comp<='0';

--memory signals
o_mem_en<='0';
o_mem_we<='0';

-- credibility signals
dec_c<='0';
rst_credibility<='0';

--input value signals 
val_l<='0';

-- mux signals 
sel<='1'; --sel su zero scrive valo di default

-- output signals (architecture of the project)
o_done<='0';

case curr_state is
when S0=>
when S1=>
add_load<='1';
k_load<='1';
when S2=>
enable_comp<='1';
when S3=>
o_mem_en<='1';
inc_c<='1';
when S4=>
val_l<='1';
when S5=>
inc_add<='1';
when S15=>
inc_add<='1';
when S6=>
o_mem_en<='1';
o_mem_we<='1';
inc_add<='1';
enable_comp<='1';
when S7=>
o_mem_en<='1';
inc_c<='1';
when S8=>
val_l<='1';
when S9=>
when S10=>
rst_credibility<='1';
when S11=>
sel<='0';
when S12=>
o_mem_en<='1';
o_mem_we<='1';
dec_c<='1';
when S13=>
inc_add<='1';
when S14=>
o_done<='1';
rst_credibility<='1';
rst_count<='1';
end case;
end process;

end fsm_arch;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity reg_value is port(
i_clk : in std_logic;
i_rst: in std_logic; 
i_mem_data: in std_logic_vector(7 downto 0);
val_load: in std_logic;
o_data:  out std_logic_vector(7 downto 0);
o_check: out std_logic
);
end  reg_value;

architecture reg_value_arch of reg_value is
signal value: std_logic_vector(7 downto 0);
begin

process(i_rst,i_clk)
begin
if(i_rst='1') then
value<="00000000";
o_check<='1';
elsif(i_clk'event and i_clk='1') then 
if(val_load='1') then 
    if(i_mem_data/="00000000")then 
    value<=i_mem_data;
    o_check<='1';
    else
    o_check<='0';
    end if;
    end if;
    end if;
    end process;
    o_data<=value;
    end reg_value_arch;

