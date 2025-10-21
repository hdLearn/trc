use clap::Parser;
use data_generation::lib::conversion::to_bin;
use rand::Rng;
use std::fs::File;
use std::io::{BufWriter, Write};

const DATA_WIDTH: u32 = 32;

#[derive(Parser, Debug)]
struct Args {
    /// Number of test vectors to generate
    #[arg(short, long, default_value_t = 100_000)]
    num_tests: u32,

    /// Output file name
    #[arg(short, long, default_value = "alu.dat")]
    output: String,
}

fn alu_compute(a: u32, b: u32, command: u8) -> u32 {
    match command {
        0b0000 => a.wrapping_add(b), // ADD
        0b0001 => a.wrapping_sub(b), // SUB
        0b0010 => {
            // SHIFT LEFT
            if b < DATA_WIDTH {
                a.wrapping_shl(b as u32)
            } else {
                0
            }
        }
        0b0011 => {
            // SHIFT RIGHT
            if b < DATA_WIDTH {
                a.wrapping_shr(b as u32)
            } else {
                0
            }
        }
        0b0100 => a & b, // AND
        0b0101 => a | b, // OR
        0b0110 => a ^ b, // XOR
        _ => 0,          // others
    }
}

fn main() -> std::io::Result<()> {
    let args = Args::parse(); // parse inputs
    let file = File::create(&args.output)?; // create the file
    let mut writer = BufWriter::new(file);
    let mut rng = rand::thread_rng(); // create a random RNG

    for _ in 0..args.num_tests {
        // Create random inputs
        let a: u32 = rng.r#gen();
        let b: u32 = rng.r#gen();
        let cmd: u8 = rng.r#gen_range(0..=6);

        // Compute the output
        let result = alu_compute(a, b, cmd);

        // Add all of this to a new line
        writeln!(
            writer,
            "{} {} {:04b} {}",
            to_bin(a, DATA_WIDTH),
            to_bin(b, DATA_WIDTH),
            cmd,
            to_bin(result, DATA_WIDTH)
        )?;
    }

    println!(
        "Successfully generated {} test vectors in {}",
        args.num_tests, args.output
    );
    Ok(())
}
