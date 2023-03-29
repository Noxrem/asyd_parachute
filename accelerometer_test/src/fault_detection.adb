with MicroBit.Console;
with MicroBit.Display;

use MicroBit;

package body fault_detection is

   -- States type of the finite state machine
   type State_t is (Both_Strands, Left_Strand, Right_Strand);
   subtype Analog_Low_Level is Analog_Value range 0..20;
   subtype Analog_High_Level is Analog_Value range 1000..1023;

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

   procedure Init_FSM is
   begin
      curState := Both_Strands;
      nxtState := Both_Strands;
   end Init_FSM;

   procedure Run_Fault_FSM (inputValues : Measurement_Values_t) is
   begin
      case curState is
         when Both_Strands =>
            Console.Put_Line("State both strands");
            --if inputValues.bFreefallDetect then
            --end if;

         when Left_Strand =>
            Console.Put_Line("State left strand");
         when Right_Strand =>
            Console.Put_Line("State right strand");
      end case;
   end Run_Fault_FSM;

end fault_detection;
