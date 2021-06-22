library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity SAD is

	generic(p: positive);
	
	port(
		clk: in std_logic;
		rst: in std_logic;
		PA: in std_logic_vector(7 downto 0);
		PB: in std_logic_vector(7 downto 0);
		enable: in std_logic;
		SAD_output: out std_logic_vector(8+2*p-1 downto 0);
		data_valid: out std_logic
	);

end entity;

architecture Struct of SAD is

	signal q_a, q_b, d_c, q_c, out_mux_8: std_logic_vector(7 downto 0);
	signal out_mux_u, q_d: std_logic_vector(8+2*p-1 downto 0);
	signal enable_p, q_e, out_adder_b: std_logic_vector(p-1 downto 0);
	
	constant Num_of_pix: integer := 2**p;

	component DFC
		generic(N: positive);
		port(
			clk: in std_logic;
			reset: in std_logic;
			d: in std_logic_vector (N-1 downto 0);
			q: out std_logic_vector(N-1 downto 0)
		);
	end component;

	component AbsoluteDifference
	
		generic (
			N : positive:= 8
		);
	
		port(
			X: in std_logic_vector(N-1 downto 0);	--input
			Y: in std_logic_vector(N-1 downto 0);	--input
			Z: out std_logic_vector(N-1 downto 0);	--output
			clk: in std_logic;
			rst: in std_logic
		);
	end component;
	
	component Mux_2_1
		generic(N: positive);
		port(
			input1: in std_logic_vector(N-1 downto 0);
			input2: in std_logic_vector(N-1 downto 0);
			sel: in std_logic;
			output: out std_logic_vector(N-1 downto 0)
		);
	end component;

	component Counter2N
		generic(N: positive);
		port(
			clk: in std_logic;
			reset: in std_logic;
			input_cnt: in std_logic_vector(N-1 downto 0);
			y: out std_logic_vector(N-1 downto 0)
		);	
	end component;
	
	component Comparator
		
		generic(N: positive);
		port(
			eq: out std_logic;
			input1: in std_logic_vector (N-1 downto 0);
			input2: in std_logic_vector(N-1 downto 0)
		);
	end component;

begin

	DFC_A: DFC
		generic map(N=>8)
		port map(
			clk => clk,
			reset => rst,
			d => PA,
			q => q_a
		);

	DFC_B: DFC
		generic map(N=>8)
		port map(
			clk => clk,
			reset => rst,
			d => PB,
			q => q_b
		);
		
	ABS_DIFF_I: AbsoluteDifference
		generic map(N => 8)
		port map(
			X => q_a,
			Y => q_b,
			Z => d_c,
			clk => clk,
			rst => rst
		);

	DFC_C: DFC
		generic map(N=>8)
		port map(
			clk => clk,
			reset => rst,
			d => d_c,
			q => q_c
		);

	Mux_2_1_i: Mux_2_1
		generic map(N => 8)
		port map(
			input1 =>(others => '0'),
			input2 =>q_c,
			sel =>enable,
			output => out_mux_8
		);
	
	out_mux_u <= (8+2*p downto 8 => '0') & out_mux_8;
	
	DFC_D: DFC
		generic map(N=>8+2*p)
		port map(
			clk => clk,
			reset => rst,
			--d => std_logic_vector(resize(unsigned(out_mux_8), 8+2*p)),
			d => out_mux_u,
			q => q_d
		);

	counter_A: Counter2N
		generic map( N=> 8+2*p)
		port map(
			clk =>clk,
			reset => rst,
			input_cnt => q_d,
			y => SAD_output
		);
		
	enable_p <= (p downto 1 => '0') & enable;	
		
	DFC_E: DFC
		generic map(N=>p)
		port map(
			clk => clk,
			reset => rst,
			--d => std_logic_vector(resize(unsigned(enable), p)),
			d=>enable_p,
			q => q_e
		);
		
	counter_B: Counter2N
		generic map( N=> p)
		port map(
			clk =>clk,
			reset => rst,
			input_cnt => q_e,
			y => out_adder_b
		);
		
	Comparator_i: Comparator
		generic map(N => p)
		port map(
			input1 => out_adder_b,
			input2 => std_logic_vector(to_unsigned(Num_of_pix, p)),
			eq => data_valid
		);


end Struct;
