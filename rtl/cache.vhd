library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.trc_packages.all;

entity cache is
  generic (
    BYTE_WIDTH    : integer := 8;
    DATA_WIDTH    : integer := 32;
    COMMAND_WIDTH : integer := 3;
    MEMORY_SIZE   : integer := 15
  );
  port (
    clk             : in std_logic;
    command         : in std_logic_vector(COMMAND_WIDTH - 1 downto 0);
    data_bus        : in std_logic_vector(DATA_WIDTH - 1 downto 0);
    direct_data_bus : in std_logic_vector(BYTE_WIDTH - 1 downto 0);
    result          : in std_logic_vector(DATA_WIDTH - 1 downto 0);
    reg_address     : in vector_of_vectors(2 downto 0)(3 downto 0); -- Give the address of the registers point by the command with 0 : main_reg, 1 : sec_reg, 2 : save_reg.
    main_register   : out std_logic_vector(DATA_WIDTH - 1 downto 0);
    second_register : out std_logic_vector(DATA_WIDTH - 1 downto 0)
  );
end cache;

architecture rtl of cache is

  signal registers : vector_of_vectors(MEMORY_SIZE - 1 downto 0)(DATA_WIDTH - 1 downto 0);

begin

  process (clk)
  begin
    if rising_edge(clk) then
      -- Register 0 is to have a zero value and register 15 is a direct access to the direct_data_bus
      for i in 0 to 1 loop
        if not(unsigned(reg_address(i)) = 0) and not(unsigned(reg_address(i)) = 15) and (command(i) = '1') then
          registers(to_integer(unsigned(reg_address(i)))) <= data_bus;
        end if;
      end loop;
      if not(unsigned(reg_address(2)) = 0) and not(unsigned(reg_address(2)) = 15) and (command(2) = '1') then
        registers(to_integer(unsigned(reg_address(2)))) <= result;
      end if;
      registers(0) <= (others => '0');
    end if;
  end process;

  process (all)
  begin
    main_register <= registers(to_integer(unsigned(reg_address(0)))) when (command(0) = '0') and not(unsigned(reg_address(0)) = MEMORY_SIZE - 1) else
      (31 downto 8 => '0') & direct_data_bus;
    second_register <= registers(to_integer(unsigned(reg_address(1)))) when (command(1) = '0') and not(unsigned(reg_address(1)) = MEMORY_SIZE - 1) else
      (31 downto 8 => '0') & direct_data_bus;
  end process;

end architecture;