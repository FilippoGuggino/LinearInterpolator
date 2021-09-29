library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity WaveGenerator_tb is
end WaveGenerator_tb;

architecture bhvWaveGenerator_tb of WaveGenerator_tb is
	constant T_CLK   : time := 10 ns; -- Clock period
	constant T_RESET : time := 25 ns;
	constant N : integer := 16;

	signal clk_tb  : std_logic := '0'; -- clock signal, intialized to '0' 
	signal rst_tb  : std_logic := '1';
	signal end_sim : std_logic := '1';
	signal wave_out : std_logic_vector(N-1 downto 0);

	component WaveGenerator is
	generic(N_bit_gen: integer);
	port (
		wave : out std_logic_vector(N_bit_gen-1 downto 0);
		clk_w : in std_logic;
		rst_w : in std_logic
		);
	end component;
begin
	clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2;  -- The clock toggles after T_CLK / 2 when end_sim is high. When end_sim is forced low, the clock stops toggling and the simulation ends.
	rst_tb <= '0' after T_RESET;

	myWvGen: WaveGenerator
	generic map(N_bit_gen => N)
	port map (
		clk_w => clk_tb,
		rst_w => rst_tb,
		wave => wave_out
	);

end bhvWaveGenerator_tb;