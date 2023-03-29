with MicroBit.IOs; use MicroBit.IOs;

package fault_detection is
   
   -- Record to store the input values for the FSM (finite state machine)
   type Measurement_Values_t is record
      bFreefallDetect : Boolean;
      aValueMotor : Analog_Value; -- Value of the pin P0 (M- on motor)
      aValueRStrand : Analog_Value; -- Value of the pin P1 (middle left strand)
      aValueLStrand : Analog_Value; -- Value of the pin P2 (middle left strand)
      bValueFetRT : Boolean;
      bValueFetLT : Boolean;
   end record;
   
   -- Initializes the FSM
   procedure Init_FSM;
   
   -- Run the finite state machine that processes the faults of the motor driver board
   procedure Run_Fault_FSM (inputValues : Measurement_Values_t; bMotorRStrand : in out Boolean; bMotorLStrand : in out Boolean);
   
   -- Light up two pixels on the left on the display
   procedure Display_Left_Fault;
   
   -- Light up two pixels on the right on the dislay
   procedure Display_Right_Fault;
   
   -- Light up four pixels on the left to show that the left strand is active
   procedure Display_Left_Strand;
   
   -- Light up four pixels on the right to show that the right strand is active
   procedure Display_Right_Strand;
   
   -- Light up the one pixle in the middle to show detection of freefall
   procedure Display_Freefall;
   
end fault_detection;
