library IEEE;
use IEEE.std_logic_1164.all;

entity DFlipFlop is
port(
	d : in std_logic;
	clk : in std_logic;
	rst : in std_logic;
	q : out std_logic
	);
end DFlipFlop;

architecture bhvDFF of DFlipFlop is
begin
	re_procc : process(clk, rst)
	begin
		if(rst = '1') then
			q <= '0';
		elsif(rising_edge(clk)) then
			q <= d;
		end if;
	end process;
end bhvDFF;