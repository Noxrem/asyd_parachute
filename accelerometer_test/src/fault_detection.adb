with MicroBit.Console;
with MicroBit.Display;
with motor;

use MicroBit;
use motor;

package body fault_detection is

   -- States type of the finite state machine
   type State_t is (Both_Strands, Left_Strand, Right_Strand);
   subtype rAnalog_Low_Level is Analog_Value range 0..20;
   subtype rAnalog_High_Level is Analog_Value range 1000..1023;

   -- State variables for the FSM
   curState : State_t := Both_Strands;
   nxtState : State_t := Both_Strands;

   procedure Display_Left_Fault is
   begin
      MicroBit.Display.Set(0, 4);
      MicroBit.Display.Set(1, 4);
   end Display_Left_Fault;

   procedure Display_Right_Fault is
   begin
      MicroBit.Display.Set(4, 4);
      MicroBit.Display.Set(3, 4);
   end Display_Right_Fault;

   procedure Display_Left_Strand is
   begin
      MicroBit.Display.Set(0, 0);
      MicroBit.Display.Set(1, 0);
      MicroBit.Display.Set(0, 1);
      MicroBit.Display.Set(1, 1);
   end Display_Left_Strand;

   procedure Display_Right_Strand is
   begin
      MicroBit.Display.Set(3, 0);
      MicroBit.Display.Set(4, 0);
      MicroBit.Display.Set(3, 1);
      MicroBit.Display.Set(4, 1);
   end Display_Right_Strand;

   procedure Display_Freefall is
   begin
      MicroBit.Display.Set(2, 2);
   end Display_Freefall;

   procedure Init_FSM is
   begin
      curState := Both_Strands;
      nxtState := Both_Strands;
   end Init_FSM;

   procedure Run_Fault_FSM (inputValues : Measurement_Values_t; bMotorRStrand : in out Boolean; bMotorLStrand : in out Boolean) is
   begin
      -- Set activated strands to default
      --bMotorLStrand := False;
      --bMotorRStrand := False;
      -- FSM
      case curState is
         when Both_Strands =>
            Console.Put_Line("State both strands");
            -- When freefall detected -> activate both motor strands
            if inputValues.bFreefallDetect then
               bMotorLStrand := True;
               bMotorRStrand := True;
            end if;

            -- When Fault 1: short at FET LT between D-G
            if inputValues.bValueFetLT and
              inputValues.aValueMotor in rAnalog_High_Level and
              inputValues.aValueRStrand in rAnalog_High_Level and
              inputValues.aValueLStrand in rAnalog_High_Level then
               MicroBit.IOs.Set(pFetLT, True); -- Set gate high -> avoid short through MCU
               nxtState := Right_Strand; -- Set next state
            end if;

            -- When Fault 4: short at FET RT between D-G
            if inputValues.bValueFetRT and
              inputValues.aValueMotor in rAnalog_High_Level and
              inputValues.aValueRStrand in rAnalog_High_Level and
              inputValues.aValueLStrand in rAnalog_High_Level then
               MicroBit.IOs.Set(pFetRT, True); -- Set gate high -> avoid short through MCU
               nxtState := Left_Strand; -- Set next state
            end if;

            -- When Fault 3,7,8:
            if inputValues.aValueMotor in rAnalog_High_Level and -- Checks if value in range
              inputValues.aValueRStrand in rAnalog_High_Level and
              inputValues.aValueLStrand in rAnalog_Low_Level then
               nxtState := Right_Strand; -- Set next state
            end if;

            -- When Fault 6,10,11:
            if inputValues.aValueMotor in rAnalog_High_Level and
              inputValues.aValueRStrand in rAnalog_Low_Level and
              inputValues.aValueLStrand in rAnalog_High_Level then
               nxtState := Left_Strand; -- Set next state
            end if;

            --------------------------------------------------------------------
         when Left_Strand =>
            Console.Put_Line("State left strand");
            Display_Right_Fault; -- Display right fault on LED matrix

            -- When freefall detected -> activate left motor strands
            if inputValues.bFreefallDetect then
               bMotorLStrand := True;
            end if;

            -- When the fault gets resolved -> activate both strands again
            if inputValues.bValueFetRT = False and
              inputValues.aValueMotor in rAnalog_High_Level and
              inputValues.aValueRStrand in rAnalog_High_Level and
              inputValues.aValueLStrand in rAnalog_High_Level then
               nxtState := Both_Strands; -- Set next state
            end if;
            --------------------------------------------------------------------
         when Right_Strand =>
            Console.Put_Line("State right strand");
            Display_Left_Fault; -- Display left fault on LED matrix

            -- When freefall detected -> activate right motor strands
            if inputValues.bFreefallDetect then
               bMotorRStrand := True;
            end if;

            -- When the fault gets resolved -> activate both strands again
            if inputValues.bValueFetLT = False and
              inputValues.aValueMotor in rAnalog_High_Level and
              inputValues.aValueRStrand in rAnalog_High_Level and
              inputValues.aValueLStrand in rAnalog_High_Level then
               nxtState := Both_Strands; -- Set next state
            end if;
      end case;
      curState := nxtState; -- Update the next state
   end Run_Fault_FSM;

end fault_detection;
