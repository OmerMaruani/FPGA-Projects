library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main_controller is
    generic (
        C_MEM_DATA_WIDTH  : integer := 32; -- number of bits in each adress , 
        C_MEM_ADDRESS_BITS: integer := 5 -- number of bits in order to represent each adress in the memory
    );
    port (
        CLK             : in  std_logic;  -- System clock
        RST             : in  std_logic;  -- Active high asynchronous reset
        START           : in  std_logic;  -- Generates a 1-clock-cycle positive pulse on START press
        DISPLAY         : in  std_logic;  -- Generates a 1-clock-cycle positive pulse on DISPLAY press
        DIN             : in  std_logic_vector (7 downto 0); -- Data matrix element
        DIN_VALID       : in  std_logic; -- DIN data is valid on every clock edge when DIN_VALID is '1'
        DATA_REQUEST    : out std_logic; -- Positive pulse of one clock cycle width for receiving 16 matrix elements
        RESULT          : out std_logic_vector (16 downto 0) := (others=>'0'); -- Output values of the target matrix
        RESULTS_READY    : out std_logic; -- RESULT data is valid on every clock edge when RESULTS_READY is '1'
        GOT_ALL_MATRICES: out std_logic  -- Output goes to '1' after both source matrices are stored
    );
end entity; 

architecture behave of main_controller is
	-- Define the states of the state machine
    type state_type is (st_idle, st_receive_first_mat, st_receive_sec_mat, st_wait, st_calc, st_display);
    signal pr_state : state_type;
    -- Define constants
   constant N        : integer := 8;
   constant LATENCY  : integer := 1;
   constant IS_SIGNED: boolean := true;
	constant FIRST_MAT_WRITE_COMPLETE        : integer := 17;
	constant SEC_MAT_DATA_READY        : integer := 19;
	constant MATRIX_B_FIRST_COLUMN        : integer := 20;
	constant SEC_MAT_WRITE_COMPLETE        : integer := 40;
	constant MULTIPLICATION_RESULT_READY       : integer := 14;
	constant READ_MAT_B_COL       : integer := 10;
	constant ELEMENT_CALCULATION_COMPLETE  : integer := 33;
	constant MAT_ROWS  : integer := 4;
	constant MAT_COLS  : integer := 4;


	-- Define signals
    signal s_data         : std_logic_vector(C_MEM_DATA_WIDTH-1 downto 0); -- which data to insert to the ram
    signal s_wren         : std_logic := '0'; -- write enable input
    signal s_address      : std_logic_vector(C_MEM_ADDRESS_BITS-1 downto 0) := (others=>'0'); -- which adress in the ram we need to go
    signal s_be           : std_logic_vector(C_MEM_DATA_WIDTH/N-1 downto 0) := (others=>'0'); -- byte enable input
    signal s_q            : std_logic_vector(31 downto 0);  -- read the data from memory from specific adress
    signal counter        : integer := 0; -- count when clock rising
    signal a1, a2, a3, a4 : std_logic_vector(N-1 downto 0); -- elements from matrix a come here respectively
    signal b1, b2, b3, b4 : std_logic_vector(N-1 downto 0); -- elements from matrix b come here respectively
    signal q1, q2, q3, q4 : std_logic_vector(2*N-1 downto 0); -- this is the output of each the multiplies
    signal sum_of_pro     : std_logic_vector(2*N downto 0) := (others=>'0'); -- we take the output from the multilpis and sum it 
    signal s_din_valid    : std_logic; 
    signal s_address_mata : std_logic_vector(C_MEM_ADDRESS_BITS-1 downto 0) := (others=>'0'); -- will contain an address of one of the four rows in which matrix A is located
    signal s_address_matb : std_logic_vector(C_MEM_ADDRESS_BITS-1 downto 0) := "00100"; -- will contain an address of one of the four rows in which matrix B is located
    signal s_address_matc : std_logic_vector(C_MEM_ADDRESS_BITS-1 downto 0) := "00111"; -- will contain an address of one of the 16 rows in which matrix A is located
    signal a_counter, b_counter : integer := 0; --These counters will be used by us to understand which row in matrix A, and which page in matrix B to go to and read the information
	signal first_mat_element : integer := 1;
	signal sec_mat_element : integer := 0;
	-- Matrix RAM component:
	-- This component represents a RAM block for storing and retrieving data.
	-- It supports parameterized data width and address width.

  	component matrix_ram is
        generic (
            DATA_WIDTH   : integer := 32; -- Defines the width of the data bus 
            ADDRESS_BITS : integer := 5   -- Defines the width of the address bus
        );
        port (
            CLK          : in  std_logic;
            RST          : in  std_logic;
            DATA         : in  std_logic_vector(DATA_WIDTH-1 downto 0);    -- Input data to be written to memory
            WREN         : in  std_logic;                                  -- Write enable signal (active high) to allow data writing to memory.
            ADDRESS      : in  std_logic_vector(ADDRESS_BITS-1 downto 0);  -- Address for memory read/write operations
            BYTEENA      : in  std_logic_vector(DATA_WIDTH/N-1 downto 0);  -- Byte enable signal to selectively enable bytes for write operations.
            Q            : out std_logic_vector(DATA_WIDTH-1 downto 0)     --  Output data from memory
        );
    end component;

	-- Multiplier component:
	-- This component performs multiplication of two input vectors.
	-- It supports parameterized data width, latency, and signed/unsigned multiplication.
    
	component my_multiplier is
        generic (
            N         : integer := 8; -- Defines the bit-width of the input and output vectors
            LATENCY   : integer range 1 to 8 := 1; -- Defines the number of clock cycles for multiplication latency
			IS_SIGNED : boolean := false -- Specifies if the multiplication should handle signed numbers
        );
        port (
            CLK         : in  std_logic;  -- Clock signal for synchronous operation.
            DIN_VALID   : in  std_logic; -- Input signal indicating that the data inputs A and B are valid.
            A           : in  std_logic_vector(N-1 downto 0); -- First input vector for multiplication
            B           : in  std_logic_vector(N-1 downto 0); -- Second input vector for multiplication
            Q           : out std_logic_vector(N*2-1 downto 0); -- Output vector containing the result of the multiplication 
			DOUT_VALID  : out std_logic -- Output signal indicating that the result is valid.
		);
	end component;

BEGIN
	
	-- Mapping the components to the main controller
    mult1: my_multiplier
        generic map (
            N        => N,
            LATENCY  => LATENCY,
            IS_SIGNED => IS_SIGNED
        )
        port map (
            CLK       => CLK,
            DIN_VALID => s_din_valid,
            A         => a1,
            B         => b1,
            Q         => q1
        );

    mult2: my_multiplier
        generic map (
            N        => N,
            LATENCY  => LATENCY,
            IS_SIGNED => IS_SIGNED
        )
        port map (
            CLK       => CLK,
            DIN_VALID => s_din_valid,
            A         => a2,
            B         => b2,
            Q         => q2
        );

    mult3: my_multiplier
        generic map (
            N        => N,
            LATENCY  => LATENCY,
            IS_SIGNED => IS_SIGNED
        )
        port map (
            CLK       => CLK,
            DIN_VALID => s_din_valid,
            A         => a3,
            B         => b3,
            Q         => q3
        );

    mult4: my_multiplier
        generic map (
            N        => N,
            LATENCY  => LATENCY,
            IS_SIGNED => IS_SIGNED
        )
        port map (
            CLK       => CLK,
            DIN_VALID => s_din_valid,
            A         => a4,
            B         => b4,
            Q         => q4
        );

    inst_matrix_ram : matrix_ram
        generic map (
            DATA_WIDTH   => C_MEM_DATA_WIDTH,
            ADDRESS_BITS => C_MEM_ADDRESS_BITS
        )
        port map (
            CLK       => CLK,
            RST       => RST,
            DATA      => s_data,
            WREN      => s_wren,
            ADDRESS   => s_address,
            BYTEENA   => s_be,
            Q         => s_q
        );
	-- Finish mapping

	-- Define state machine
 process (CLK, RST)
begin
    if (RST = '1') then -- High active reset input; initializes all outputs and internal signals to their default states
        s_address <= (others => '0'); -- Reset address to zero
        pr_state <= st_idle; -- Set state to idle
        DATA_REQUEST <= '0'; -- Disable data request signal
        RESULTS_READY <= '0'; -- Indicate results are not ready
        GOT_ALL_MATRICES <= '0'; -- Reset matrix collection flag
        counter <= 0; -- Initialize counter to zero
        s_wren <= '0'; -- Disable write enable
    elsif rising_edge(CLK) then -- On the rising edge of the clock
        if (pr_state = st_idle) then
            counter <= -1; -- Initialize counter to -1 to set it to zero when transitioning to st_recive_first_mat state
        else
            counter <= counter + 1; -- Increment counter
        end if;
              
    case pr_state is
	
    -- The idle state of the state machine. In this state, no operations occur unless the start button is pressed.
    -- Upon pressing the start button, the system will transition to the state where it requests the elements of the first matrix
    -- and enables writing to memory.
	
    when st_idle =>
        -- Indicate that results are not ready.
        RESULTS_READY <= '0';
        -- Indicate that all matrix elements have not yet been received.
        GOT_ALL_MATRICES <= '0';

        -- Check if the start button is pressed.
        if (START = '1') then
            -- Enable write operation to memory.
            s_wren <= '1';
            -- Request data input for the first matrix.
            DATA_REQUEST <= '1';
            -- Transition to the state for receiving the first matrix.
            pr_state <= st_receive_first_mat;
        else
            -- Remain in the idle state if the start button is not pressed.
            pr_state <= st_idle;
        end if;

	-- State for receiving the first matrix. In this state, the system writes matrix data to memory
	-- byte by byte, starting from address 0. The address and byte enable signals are updated 
	-- according to the current counter value. Once a line is fully written, the system transitions 
	-- to the next address and begins writing the next line.
	
	when st_receive_first_mat =>

    -- Check if the counter indicates the first byte of the line.
    if counter = 1 then
        -- Set byte enable to write the first byte only.
        s_be <= "0001";
		first_mat_element <= 1; -- start writing first elemnt each row
        -- Set address to the starting address 0.
        s_address <= "00000";
    else
        -- For subsequent bytes in the line, update the address and byte enable signals.
        if first_mat_element = MAT_COLS then -- finish writing row
			first_mat_element <= 1;
            -- Update byte enable to write the next byte in the line.
            s_be <= "0001";
            -- Increment the address for the next byte.
            s_address <= std_logic_vector(unsigned(s_address) + 1);
        else
            -- For bytes within the same address, keep the byte enable signal unchanged.
            s_be <= s_be(2 downto 0) & '0';
			first_mat_element <= first_mat_element+1; -- write next element in the row
        end if;
    end if;

    -- Enable write operation to memory.
    s_wren <= '1';
    -- Do not request new data while writing.
    DATA_REQUEST <= '0';
    -- Set the data to be written (DIN repeated for each byte).
    s_data <= DIN & DIN & DIN & DIN;
    -- Indicate that results are not yet ready.
    RESULTS_READY <= '0';
    -- Indicate that all matrix elements have not yet been received.
    GOT_ALL_MATRICES <= '0';

    -- Check if all bytes of the first matrix line have been written.
    if counter = FIRST_MAT_WRITE_COMPLETE then
        -- Transition to the state for receiving the second matrix.
        pr_state <= st_receive_sec_mat;
        -- Disable write operation and request new data for the second matrix.
        s_wren <= '0';
        DATA_REQUEST <= '1';
        -- Set byte enable and address for the next matrix.
        s_be <= "0001";
        s_address <= "00011";
    end if;


	-- State for receiving the second matrix. In this state, the system writes matrix B data 
	-- to memory column by column. The starting address is set to 4, and the address is incremented 
	-- with each byte written. Once a column is fully written, the address is reset to 4 for the 
	-- next column. 

	when st_receive_sec_mat =>

    -- Do not request new data while writing to memory.
    DATA_REQUEST <= '0';
    -- Set the data to be written (DIN repeated for each byte).
    s_data <= DIN & DIN & DIN & DIN;

    -- Enable write operation to memory if the counter indicates that data should be written.
    if (counter > SEC_MAT_DATA_READY) then
        s_wren <= '1'; 
        -- Check if the counter indicates the end of a column (every 4 bytes) but not the last column.
        if sec_mat_element = MAT_ROWS then -- finish writing column
			sec_mat_element <= 1;
            -- Set address to 4 to start writing the next column.
            s_address <= "00100";
            -- Adjust byte enable to only affect the next byte.
            s_be <= s_be(2 downto 0) & '0';
        else
            -- Increment the address for the next byte in the current column.
            s_address <= std_logic_vector(unsigned(s_address) + 1);
			sec_mat_element <= sec_mat_element +1; -- write the next column
        end if;
    end if;

    -- Indicate that results are not yet ready.
    RESULTS_READY <= '0';
    -- Indicate that all matrix elements have not yet been received.
    GOT_ALL_MATRICES <= '0';

    -- Check if all bytes of the second matrix have been written.
    if counter = SEC_MAT_WRITE_COMPLETE then
        -- Transition to the waiting state after completing the write operation.
        pr_state <= st_wait;
        -- Reset the address to 0 for the next operation.
        s_address <= "00000";
    end if;

						
	-- Standby mode where the system remains idle until the start button is pressed.
	-- In this mode, the system indicates that all matrix data has been received and resets the counter.
	-- Pressing the START button transitions the system to the matrix calculation state.

	when st_wait =>
	first_mat_element <= 1;
	sec_mat_element <= 0;
    -- Indicate that all matrix elements have been successfully received.
    GOT_ALL_MATRICES <= '1';
    -- Reset the counter to 0, preparing for the next phase.
    counter <= 0;

    -- Check if the start button is pressed to begin the matrix calculation.
    if (START = '1') then
        -- Transition to the matrix calculation state.
        pr_state <= st_calc;
        -- Signal that the data input is valid for the calculation phase.
        s_din_valid <= '1';
    else
        -- Remain in the standby mode if the start button is not pressed.
        pr_state <= st_wait;
    end if;

	-- Matrix Multiplication and Memory Management:
	-- 1. Retrieve elements from matrices A and B stored in memory.
	-- 2. Input these elements into four parallel multipliers to perform the matrix multiplication.
	-- 3. Aggregate the products from each multiplier into a single result signal.
	-- 4. This result signal represents a single element of matrix C.
	-- 5. Write the computed element of matrix C to memory at the designated address.
	-- 6. Update memory addresses for matrices A, B, and C to ensure that all elements are processed:
	--    - Advance through rows of matrix A.
	--    - Advance through columns of matrix B.
	--    - Write results to appropriate locations in matrix C.
	-- 7. Ensure that each element of matrix C is stored at a unique address, facilitating correct and sequential storage 
	--    as matrix multiplication proceeds.


	when st_calc =>

    -- Indicate that all matrices have been received and processing can begin.
    GOT_ALL_MATRICES <= '1'; 

    -- When the counter is 0, load elements from row of matrix A from memory.
    if counter = 0 then
        a1 <= s_q(N-1 downto 0);      
        a2 <= s_q(2*N-1 downto N);     
        a3 <= s_q(3*N-1 downto 2*N);    
        a4 <= s_q(4*N-1 downto 3*N);    
        a_counter <= a_counter + 1; -- Increment row index for matrix A.
        s_address <= s_address_matb; -- Set address to matrix B for reading.

    -- When the counter indicates that the next set of elements from matrix B should be read.
    elsif counter = READ_MAT_B_COL-N or counter = READ_MAT_B_COL or counter = READ_MAT_B_COL+N or counter = READ_MAT_B_COL+2*N then
        b1 <= s_q(N-1 downto 0);     
        b2 <= s_q(2*N-1 downto N);     
        b3 <= s_q(3*N-1 downto 2*N);   
        b4 <= s_q(4*N-1 downto 3*N);    
        b_counter <= b_counter + 1; -- Increment column index for matrix B.
        s_address <= std_logic_vector(unsigned(s_address_matc) + 1); -- Move to the next address for matrix C.
    end if;
    
	-- When the counter indicates that results are ready (i.e., results from multipliers are available),
	-- accumulate the results into a signal.
    if counter = MULTIPLICATION_RESULT_READY-N or counter = MULTIPLICATION_RESULT_READY
 	or counter = MULTIPLICATION_RESULT_READY+N or counter = MULTIPLICATION_RESULT_READY+2*N then
        sum_of_pro <= std_logic_vector(
            signed(Q1(Q1'left) & Q1) + signed(Q2(Q2'left) & Q2) +
            signed(Q3(Q3'left) & Q3) + signed(Q4(Q4'left) & Q4)
        );
    end if;

    -- Write the accumulated results to memory when the counter indicates the end of a write operation.
    if counter = N-1 or counter = 2*N-1 or counter = 3*N-1 or counter = 4*N-1 then
        s_data(2*N downto 0) <= sum_of_pro(2*N downto 0); -- Load result into data signal.
        s_wren <= '1'; -- Enable write operation.
        s_be <= "0111"; -- Set byte enable to write all bytes.
    end if;

    -- Move to the next memory address for matrix C and update the address for matrix B.
    if counter = N or counter = 2*N or counter = 3*N or counter = 4*N then
        s_address_matc <= std_logic_vector(unsigned(s_address_matc) + 1); -- Increment address for matrix C.
        s_address <= std_logic_vector(unsigned(s_address_matb) + b_counter); -- Increment address for matrix B.
        s_wren <= '0'; -- Disable write operation for the moment.
    end if;

    -- Move to the next row of matrix A once processing of current row is complete.
    if counter = ELEMENT_CALCULATION_COMPLETE then
        s_address <= std_logic_vector(unsigned(s_address_mata) + a_counter); -- Increment address for matrix A.
    end if;


    -- Reset column index of matrix B and counter to start processing the next column.
    if counter = ELEMENT_CALCULATION_COMPLETE+1 then
        b_counter <= 0; -- Reset column index for matrix B.
        counter <= 0;  -- Reset counter for the next operation cycle.
    end if;

    -- Transition to the display state once all rows of matrix A are processed.
    if a_counter > MAT_ROWS then 
        pr_state <= st_display; -- Move to the display state.
        s_address <= "01000"; -- Set address for display operation.
        counter <= 0; -- Reset counter for display operations.
        a_counter <= 0; -- Reset row index for matrix A.
        b_counter <= 0; -- Reset column index for matrix B.
    end if;

                
	-- Display Mode Operation:
	-- 1. Initialize the display mode by setting the addresses for matrices C, B, and A.
	-- 2. Read the current element of matrix C from memory and update the RESULT output.
	-- 3. Indicate that results are available and all matrix data has been processed.
	-- 4. To display the next element of matrix C, press the DISPLAY button; the address is incremented accordingly.
	-- 5. To return to the initial idle state, press the START button, which resets the display mode.
	-- 6. Reset addresses to ensure that the subsequent calculations use the same memory locations for matrix C.

	when st_display =>

    -- Set addresses for matrices C, B, and A to their initial values for display.
    s_address_matc <= "00111"; -- Address for matrix C.
    s_address_matb <= "00100"; -- Address for matrix B.
    s_address_mata <= "00000"; -- Address for matrix A.

    -- Update the RESULT output with the current value from memory.
    RESULT(2*N downto 0) <= s_q(2*N downto 0);
    
    -- Indicate that not all matrices are yet ready for display.
    GOT_ALL_MATRICES <= '0';
    -- Set the flag indicating that results are ready to be displayed.
    RESULTS_READY <= '1';

    -- Check if the START button is pressed to return to the idle state.
    if (START = '1') then
        pr_state <= st_idle; -- Transition to idle state.
        RESULTS_READY <= '0'; -- Indicate that results are no longer being displayed.
    -- Check if the DISPLAY button is pressed to show the next element.
    elsif (DISPLAY = '1') then
        -- Increment the address to point to the next element of matrix C.
        s_address <= std_logic_vector(unsigned(s_address) + 1);
        -- Remain in the display state to continue showing matrix elements.

        -- If the address reaches the last position (address 23), reset to the beginning (address 8).
        if (s_address = "10111") then -- Address 23 (binary for decimal 23).
            s_address <= "01000"; -- Reset address to 8 (binary for decimal 8).
        end if;

        -- Logic for displaying the next element can be added here.
    end if;

                
                when others => 
                    null;
            end case;
        end if;
    end process;
end behave;

