library IEEE;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;

entity LinearInterpolator is
generic (
		N_bit : integer;
		Interpolation_factor : integer
		);
port(
	y_in : in std_logic_vector((N_bit - 1) downto 0);
	clk_int : in std_logic;
	y_out_int : out std_logic_vector((N_bit - 1) downto 0);
	rst_int : in std_logic;

	--lut_out : out std_logic_vector(1 downto 0)
	mul_curr_out : out std_logic_vector((N_bit + 2) downto 0);
	mul_prev_out : out std_logic_vector((N_bit + 2) downto 0);
	in_curr_out : out std_logic_vector(N_bit -1 downto 0); 
	in_prev_out : out std_logic_vector(N_bit -1 downto 0);
	cnt_out : out std_logic_vector(1 downto 0);
	clock_slow : out std_logic
	);
end LinearInterpolator;

architecture bhvLinInterpolator of LinearInterpolator is

	component myregister is
	generic(N_bit_reg : integer);
		port (
			d : in std_logic_vector((N_bit_reg - 1) downto 0);
			clk : in std_logic;
			rst : in std_logic;
			q : out std_logic_vector((N_bit_reg - 1) downto 0)
		);
	end component;
	
	component counter is
	generic(N_bit_counter : integer);
		port(
			inc : in std_logic_vector((N_bit_counter - 1) downto 0);
			clk : in std_logic;
			rst: in std_logic;
			q_cnt : out std_logic_vector((N_bit_counter - 1) downto 0);
			cout_cnt : out std_logic
			);
	end component;

	--this is u = k/L {L = 0, 1, 2, 3}
	type lut_t is array(natural range<>) of std_logic_vector(2 downto 0);

	-- a 0 prefix in order for it to be a positive number in C2
	constant lut: lut_t := (
			"000",
			"001",
			"010",
			"011"
		);

	constant lut_n : lut_t := (
			"001",
			"011",
			"010",
			"001"
		);

	signal ind : std_logic_vector(1 downto 0);
	signal in_curr : std_logic_vector((N_bit - 1) downto 0);
	signal in_prev : std_logic_vector((N_bit - 1) downto 0);
	signal mul_curr : signed((N_bit + 2) downto 0);
	signal mul_prev : signed((N_bit + 2) downto 0);
	signal tmp : std_logic_vector((N_bit + 2) downto 0);
	signal clk_slow : std_logic;
begin
	
	mycnt: counter 
	generic map(N_bit_counter => 2)
	port map (
		inc => (0 => '1', others => '0'),
		clk => clk_int,
		rst => rst_int,
		q_cnt => ind,
		cout_cnt => clk_slow
	);

	myreg: myregister
	generic map(N_bit_reg => N_bit)
	port map (
		d => y_in,
		clk => clk_slow,
		rst => rst_int,
		q => in_prev
	);


	--lut_out <= lut(to_integer(unsigned(ind)));
	-- non penso serva ind <= (0 => ind(2), others => '0');

	mul_curr <= signed(in_curr) * signed(lut(to_integer(unsigned(ind))));

	mul_prev <= signed(in_prev) * signed(lut_n(to_integer(unsigned(ind))));

	mul_curr_out <= std_logic_vector(mul_curr);
	mul_prev_out <= std_logic_vector(mul_prev);
	in_curr_out <= in_curr;
	in_prev_out <= in_prev;
	cnt_out <= ind;
	clock_slow <= clk_slow;

	tmp <= std_logic_vector(mul_curr + mul_prev) when ind="00" 
		else std_logic_vector(shift_right((mul_curr + mul_prev), 2));


	y_out_int <= tmp((N_bit - 1) downto 0);

	in_curr <= y_in;

end bhvLinInterpolator;