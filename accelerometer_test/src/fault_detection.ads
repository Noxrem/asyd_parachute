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
   procedure Run_Fault_FSM (inputValues : Measurement_Values_t);
   
   -- Light up two pixels on the left on the display
   procedure Display_Left_Fault;
   
   -- Light up two pixels on the right on the dislay
   procedure Display_Right_Fault;
end fault_detection;
