library IEEE;
use IEEE.std_logic_1164.all;

entity counter_tb is
end counter_tb;

architecture bhv of counter_tb is
	constant T_CLK   : time := 10 ns; -- Clock period
	constant T_RESET : time := 25 ns;
	constant N : integer := 3;

	signal clk_tb  : std_logic := '0'; -- clock signal, intialized to '0' 
	signal rst_tb  : std_logic := '1';
	signal q_tb : std_logic_vector((N- 1) downto 0);
	signal cout_tb : std_logic;
	signal end_sim : std_logic := '1';

	component counter is
	generic(N_bit_counter : integer);
		port (
			inc : in std_logic_vector((N_bit_counter - 1) downto 0);
			clk : in std_logic;
			rst: in std_logic;
			q_cnt : out std_logic_vector((N_bit_counter - 1) downto 0);
			cout_cnt : out std_logic
			);
	end component;


begin
	clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2;  -- The clock toggles after T_CLK / 2 when end_sim is high. When end_sim is forced low, the clock stops toggling and the simulation ends.
	rst_tb <= '0' after T_RESET;

	mycnt: counter 
	generic map(N_bit_counter => N)
	port map (
		inc => "001",
		clk => clk_tb,
		rst => rst_tb,
		q_cnt => q_tb,
		cout_cnt => cout_tb
	);

end bhv;