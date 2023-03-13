package body freefall_detection is

   function get_S_Factor_Sqrd (data : LSM303.All_Axes_Data) return S_Factor_Sqrd_t is
      S_factor : Integer;
      S_factor_type : S_Factor_Sqrd_t;
   begin
      S_factor := Integer(data.X ** 2 + data.Y ** 2 + data.Z ** 2);
      S_factor_type := S_Factor_Sqrd_t(S_factor);
      return S_factor_type;
   end get_S_Factor_Sqrd;

end freefall_detection;
