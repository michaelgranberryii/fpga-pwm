library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity sin_pwm is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pwm_sin_out : out std_logic);
end sin_pwm;

architecture Behavioral of sin_pwm is
    
    
    constant resolution : integer := 8;
    constant dvsr : std_logic_vector (31 downto 0) := std_logic_vector(to_unsigned(6000, 32));

    signal counter: integer;
    signal sin_pulse: std_logic;
    signal sin_thresh : integer := 2_500_000; -- 120_000_000/(50Hz)

    signal duty_sin : std_logic_vector(resolution downto 0);

    -- Start from slides
    signal addr: unsigned(resolution-1  downto 0);
    subtype addr_range is integer range 0 to 2**resolution - 1;
    type rom_type is array (addr_range) of unsigned(resolution - 1 downto 0);
    
    function init_rom return rom_type is
     variable rom_v : rom_type;
     variable angle : real;
     variable sin_scaled : real;
    begin
    
     for i in addr_range loop
       angle := real(i) * ((2.0 * MATH_PI) / 2.0**resolution);
       sin_scaled := (1.0 + sin(angle)) * (2.0**resolution - 1.0) / 2.0;
       rom_v(i) := to_unsigned(integer(round(sin_scaled)), resolution);
     end loop;
     return rom_v;
    end init_rom;
    
    constant rom : rom_type := init_rom;
    signal sin_data: unsigned(resolution-1 downto 0);
    -- End from slides



begin

pwm_i: entity work.pwm_enhanced 
  generic map (
      R => resolution
  )
  port map (
    clk => clk,
    rst => rst,
    dvsr => dvsr,
    duty => duty_sin,
    pwm_out => pwm_sin_out
  );


  process(clk, rst)
  begin
    if(rst = '1') then
      counter <= 0;
      sin_pulse <= '0';
    elsif rising_edge(clk) then
      if counter < sin_thresh-1 then
        counter <= counter + 1;
        sin_pulse <= '0';
      else
        counter <= 0;
        sin_pulse <= '1';
      end if;

      if (sin_pulse = '1') then
        addr <= unsigned(addr) + 1;
        sin_data <= rom(to_integer(addr));
        duty_sin <= '0' & std_logic_vector(unsigned(sin_data));
      end if;

      if (duty_sin = std_logic_vector(to_unsigned(2**resolution, resolution))) then
        duty_sin <= (others => '0');
      end if;
    end if;
  end process;

end Behavioral;
