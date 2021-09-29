library IEEE;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;

entity LinearInterpolator_tb is
end LinearInterpolator_tb;

architecture bhvLinearInterpolator_tb of LinearInterpolator_tb is
	constant T_CLK   : time := 10 ns; -- Clock period
	constant T_RESET : time := 25 ns;
	constant N : integer := 16;
	constant K : integer := 4;

	signal clk_tb  : std_logic := '0'; -- clock signal, intialized to '0' 
	signal rst_tb  : std_logic := '1';
	signal end_sim : std_logic := '1';

	signal wave_out : std_logic_vector(N-1 downto 0);

	signal upsample_sig : std_logic_vector(N-1 downto 0);

	signal mul_curr_out_sig : std_logic_vector((N + 2) downto 0);
	signal mul_prev_out_sig : std_logic_vector((N + 2) downto 0);
	signal in_prev_out_sig : std_logic_vector((N - 1) downto 0);
	signal in_curr_out_sig : std_logic_vector((N - 1) downto 0);
	signal cnt_out_sig : std_logic_vector(1 downto 0);
	signal clock_slow_sig : std_logic;

	component WaveGenerator is
	generic(N_bit_gen : integer);
	port (
		wave : out std_logic_vector(N_bit_gen-1 downto 0);
		clk_w : in std_logic;
		rst_w : in std_logic
		);
	end component;

	component LinearInterpolator is
	generic (
		N_bit : integer;
		Interpolation_factor : integer
		);
	port(
		y_in : in std_logic_vector((N_bit - 1) downto 0);
		clk_int : in std_logic;
		y_out_int : out std_logic_vector((N_bit - 1) downto 0);
		rst_int : in std_logic;

		mul_curr_out : out std_logic_vector((N_bit + 2) downto 0);
		mul_prev_out : out std_logic_vector((N_bit + 2) downto 0);
		in_curr_out : out std_logic_vector(N_bit -1 downto 0); 
		in_prev_out : out std_logic_vector(N_bit -1 downto 0);
		cnt_out : out std_logic_vector(1 downto 0);
		clock_slow : out std_logic
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

	myInterpolator: LinearInterpolator
	generic map(
		N_bit => N,
		Interpolation_factor => K
		)
	port map(
		y_in => wave_out,
		clk_int => clk_tb,
		y_out_int => upsample_sig,
		rst_int => rst_tb,

		mul_curr_out => mul_curr_out_sig,
		mul_prev_out => mul_prev_out_sig,
		in_curr_out => in_curr_out_sig,
		in_prev_out => in_prev_out_sig,
		cnt_out => cnt_out_sig,
		clock_slow => clock_slow_sig
	);

end bhvLinearInterpolator_tb;