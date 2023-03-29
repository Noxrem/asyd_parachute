package motor is

   -- Runs the respective strand for the motor
   -- bMotorLStrand: Left MOSFET strand for the motor
   -- bMotorRStrand: Right MOSFET strand for the motor
   procedure Run (bMotorLStrand : in out Boolean; bMotorRStrand : in out Boolean);

end motor;
