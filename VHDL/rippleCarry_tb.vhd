library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RippleCarry_tb is
end RippleCarry_tb;

architecture bhvRippleCarry_tb of RippleCarry_tb is
	constant T_CLK   : time := 10 ns; -- Clock period
	constant T_RESET : time := 25 ns;

	signal clk_tb  : std_logic := '0'; -- clock signal, intialized to '0' 
	signal rst_tb  : std_logic := '1';
	signal end_sim : std_logic := '1';
	signal tot : std_logic_vector(1 downto 0);
	signal out_reg : std_logic_vector(1 downto 0);
	signal cout_sig : std_logic;

	component rippleCarry is
	generic(N_bit_carry : integer);  -- generic parameter modelling the generic number of bits of the shift register
	port (
		a : in std_logic_vector((N_bit_carry - 1) downto 0);
		b : in std_logic_vector(N_bit_carry - 1 downto 0);
		cin : in std_logic;
		cout : out std_logic;
		s : out std_logic_vector(N_bit_carry - 1 downto 0)
		);
	end component;

	component myregister is
	generic(N_bit_reg : integer);
		port (
			d : in std_logic_vector((N_bit_reg - 1) downto 0);
			clk : in std_logic;
			rst : in std_logic;
			q : out std_logic_vector((N_bit_reg - 1) downto 0)
		);
	end component;

begin
	clk_tb <= (not(clk_tb) and end_sim) after T_CLK / 2;  -- The clock toggles after T_CLK / 2 when end_sim is high. When end_sim is forced low, the clock stops toggling and the simulation ends.
	rst_tb <= '0' after T_RESET;

	myripplecarry: rippleCarry
	generic map(N_bit_carry => 2)
	port map (
		a => "01",
		b => "01",
		cin => '0',
		cout => cout_sig,
		s => tot
	);

	myreg: myregister
	generic map(N_bit_reg => 2)
	port map (
		d => tot,
		clk => clk_tb,
		rst => rst_tb,
		q => out_reg
	);

end bhvRippleCarry_tb;