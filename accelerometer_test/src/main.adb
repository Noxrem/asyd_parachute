------------------------------------------------------------------------------
-- Template                                                                         --
------------------------------------------------------------------------------

with LSM303; use LSM303;

with MicroBit.Display;
with MicroBit.Accelerometer;
with MicroBit.Console;
with MicroBit.IOs;
with MicroBit.Time;
with MicroBit.Buttons;

with freefall_detection;
with fault_detection;
with motor;

use MicroBit;
use MicroBit.Buttons;
use MicroBit.IOs;
use freefall_detection;
use motor;
use fault_detection;

procedure Main is

   Data : LSM303.All_Axes_Data;
   --Value : MicroBit.IOs.Analog_Value;
   sFactor_Sqrd : S_Factor_Sqrd_t;
   sFactorFallThresh : constant S_Factor_Sqrd_t := 3000; -- Threshold under which a freefall is considered
   iFallCounter : Integer := 0;
   iFallCounterThresh : constant Integer := 4; -- 3 before
   bFreefallDetected : Boolean := False;   -- Becomes true when a freefall
                                           -- got detected

   bButtonA : Boolean := False; -- Current button state
   bButtonAPrev : Boolean := False; -- Previous button state for debouncing

   bButtonB : Boolean := False;
   bButtonBPrev : Boolean := False;

   bMotorLStrand : Boolean := False; -- Left MOSFET strand for the motor
   bMotorRStrand : Boolean := False; -- Right MOSFET strand for the motor

   --     -- MOSFET pins
   --  pFetLT : constant Pin_Id := 8; -- MOSFET left top
   --  pFetRT : constant Pin_Id := 13; -- MOSFET right top
   --  pFetLB : constant Pin_Id := 15; -- MOSFET left bottom
   --  pFetRB : constant Pin_Id := 16; -- MOSFET right bottom

   aValueLStrand : Analog_Value := 0; -- Value of the pin P2 (middle left strand)
   aValueRStrand : Analog_Value := 0; -- Value of the pin P1 (middle left strand)
   aValueMotor : Analog_Value := 0; -- Value of the pin P0 (M- on motor)
   bValueFetLT : Boolean;
   bValueFetRT : Boolean;

   measValues : Measurement_Values_t; -- Input for the FSM (measurements)
begin

   Console.Put_Line ("Accelerator Test");

   loop

      --  Read the accelerometer data
      Data := Accelerometer.Data;

      bFreefallDetected := False;   -- Initialize the freefall detection

      --  Print the data on the serial port
      --  Console.Put_Line ("X:" & Data.X'Img & ASCII.HT &
      --                    "Y:" & Data.Y'Img & ASCII.HT &
      --                      "Z:" & Data.Z'Img);
      -- Print the S-Factor of the accelerator data (convert Float to String)
      sFactor_Sqrd := get_S_Factor_Sqrd(Data);
      if sFactor_Sqrd <= sFactorFallThresh then
         if iFallCounter >= iFallCounterThresh then
            Console.Put_Line ("S-Factor squared:" & sFactor_Sqrd'Img);
            bFreefallDetected := True;
            Display_Freefall; -- Show that freefall got detected
            iFallCounter := 0; -- Reset
         else
            iFallCounter := iFallCounter + 1; -- Increment counter
         end if;
      end if;
      --  Clear the LED matrix
      Display.Clear;

      -- Button Handling
      if State(Button_A) = Pressed then -- Set the current state of the button
         bButtonA := True;
      else
         bButtonA := False;
      end if;

      if State(Button_B) = Pressed then
         bButtonB := True;
      else
         bButtonB := False;
      end if;

      -- Detect pos. edge, turn on/off left motor strand
      if bButtonA and bButtonAPrev = False then
         bMotorLStrand := not bMotorLStrand;
      end if;
      -- Detect pos. edge, turn on/off right motor strand
      if bButtonB and bButtonBPrev = False then
         bMotorRStrand := not bMotorRStrand;
      end if;

      -- Set the previous button state to current
      bButtonAPrev := bButtonA;
      bButtonBPrev := bButtonB;
      -- Displays a 'F' if freefall is detected
      --  if bFreefallDetected then
      --     -- For now lets both strand run
      --     bMotorLStrand := True;
      --     bMotorRStrand := True;
      --  end if;
      --
      -- Read analogue pin 0, 1 and 2
      aValueLStrand := MicroBit.IOs.Analog(2);
      aValueRStrand := MicroBit.IOs.Analog(1);
      aValueMotor := MicroBit.IOs.Analog(0);
      -- Read digital MOSFET pins
      bValueFetLT := MicroBit.IOs.Set(pFetLT);
      bValueFetRT := MicroBit.IOs.Set(pFetRT);

      -- Prepare measurements to put into FSM
      measValues.bFreefallDetect := bFreefallDetected;
      measValues.aValueMotor := aValueMotor;
      measValues.aValueRStrand := aValueRStrand;
      measValues.aValueLStrand := aValueLStrand;
      measValues.bValueFetRT := bValueFetRT;
      measValues.bValueFetLT := bValueFetLT;

      -- Run finite state machine to detect the fault and decide which motor
      -- strand to activate
      Run_Fault_FSM(measValues, bMotorRStrand, bMotorLStrand);



      -- Activate the chosen motor strand
      motor.Run(bMotorRStrand, bMotorLStrand);

      -- Output values to the console
      Console.Put_Line ("Value Mot : " & aValueMotor'Image &
                          " R Str : " & aValueRStrand'Image &
                          " L Str : " & aValueLStrand'Image &
                          " FetRT : " & bValueFetRT'Image &
                          " FetLT : " & bValueFetLT'Image);

      --
      Time.Sleep (50);
   end loop;
end Main;
