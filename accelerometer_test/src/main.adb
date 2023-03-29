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
--with MicroBit.Music;

with freefall_detection;
with fault_detection;

use MicroBit;
use MicroBit.Buttons;
use MicroBit.IOs;
use freefall_detection;
use fault_detection;
--use MicroBit.Music;
--use MicroBit.IOs;


procedure Main is

   Data : LSM303.All_Axes_Data;
   --Value : MicroBit.IOs.Analog_Value;
   sFactor_Sqrd : S_Factor_Sqrd_t;
   sFactorFallThresh : constant S_Factor_Sqrd_t := 3000; -- Threshold under which a freefall is considered
   iFallCounter : Integer := 0;
   iFallCounterThresh : constant Integer := 3; -- 3 before
   bFreefallDetected : Boolean := False;   -- Becomes true when a freefall
                                           -- got detected
   --tonePin : constant Pin_Id := 0;                  -- Pin for the speaker
   --toneDuration : constant Time.Time_Ms := 200;    -- Duration of a tone
   --nFreefallTone : constant Note := (P => A4,              -- Tone played on freefall
   --                         Ms => toneDuration);
   bMotorLStrand : Boolean := False; -- Left MOSFET strand for the motor
   bMotorRStrand : Boolean := False; -- Right MOSFET strand for the motor
   iMotorCounter : Integer := 0; -- Counter gets incremented as long the motor is running
   iMotorCounterLim : constant Integer := 6; -- Time duration which the motor runs (x50 ms)

   bButtonA : Boolean := False; -- Current button state
   bButtonAPrev : Boolean := False; -- Previous button state for debouncing

   bButtonB : Boolean := False;
   bButtonBPrev : Boolean := False;

   pFetLT : constant Pin_Id := 8; -- MOSFET left top
   pFetRT : constant Pin_Id := 13; -- MOSFET right top
   pFetLB : constant Pin_Id := 15; -- MOSFET left bottom
   pFetRB : constant Pin_Id := 16; -- MOSFET right bottom
   aValueLStrand : Analog_Value := 0; -- Value of the pin P2 (middle left strand)
   aValueRStrand : Analog_Value := 0; -- Value of the pin P1 (middle left strand)
   aValueMotor : Analog_Value := 0; -- Value of the pin P0 (M- on motor)
   bValueFetLT : Boolean;
   bValueFetRT : Boolean;
   bValueFetLB : Boolean;
   bValueFetRB : Boolean;
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

      -- Let the motor run for the bMotorCounterLim amount of time
      if (bMotorLStrand or bMotorRStrand) -- If one motor strand is on
        and iMotorCounter < iMotorCounterLim then -- And counter is still running
         iMotorCounter := iMotorCounter + 1; -- Increment the motor counter

         if bMotorLStrand then
            -- Turn on the GPIO P8 and P15 (left strand)
            MicroBit.IOs.Set(pFetLT, True);
            MicroBit.IOs.Set(pFetLB, True);
            Display_Left_Fault; -- Display left fault
         end if;

         if bMotorRStrand then
            --  Turn on the GPIO P9 and P16 (right strand)
            MicroBit.IOs.Set(pFetRT, True);
            MicroBit.IOs.Set(pFetRB, True);
            Display_Right_Fault; -- Display right fault
         end if;
         Display.Display('F'); -- Show 'F' on display
      else -- Turn off the motor
         bMotorLStrand := False;
         bMotorRStrand := False;
         iMotorCounter := 0; -- Reset counter
         -- Turn off all MOSFETS
         MicroBit.IOs.Set(pFetLT, False);
         MicroBit.IOs.Set(pFetRT, False);
         MicroBit.IOs.Set(pFetLB, False);
         MicroBit.IOs.Set(pFetRB, False);
      end if;

      -- Displays a 'F' if freefall is detected
      if bFreefallDetected then
         -- For now lets both strand run
         bMotorLStrand := True;
         bMotorRStrand := True;
      end if;
      --
      -- Read analogue pin 0, 1 and 2
      aValueLStrand := MicroBit.IOs.Analog(2);
      aValueRStrand := MicroBit.IOs.Analog(1);
      aValueMotor := MicroBit.IOs.Analog(0);
      -- Read digital MOSFET pins
      bValueFetLT := MicroBit.IOs.Set(pFetLT);
      bValueFetRT := MicroBit.IOs.Set(pFetRT);
      bValueFetLB := MicroBit.IOs.Set(pFetLB);
      bValueFetRB := MicroBit.IOs.Set(pFetRB);
      Console.Put_Line ("Value Mot : " & aValueMotor'Image &
                          " R Str : " & aValueRStrand'Image &
                          " L Str : " & aValueLStrand'Image &
                          " FetRT : " & bValueFetRT'Image &
                          " FetRB : " & bValueFetRB'Image &
                          " FetLT : " & bValueFetLT'Image &
                          " FetLB : " & bValueFetLB'Image);

      --
      Time.Sleep (50);
   end loop;
end Main;
