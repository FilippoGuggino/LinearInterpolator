library IEEE;
use IEEE.std_logic_1164.all;

entity counter is
generic (N_bit_counter : integer);
port(
	inc : in std_logic_vector(N_bit_counter - 1 downto 0);
	clk : in std_logic;
	rst: in std_logic;
	q_cnt : out std_logic_vector((N_bit_counter - 1) downto 0);
	cout_cnt : out std_logic
	);
end counter;

architecture bhvCNT of counter is
	signal s_sig : std_logic_vector((N_bit_counter - 1) downto 0);
	signal q_sig : std_logic_vector((N_bit_counter - 1) downto 0);
	signal tmp : std_logic;

	component rippleCarry is
	generic(N_bit_carry : integer);
		port(
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

	component DFlipFlop is
	port(
		d : in std_logic;
		clk : in std_logic;
		rst : in std_logic;
		q : out std_logic
		);
	end component;
begin
	

	ripple_carry: rippleCarry
	generic map(N_bit_carry => N_bit_counter)
	port map(
		a => q_sig,
		b => inc,
		cin => '0',
		cout => tmp,
		s => s_sig
	);

	dff: DFlipFlop
	port map (
		d => tmp,
		clk => clk,
		rst => rst,
		q => cout_cnt
	);

	myreg: myregister
	generic map(N_bit_reg => N_bit_counter)
	port map (
		d => s_sig,
		clk => clk,
		rst => rst,
		q => q_sig
	);

	q_cnt <= q_sig;
end bhvCNT;