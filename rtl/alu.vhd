-- ALU : Arithmetic Logic Unit
-- This entity represents the computational core of the CPU.
-- It performs arithmetic (addition, subtraction, etc.) and logical operations (AND, OR, XOR, etc.).

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  generic (
    DATA_WIDTH    : integer := 32;
    COMMAND_WIDTH : integer := 4
  );
  port (
    main_value   : in std_logic_vector(DATA_WIDTH - 1 downto 0);
    second_value : in std_logic_vector(DATA_WIDTH - 1 downto 0);
    command      : in std_logic_vector(COMMAND_WIDTH - 1 downto 0);
    result_value : out std_logic_vector(DATA_WIDTH - 1 downto 0)
  );
end alu;

architecture rtl of alu is
  signal shift_amount : integer;
begin

  -- Compute the shift amount with a maximal value set at DATA_WIDTH to avoid overflow
  shift_amount <= DATA_WIDTH when unsigned(second_value) > DATA_WIDTH else
    to_integer(unsigned(second_value));

  -- ALU logic
  process (all)
  begin
    case to_integer(unsigned(command)) is
      when 0 => -- Addition
        result_value <= std_logic_vector(unsigned(main_value) + unsigned(second_value));
      when 1 => -- Subtraction
        result_value <= std_logic_vector(unsigned(main_value) - unsigned(second_value));
      when 2 => -- Logical left shift by shift_amount bits
        result_value <= std_logic_vector(shift_left(unsigned(main_value), shift_amount));
      when 3 => -- Logical right shift by shift_amount bits
        result_value <= std_logic_vector(shift_right(unsigned(main_value), shift_amount));
      when 4 => -- AND
        result_value <= main_value and second_value;
      when 5 => -- OR
        result_value <= main_value or second_value;
      when 6 => -- XOR
        result_value <= main_value xor second_value;
      when 7 => -- Equal
        result_value(0) <= '1' when (main_value = second_value) else
        '0';
        result_value(DATA_WIDTH - 1 downto 1) <= (others => '0');
      when 8                                           => -- Less than
        result_value(0) <= '1' when (main_value < second_value) else
        '0';
        result_value(DATA_WIDTH - 1 downto 1) <= (others => '0');
      when others                                      => -- Default
        result_value <= (others                          => '0');
    end case;
  end process;

end architecture;