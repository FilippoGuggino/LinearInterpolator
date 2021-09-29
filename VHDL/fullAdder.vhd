library IEEE;
use IEEE.std_logic_1164.all;

entity fullAdder is
port (
	a : in std_logic;
	b : in std_logic;
	cin: in std_logic;
	cout: out std_logic;
	s: out std_logic
);
	
end entity fullAdder;

architecture bhvFA of fullAdder is

begin
	cout <= ((cin and a) or (cin and b) or (a and b));
	s <= (a xor b xor cin); 
end bhvFA;