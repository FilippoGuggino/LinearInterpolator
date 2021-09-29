library IEEE;
use IEEE.std_logic_1164.all;

entity myregister is
generic (N_bit_reg : integer);
port(
	d : in std_logic_vector((N_bit_reg - 1) downto 0);
	clk : in std_logic;
	rst : in std_logic;
	q : out std_logic_vector((N_bit_reg - 1) downto 0)
	);
end myregister;

architecture bhvRE of myregister is
begin
	re_procc : process(clk, rst)
	begin
		if(rst = '1') then
			q <= (others => '0');
		elsif(rising_edge(clk)) then
			q <= d;
		end if;
	end process;
end bhvRE;