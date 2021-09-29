library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity WaveGenerator is
generic(
	N_bit_gen : integer
	);
port(
	wave : out std_logic_vector(N_bit_gen - 1 downto 0);
	clk_w : in std_logic;
	rst_w : in std_logic
	);
end WaveGenerator;

architecture bhvWaveGenerator of WaveGenerator is
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

	signal sig : std_logic_vector(1 downto 0);
	signal ind : std_logic_vector(2 downto 0);

	signal clk_slow : std_logic;

	type lut_t is array(natural range<>) of std_logic_vector(N_bit_gen-1 downto 0);
	constant oscillator_lut : lut_t(0 to 1) := (
 		(others => '0'),
 		((N_bit_gen - 1) => '1', others => '0')
		);

	constant custom_wave : lut_t(0 to 7) := (
		"0000000000000000", 
		"1110101011100010", 
		"1111010011111111", 
		"0000101100000001", 
		"0001010100011110", 
		"0000000000000000", 
		"1110001001110000", 
		"1101101010001011"
		);
begin
	
	GEN: for i in 0 to 1 generate
		FIRST: if i = 0 generate
			count1: counter generic map(N_bit_counter => 2) port map(
				inc => "01",
				clk => clk_w,
				rst => rst_w,
				q_cnt => sig,
				cout_cnt => clk_slow);
		end generate FIRST;

		LAST: if i = 1 generate
			count2: counter generic map(N_bit_counter => 3) port map(
				inc => "001",
				clk => clk_slow,
				rst => rst_w,
				q_cnt => ind,
				cout_cnt => open
				);
		end generate LAST;
	end generate GEN;

	--wave <= oscillator_lut(to_integer(unsigned(ind)));
	wave <= custom_wave(to_integer(unsigned(ind)));
end bhvWaveGenerator;