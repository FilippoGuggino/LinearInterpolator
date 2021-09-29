library IEEE;
use IEEE.std_logic_1164.all;

entity rippleCarry is 
	generic(N_bit_carry : integer);  -- generic parameter modelling the generic number of bits of the shift register
	port (
		a : in std_logic_vector((N_bit_carry - 1) downto 0);
		b : in std_logic_vector(N_bit_carry - 1 downto 0);
		cin : in std_logic;
		cout : out std_logic;
		s : out std_logic_vector(N_bit_carry - 1 downto 0)
	);
end rippleCarry;

architecture bhvRC of rippleCarry is

	component fullAdder
		port (
			a : in std_logic;
			b : in std_logic;
			cin : in std_logic;
			cout : out std_logic;
			s : out std_logic
			);
	end component fullAdder;

	signal c : std_logic_vector(N_bit_carry - 2 downto 0);
begin
	--let's generate N full adders in the sky of tonight where everything is fine
	GEN: for i in 0 to (N_bit_carry - 1) generate
		FIRST: if i = 0 generate 
					FANUCCI1 : fullAdder port map (a(0), b(0), cin, c(0), s(0));
			   end generate FIRST;
		INTERNAL: if i > 0 and i < (N_bit_carry - 1) generate
					FANUCCII : fullAdder port map (a(i), b(i), c(i-1), c(i), s(i));
			      end generate INTERNAL;
		LAST: if i = (N_bit_carry - 1) generate
					FANUCCIN : fullAdder port map (a(i), b(i), c(i-1), cout, s(i));
			  end generate LAST;
	end generate GEN;
end bhvRC;
