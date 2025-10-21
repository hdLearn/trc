library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all; -- allows reading std_logic_vectors directly

entity tb_alu is
end entity;

architecture sim of tb_alu is

  constant DATA_WIDTH    : integer := 32;
  constant COMMAND_WIDTH : integer := 4;

  signal main_value   : std_logic_vector(DATA_WIDTH - 1 downto 0)    := (others => '0');
  signal second_value : std_logic_vector(DATA_WIDTH - 1 downto 0)    := (others => '0');
  signal command      : std_logic_vector(COMMAND_WIDTH - 1 downto 0) := (others => '0');
  signal result_value : std_logic_vector(DATA_WIDTH - 1 downto 0);

begin

  -- ALU instantiation
  alu : entity work.alu
    port map
    (
      main_value   => main_value,
      second_value => second_value,
      command      => command,
      result_value => result_value
    );

  ------------------------------------------------------------------------
  -- Test process
  ------------------------------------------------------------------------
  process
    file f_in        : text open read_mode is "data_generation/alu.dat";
    variable L       : line;
    variable mv, sv  : std_logic_vector(DATA_WIDTH - 1 downto 0);
    variable cmd     : std_logic_vector(COMMAND_WIDTH - 1 downto 0);
    variable res_exp : std_logic_vector(DATA_WIDTH - 1 downto 0);
  begin
    report "==== Starting file-driven ALU test ====";

    while not endfile(f_in) loop
      readline(f_in, L);
      -- Read comma-separated values
      read(L, mv);
      read(L, sv);
      read(L, cmd);
      read(L, res_exp);

      main_value   <= mv;
      second_value <= sv;
      command      <= cmd;
      wait for 10 ns;

      assert result_value = res_exp
      report "Mismatch! " &
        "MV=" & to_string(mv) & ", SV=" & to_string(sv) &
        ", CMD=" & to_string(cmd) &
        ", got=" & to_string(result_value) &
        ", expected=" & to_string(res_exp)
        severity error;
    end loop;

    report "==== File-driven test complete ====";
    wait;
  end process;

end architecture sim;
