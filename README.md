# Assembly Calculator

A simple calculator program written in x86-64 assembly language that supports basic arithmetic operations on integers.

## Features

- **Addition** (`+`): Add two integers
- **Subtraction** (`-`): Subtract second integer from first
- **Multiplication** (`*`): Multiply two integers  
- **Division** (`/`): Integer division with error handling for division by zero
- **Interactive Interface**: User-friendly prompts for input
- **Negative Number Support**: Handles both positive and negative integers
- **Error Handling**: Graceful handling of division by zero and invalid operations
- **Continuous Operation**: Option to perform multiple calculations

## Requirements

- Linux x86-64 system
- NASM (Netwide Assembler)
- GNU ld (linker)

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/Srimadhav-Seebu-Kumar/assembly-calculator.git
   cd assembly-calculator
   ```

2. Install NASM (if not already installed):
   ```bash
   # Ubuntu/Debian
   sudo apt-get install nasm
   
   # CentOS/RHEL/Fedora
   sudo yum install nasm
   # or
   sudo dnf install nasm
   ```

## Building and Running

1. **Assemble the program:**
   ```bash
   nasm -f elf64 calculator.asm -o calculator.o
   ```

2. **Link the object file:**
   ```bash
   ld calculator.o -o calculator
   ```

3. **Run the calculator:**
   ```bash
   ./calculator
   ```

### One-line build command:
```bash
nasm -f elf64 calculator.asm -o calculator.o && ld calculator.o -o calculator && ./calculator
```

## Usage

When you run the program, it will:

1. Display a welcome message and available operations
2. Prompt you to enter the first number
3. Ask you to choose an operation (`+`, `-`, `*`, `/`)
4. Prompt you to enter the second number
5. Display the result
6. Ask if you want to continue with another calculation

### Example Session

```
Simple Assembly Calculator
Operations: +, -, *, /
Enter first number: 15
Enter operation (+, -, *, /): *
Enter second number: 4
Result: 60
Continue? (y/n): y

Enter first number: 20
Enter operation (+, -, *, /): /
Enter second number: 3
Result: 6
Continue? (y/n): n
Goodbye!
```

## Input Format

- **Numbers**: Enter integers (positive or negative)
  - Examples: `42`, `-15`, `0`, `1000`
- **Operations**: Enter one of the four supported operators
  - `+` for addition
  - `-` for subtraction  
  - `*` for multiplication
  - `/` for division
- **Continue prompt**: Enter `y` or `Y` to continue, anything else to exit

## Error Handling

- **Division by Zero**: The program will display an error message and exit if you attempt to divide by zero
- **Invalid Operation**: Any operation other than `+`, `-`, `*`, `/` will result in an error
- **Input Validation**: The program handles negative numbers and validates input format

## Technical Details

### Architecture
- **Target**: x86-64 Linux systems
- **Assembler**: NASM (Netwide Assembler)
- **System Calls**: Uses Linux system calls for I/O operations
  - `sys_read` (0) for input
  - `sys_write` (1) for output  
  - `sys_exit` (60) for program termination

### Key Functions
- `read_number`: Converts string input to integer with negative number support
- `read_operation`: Reads operation character from user input
- `calculate`: Performs the arithmetic operation based on user choice
- `print_number`: Converts integer result back to string for display

### Memory Layout
- **Data Section**: Contains all string literals and messages
- **BSS Section**: Reserves space for runtime variables
- **Text Section**: Contains the executable code

## File Structure

```
assembly-calculator/
├── calculator.asm    # Main assembly source code
├── README.md        # This documentation
└── .gitignore      # Git ignore rules
```

## Contributing

Feel free to contribute to this project by:
- Reporting bugs or issues
- Suggesting new features
- Improving documentation
- Submitting pull requests

## License

This project is open source. Feel free to use, modify, and distribute as needed.

## Educational Purpose

This calculator serves as an educational example demonstrating:
- x86-64 assembly programming
- System call usage in Linux
- String to integer conversion in assembly
- Integer to string conversion in assembly
- Basic arithmetic operations in assembly
- User input/output handling
- Error handling in low-level programming
